const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const userHandler = require("../user/user_handler");
const { DB_INSTANCES } = require("../../database/databases");
const {
  genError,
  HOST_ERROR_CODES,
} = require("../../constants/host_error_codes");

function createInternalPoint(input) {
  logger.info("Starts createInternalPoint:" + JSON.stringify(input));
  try {
    const now = Date.now();
    return {
      point_id: uuidv4(),
      user_id: input.user_id,
      qr_id: input.qr_id,
      created_at: now,
      updated_at: now,
      times_used: 0,
      status: 1,
    };
  } catch (error) {
    logger.info(error);
  }
  return {};
}

function createSmartPointExternal(input) {
  logger.info("Starts createSmartPointExternal:" + JSON.stringify(input));
  try {
    return {
      point_id: input.point_id,
      user_id: input.user_id,
      qr_id: input.qr_id,
      status: input.status,
    };
  } catch (error) {
    logger.info(error);
  }
}

async function putUserSmartPointByUserId(input) {
  logger.info("Starts putUserSmartPointByUserId" + JSON.stringify(input));
  try {
    const db = DB_INSTANCES.DB_API;
    const isExistUser = await userHandler.checkUserExist(input.user_id);
    if (isExistUser) {
      const isExistQr = await userHandler.checkQrExist(
        input.user_id,
        input.qr_id
      );
      if (isExistQr) {
        const point = createInternalPoint(input);
        const dbResult = await dbHandler.addDocumentWithClient(
          db.client,
          point
        );
        if (dbResult) {
          return {
            ...genError(HOST_ERROR_CODES.NO_ERROR),
            ...createSmartPointExternal(point),
          };
        }
      } else {
        return { ...genError(HOST_ERROR_CODES.QR_NOT_EXIST) };
      }
    } else {
      return { ...genError(HOST_ERROR_CODES.USER_NOT_EXIST) };
    }
  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function getAllSmartPointsByUserId(input) {
  logger.info("Starts getAllSmartPointsByUserId");
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { id: input.user_id };

    const dbResult = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.smart_points_coolection
    );
    if (dbResult && dbResult.length > 0) {
      let points = [];
      for (let item of dbResult) {
        points.push(createSmartPointExternal(item));
      }
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        points: points,
      };
    }
  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function getSmartPointByPointId(input) {
  logger.info("Starts getSmartPointByPointId");
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { point_id: input.point_id };
    const dbResult = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.smart_points_coolection
    );
    if (dbResult && dbResult.length > 0) {
      let points = [];
      for (let item of dbResult) {
        points.push(createSmartPointExternal(item));
      }
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        points: points,
      };
    }
  } catch (error) {
    logger.info(error);
  }
}

async function updaterSmartPointStatusByPointId(input) {
  logger.info("Starts disableSmartPointByPointId");
  try {
    const filter = { point_id: input.point_id };
    const newDoc = {
      updated_at: Date.now(),
      status: input.status,
    };

    const dbResult = await dbHandler.updateDocumentWithClient(
      db.client,
      newDoc,
      filter,
      db.collections.smart_points_coolection
    );
    if (dbResult && dbResult.length > 0) {
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        point_id: point_id,
      };
    }
  } catch (error) {
    logger.info(error);
  }
}

async function updateAllPointsStatusByUserId(input) {
  logger.info("Starts disableSmartPointByPointId");
  try {
    const filter = { user_id: input.user_id };
    const newDoc = {
      updated_at: Date.now(),
      status: input.status,
    };

    const dbResult = await dbHandler.updateDocumentWithClient(
      db.client,
      newDoc,
      filter,
      db.collections.smart_points_coolection
    );
    if (dbResult && dbResult.length > 0) {
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
      };
    }
  } catch (error) {
    logger.info(error);
  }
}

module.exports = {
  putUserSmartPointByUserId,
  getAllSmartPointsByUserId,
  getSmartPointByPointId,
  updaterSmartPointStatusByPointId,
  updateAllPointsStatusByUserId
};
