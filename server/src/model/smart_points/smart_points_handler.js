const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const userHandler = require("../user/user_handler");
const { DB_INSTANCES } = require("../../database/databases");
const {
  genError,
  HOST_ERROR_CODES,
} = require("../../constants/host_error_codes");

const MAX_SMART_POINTS_NUMBER = 3;


function createInternalPoint(input) {
  logger.info("Starts createInternalPoint:" + JSON.stringify(input));
  try {
    const now = Date.now();
    return {
      point_id: uuidv4(),
      user_id: input.user_id,
      user_name: input.name ? input.name : "",
      user_phone: input.phone ? input.phone : "",
      networks: input.networks ? input.networks : [],
      created_at: now,
      updated_at: now,
      times_used: 0,
      audios: input.audios, 
      pictures: input.pictures,
      //it is not recorded wait for nfc on device
      status: -1,
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
      status: input.status,
      user_name: input.user_name,
      user_phone: input.user_phone,
      networks: input.networks,
      times_used: input.times_used,
      audios: input.audios, 
      pictures: input.pictures,
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
      const resPoints = await getAllSmartPointsByUserId(input.user_id);
      if (resPoints.points.length >= MAX_SMART_POINTS_NUMBER) {
        return {
          ...genError(HOST_ERROR_CODES.NOT_POSSIBLE_TO_ADD_POINT)
        }

      }
      const point = createInternalPoint(input);
      const dbResult = await dbHandler.addDocumentWithClient(
        db.client,
        point,
        db.collections.smart_points_coolection
      );
      if (dbResult) {
        const result = {
          ...genError(HOST_ERROR_CODES.NO_ERROR),
          point: createSmartPointExternal(point),
        }
        logger.info("result point: " + JSON.stringify(result));
        return result;
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
    const filter = { user_id: input.user_id };

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
    return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR), error: error };
  }
  return {
    ...genError(HOST_ERROR_CODES.NO_ERROR),
    points: [],
  };
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


      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        point: createSmartPointExternal(dbResult[0]),
      };
    }
  } catch (error) {
    logger.info(error);
  }
}

async function updaterSmartPointStatusByPointId(input) {
  logger.info("Starts updaterSmartPointStatusByPointId");
  try {
    const db = DB_INSTANCES.DB_API;
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
    return {
      ...genError(HOST_ERROR_CODES.NO_ERROR),
      point_id: input.point_id,
    };
  } catch (error) {
    logger.info(error);
  }
  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),

  };
}

async function updateAllPointsStatusByUserId(input) {
  logger.info("Starts updateAllPointsStatusByUserId");
  try {
    const db = DB_INSTANCES.DB_API;
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

async function removeSmartPointByPointId(input) {
  logger.info("Starts removeSmartPointByPointId");
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { point_id: input.point_id };
    const dbResult = await dbHandler.deleteDocumentWithClient(
      db.client,
      filter,
      db.collections.smart_points_coolection
    );
    return {
      ...genError(HOST_ERROR_CODES.NO_ERROR),
    };
  } catch (error) {
    logger.info(error);
  }
  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
  };
}

module.exports = {
  putUserSmartPointByUserId,
  getAllSmartPointsByUserId,
  getSmartPointByPointId,
  updaterSmartPointStatusByPointId,
  updateAllPointsStatusByUserId,
  removeSmartPointByPointId
};
