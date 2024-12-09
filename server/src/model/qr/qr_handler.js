const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const { DB_INSTANCES } = require("../../database/databases");

function createInternalQr(input) {
  logger.info("Start createInternalQr");
  const value = {
    qr_id: uuidv4(),
    user_id: input.user_id,
    qr_content: input.qr_content,
    created_at: Date.now(),
  };
  return value;
}

function createExternalQrInfo(item) {
  logger.info("Start createExternalQrInfo: " + JSON.stringify(item));
  return {
    user_id: item.user_id,
    qr_id: item.qr_id,
    qr_content: item.qr_content,
    name: item.name,
    networks: item.networks,
  };
}

async function addUserQrByUserId(input) {
  logger.info("Starts addUserQrByUserId: " + JSON.stringify(input));
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    let item = createInternalQr(input);
    let dbResponse = await dbHandler.addDocumentWithClient(
      db.client,
      item,
      db.collections.user_collection
    );

    if (dbResponse) {
      result = {
        status: 200,
        message: "QR added successfully",
        response: {
          user_id: item.user_id,
          qr_id: item.qr_id,
          create_at: item.created_at,
        },
      };
      return result;
    }
  } catch (error) {
    logger.info(error);
  }
}

async function removeUserQrByUserIdQrId(input) {
  logger.info("Starts removeUserQrByUserIdQrId: " + JSON.stringify(input));
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    let filters = { user_id: input.user_id, qr_id: input.qr_id };
    let result = {};
    let dbResponse = await dbHandler.deleteDocumentWithClient(
      db.client,
      filters,
      db.collections.user_collection
    );
    if (dbResponse) {
      result = {
        status: 200,
        message: "QR removed successfully",
      };
      return result;
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}

async function getUserQrByUserId(input) {
  logger.info("Starts getUserQrByUserId: " + JSON.stringify(input));
  let result = { items: [] };
  try {
    const db = DB_INSTANCES.DB_API;
    let filters = { id: input.user_id };
    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_collection
    );

    if (dbResponse) {
      result.status = 200;
      result.items = [];
      for (let index in dbResponse[0].qr_values) {
        let item = createExternalQrInfo(dbResponse[0].qr_values[index]);
        result.items.push(item);
      }
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}



module.exports = {
  addUserQrByUserId,
  removeUserQrByUserIdQrId,
  getUserQrByUserId,
  
};
