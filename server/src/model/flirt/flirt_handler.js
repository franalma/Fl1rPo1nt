const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const logger = require("../../logger/log");
const { DB_INSTANCES } = require("../../database/databases");
const {
  HOST_ERROR_CODES,
  getError,
} = require("../../constants/host_error_codes");
const FLIRT_ACTIVE = 1;
const FLIRT_INACTIVE = 0;
// const flirtsCollection = "user_flirts";
// const userColletion = "users";

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
          relationship_id: input.relationship_id,
          relationship_name: input.relationship_name,
          sex_alternative_id: input.orientation_id,
          sex_alternative_name: input.orientation_name,
          location: {
            type: "Point",
            coordinates: [input.location.longitude, input.location.latitude],
          },

          status: FLIRT_ACTIVE,
          created_at: currentTime,
          updated_at: currentTime,
        };

        let dbResponse = await dbHandler.addDocumentWithClient(
          db.client,
          flirt,
          db.collections.flirts_collection
        );
        if (dbResponse) {
          result = {
            status: 200,
            message: "Flirt registered successfully",
            response: {
              flirt_id: flirt.flirt_id,
              created_at: flirt.created_at,
              status: FLIRT_ACTIVE,
              location: input.location,
            },
          };
        }
      } else {
        result = {
          status: 501,
          message: "There is another flirt active",
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
      //   const error = getError(HOST_ERROR_CODES.USER_NOT_EXIST);
      result = {
        status: 500,
        message: "User does not exists",
      };
    } else {
      let filters = {
        user_id: input.user_id,
        flirt_id: input.flirt_id,
      };

      let newDoc = {
        updated_at: Date.now(),
      };
      if (input.values.location) {
        newDoc.location = input.values.location;
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
          status: 200,
          message: "Flirt updated successfully",
          response: {
            flirt_id: newDoc.flirt_id,
            updated_at: newDoc.updated_at,
          },
        };
      } else {
        result = {
          status: 501,
          message: "Flirt update failed",
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
  let result = {};
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

    result.flirts = [];

    if (dbResponse) {
      result.status = 200;

      for (var item of dbResponse) {
        let flirt = {
          user_id: item.user_id,
          flirt_id: item.flirt_id,
          created_at: item.created_at,
          updated_at: item.updated_at,
          status: item.status,
          location: {
            latitude: item.location.coordinates[1],
            longitude: item.location.coordinates[0],
          },
          relationship_name: item.relationship_name,
          orientation_name: item.orientation_name,
        };
        result.flirts.push(flirt);
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getActiveFlirtsFromPointAndTendency(input) {
  logger.info("Starts getActiveFlirtsFromPointAndTendency");
  const db = DB_INSTANCES.DB_API;
  let result = {};
  try {
    let filters = {
      flirt_id: { $ne: input.flirt_id },
      location: {
        $near: {
          $geometry: {
            type: "Point",
            coordinates: [input.longitude, input.latitude],
          },
          $maxDistance: input.radio,
        },
      },
      status: 1,
      sex_alternative_id: input.sex_alternative_id,
    };

    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.flirts_collection
    );

    result.flirts = [];

    if (dbResponse) {
      result.status = 200;

      for (var item of dbResponse) {
        let flirt = {
          user_id: item.user_id,
          flirt_id: item.flirt_id,
          location: item.location,
          relationship_name: item.relationship_name,
          orientation_name: item.orientation_name,
        };
        result.flirts.push(flirt);
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

module.exports = {
  putUserFlirts,
  udpateUserFlirts,
  getUserFlirts,
  getActiveFlirtsFromPointAndTendency,
};
