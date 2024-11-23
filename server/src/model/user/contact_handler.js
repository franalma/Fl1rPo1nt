const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const userContactCollection = "users_contacts";
const sockerHandler = require("../../sockets/socket_handler");
const userHandler = require("../user/user_handler");
const { printJson } = require("../../utils/json_utils");

async function createUserContactInternal(input) {
  logger.info("Starts createUserContactInternal");
  let doc = {
    user_id: input.user_id,
    contact_id: input.contact_id,
    qr_id: input.qr_id,
    flirt_id: input.flirt_id,
    location: input.location,
    created_at: Date.now(),
  };

  const contactInfo = await userHandler.getUserInfoByUserIdQrId(
    input.contact_id,
    input.qr_id
  );
  logger.info(JSON.stringify(contactInfo));
  doc.contact_info = contactInfo.contact_info;
  printJson(doc);
  return doc;
}

async function addUserContactByUserIdContactIdQrId(input) {
  logger.info("Starts addUserContactByUserIdContactIdQrId");
  let result = { status: 500 };
  
  try {  
    let doc = await createUserContactInternal(input);
    let dbResponse = await dbHandler.addDocument(doc, userContactCollection);
    

    if (dbResponse) {
      const updateUsersInfo = await userHandler.updateUserScansByUserIdContactId(
        doc.user_id,
        doc.contact_id
      );

      result = {
        status: 200,
        message: "Contact added sucessfully",
        contact_info: doc.contact_info,
        scans_performed: updateUsersInfo.scans_performed
      };
      const message = {
        requested_user_id: input.user_id,
      };
      sockerHandler.sendMessageToUser(
        "new_contact_request",
        input.contact_id,
        updateUsersInfo.scanned,
        message
      );
    }
  } catch (error) {
    logger.info(error);
  }

  printJson(result);
  return result;
}

async function removeUserContactByUserIdContactId(input) {
  logger.info("Starts removeUserContactByUserIdContactId");
}

async function getUserContactsByUserId(input) {
  logger.info("Starts getUserContactsByUserId");
  const filter = { user_id: input.user_id };
  let dbResponse = await dbHandler.findWithFilters(
    filter,
    userContactCollection
  );
  let result = {};

  if (dbResponse) {
    result.status = 200;
    result.contacts = [];
    for (var item of dbResponse) {
      result.contacts.push({
        user_id: item.user_id,
        contact_info: item.contact_info,
      });
    }
  }

  return result;
}

module.exports = {
  addUserContactByUserIdContactIdQrId,
  removeUserContactByUserIdContactId,
  getUserContactsByUserId,
};
