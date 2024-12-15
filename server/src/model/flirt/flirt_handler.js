const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const logger = require("../../logger/log");
const matchHandler = require("../user/mach_handler");
const { DB_INSTANCES } = require("../../database/databases");
const {
  HOST_ERROR_CODES,
  getError,
  genError,
} = require("../../constants/host_error_codes");
const { printJson } = require("../../utils/json_utils");
const FLIRT_ACTIVE = 1;
const FLIRT_INACTIVE = 0;


function createInternalUserCoordinates(input) {
  logger.info("Starts createInternalUserCoordinates");
  try {
    const doc = {
      id: uuidv4(),
      user_id: input.user_id,
      flirt_id: input.flirt_id,
      created_at: Date.now(),
      location: input.location
    }
  } catch (error) {
    logger.info(error);
  }
  return null;
}


function createOutputFlirt(item) {
  logger.info("Starts createOutputFlirt");
  try {
    let flirt = {
      user_id: item.user_id,
      flirt_id: item.flirt_id,
      location: [item.location.coordinates[1], item.location.coordinates[0]],
      user_interests: item.user_interests,
      gender: item.gender,
      updated_at: item.updated_at,
      status: item.status,
      age:item.age
    };
    return flirt;
  } catch (error) {
    logger.info(error);
  }
  return {};

}

function transformLocationForInternalUse(inputLocation) {
  logger.info("Starts transformLocationForInternalUse");
  try {
    return {
      value: {
        type: "Point",
        coordinates: [inputLocation.longitude, inputLocation.latitude],
      },
    }
  } catch (error) {
    logger.info(error);
  }
  return {}
}

async function putUserFlirts(input) {
  logger.info("Starts putUserFlirts");
  let result = {};

  try {
    const db = DB_INSTANCES.DB_API;
    let checkExist = await dbHandler.findWithFiltersAndClient(
      db.client,
      { id: input.user_id },
      db.collections.user_collection
    );

    if (!checkExist) {
      result.status = 500;
      result.message = "User does not exists";
    } else {
      const currentTime = Date.now();

      //check if there is any active flirt for user_id
      checkExist = await dbHandler.findWithFiltersAndClient(
        db.client,
        { user_id: input.user_id, status: FLIRT_ACTIVE },
        db.collections.flirts_collection
      );
      if (checkExist.length == 0) {
        let flirt = {
          flirt_id: uuidv4(),
          user_id: input.user_id,
          user_interests: input.user_interests,
          location: {
            type: "Point",
            coordinates: [input.location.longitude, input.location.latitude],
          },
          gender: input.gender,

          status: FLIRT_ACTIVE,
          created_at: currentTime,
          updated_at: currentTime,
          age:input.age
        };

        await dbHandler.addDocumentWithClient(
          db.client,
          flirt,
          db.collections.flirts_collection
        );      
        result = {
          ...genError(HOST_ERROR_CODES.NO_ERROR),
          message: "Flirt registered successfully",
          response:
            createOutputFlirt(flirt)
        }
      } else {
        result = {
          ...genError(HOST_ERROR_CODES.FLIRT_ACTIVE_ISSUE),
          ...checkExist[0].id
        };
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function udpateUserFlirts(input) {
  logger.info("Starts udpateUserFlirts");
  let result = {};

  try {
    const db = DB_INSTANCES.DB_API;
    let checkExist = await dbHandler.findWithFiltersAndClient(
      db.client,
      { id: input.user_id },
      db.collections.user_collection
    );

    if (!checkExist) {

      result = {
        ...genError(HOST_ERROR_CODES.USER_NOT_EXIST)
      };
    } else {
      let filters = {
        // user_id: input.user_id,
        flirt_id: input.flirt_id,
      };

      let newDoc = {
        updated_at: Date.now(),
      };
      if (input.values.location) {
        newDoc.location = transformLocationForInternalUse(input.values.location).value;
      }
      if (input.values.status != null) {
        newDoc.status = input.values.status;
      }

      //check if there is any active flirt for user_id
      const dbResponse = await dbHandler.updateDocumentWithClient(
        db.client,
        newDoc,
        filters,
        db.collections.flirts_collection
      );
      if (dbResponse) {
        result = {
          ...genError(HOST_ERROR_CODES.NO_ERROR),
          response: {
            flirt_id: newDoc.flirt_id,
            updated_at: newDoc.updated_at,
          },
        };
      } else {
        result = {
          ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR)
        };
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getUserFlirts(input) {
  logger.info("Starts getUserFlirts");

  try {
    const db = DB_INSTANCES.DB_API;
    let filters = {};
    filters.user_id = input.filters.user_id;

    if (input.filters.status != null) {
      filters.status = input.filters.status;
    }

    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.flirts_collection
    );

    let flirts = [];

    if (dbResponse) {


      for (var item of dbResponse) {
        const flirt = createOutputFlirt(item);
        flirts.push(flirt);
      }
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        flirts: flirts
      }

    } else {
      logger.info("-->No flirts");
      return {
        ...genError(HOST_ERROR_CODES.NO_FLIRTS_FOUND),
        flirts: flirts
      }

    }
  } catch (error) {
    logger.info(error);
  }

  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function getActiveFlirtsFromPointAndTendency(input) {
  logger.info("Starts getActiveFlirtsFromPointAndTendency: " + JSON.stringify(input));
  const db = DB_INSTANCES.DB_API;
  let result = {};
  try {
    input.include_disabled = true; 
    let matchs = (await matchHandler.getAllUserMatchsByUserId(input)).matchs;
    printJson(matchs);
    let userContacts = matchs.map((e) => e.contact.user_id);

    let filters = {
      flirt_id: { $ne: input.flirt_id },
      user_id: { $nin: userContacts },
      location: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [input.longitude, input.latitude],
          },
          $maxDistance: input.radio*1000,
        },
      },
      age: { $gte: input.age_from, $lte: input.age_to },
      status: FLIRT_ACTIVE,

    };

    if (input.filters_enabled == true) {
      filters["user_interests.relationship.id"] = input.relationship.id;
      filters["user_interests.sex_alternative.id"] = input.sex_alternative.id;
      filters["user_interests.gender_interest.id"] = input.gender.id;
      filters["gender.id"] = input.gender_interest.id;

    }
    logger.info("---filters: " + JSON.stringify(filters));


    let dbResponse = await dbHandler.findWithFiltersAndClientWitPagination(
      db.client,
      filters,
      db.collections.flirts_collection
    );

    let flirts = [];

      printJson(dbResponse);
    if (dbResponse) {
      for (var item of dbResponse.documents) {
        // let flirt = {
        //   user_id: item.user_id,
        //   flirt_id: item.flirt_id,
        //   location: [item.location.coordinates[1], item.location.coordinates[0]],
        //   user_interests: item.user_interests,
        //   gender: item.gender,
        //   updated_at: item.updated_at,
        //   status: item.status

        // };
        let flirt = createOutputFlirt(item);
        flirts.push(flirt);
      }
      result = { ...genError(HOST_ERROR_CODES.NO_ERROR), flirts };
      printJson(result);
      return result;
    }
  } catch (error) {
    logger.info(error);
  }

  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

module.exports = {
  putUserFlirts,
  udpateUserFlirts,
  getUserFlirts,
  getActiveFlirtsFromPointAndTendency,
};
