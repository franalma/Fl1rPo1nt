const logger = require("../../logger/log");
const dbHandler = require("../../database/database_handler");
const { DB_INSTANCES } = require("../../database/databases");
const {
  HOST_ERROR_CODES,
  genError,
} = require("../../constants/host_error_codes");
const { Logform } = require("winston");

function createSocialNetWork(item) {
  logger.info("Starts createSocialNetWork: " + JSON.stringify(item));
  result = {
    social_network_id: item.id,
    name: item.name,
    created_at: Date.now(),
  };
  return result;
}

function createSocialNetworkExternal(item) {
  result = {
    social_network_id: item.id,
    name: item.name,
  };
  return result;
}

function createSubscriptionExternal(item) {
  result = {
    id: item.id,
    ads: item.ads,
    radio_visibility: item.radio_visibility,
    smart_points: item.smart_points,
    background: item.background,
  };
  return result;
}

function createGenderExternal(item) {
  result = {
    id: item.id,
    name: item.name,
    color: item.color,
  };
  return result;
}

async function putAllSocialNetworks(input) {
  try {
    logger.info(
      "Starts putAllSocialNetworks: " + JSON.stringify(input.networks)
    );
    const db = DB_INSTANCES.DB_API;

    for (let network of input.networks) {
      logger.info("network info: " + JSON.stringify(network));
      let item = createSocialNetWork(network);

      const dbResponse = await dbHandler.addDocumentWithClient(
        db.client,
        item,
        db.collections.social_networks_collection
      );
      if (dbResponse) {
        return { ...genError(HOST_ERROR_CODES.NO_ERROR) };
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function getAllSocialNetworks() {
  logger.info("Starts getAllSocialNetworks");

  try {
    const db = DB_INSTANCES.DB_API;
    const dbResponse = await dbHandler.findAllWithClient(
      db.client,
      db.collections.social_networks_collection
    );

    if (dbResponse) {
      let networksValues = [];
      for (let network of dbResponse) {
        let item = createSocialNetworkExternal(network);
        networksValues.push(item);
      }
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        networks: networksValues,
      };
    }
  } catch (error) {
    logger.info(error);
  }

  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
    networks: [],
  };
}

async function getAllGenders() {
  logger.info("Starts getAllGenders");
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const dbResponse = await dbHandler.findAllWithClient(
      db.client,
      db.collections.genders_collection
    );

    if (dbResponse) {
      result.status = 200;
      result.genders = [];
      for (let network of dbResponse) {
        let item = createGenderExternal(network);
        result.genders.push(item);
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getAllSexualOrientationsRelationships() {
  logger.info("Starts getAllSexualOrientationsRelationships");

  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    result.sex_orientation = [];
    result.type_relationships = [];
    let dbResponse = await dbHandler.findAllWithClient(
      db.client,
      db.collections.sex_orientations_collection
    );

    if (dbResponse) {
      for (let item of dbResponse) {
        let value = {
          id: item.id,
          name: item.name,
          color: item.color,
          description: item.description,
        };
        result.sex_orientation.push(value);
      }
      let dbResponse2 = await dbHandler.findAllWithClient(
        db.client,
        db.collections.type_relationships_collection
      );
      for (let item of dbResponse2) {
        let value = {
          id: item.id,
          name: item.name,
          color: item.color,
          description: item.description,
        };
        result.type_relationships.push(value);
      }

      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        ...result,
      };
    }
  } catch (error) {
    logger.info(error);
  }

  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
    ...result,
  };
}

async function getAllSubscriptionTypes() {
  logger.info("Starts getAllSubscriptionTypes");
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const dbResponse = await dbHandler.findAllWithClient(
      db.client,
      db.collections.subscription_collection
    );

    if (dbResponse) {
      var subscriptions = [];
      for (let item of dbResponse) {
        let subs = createSubscriptionExternal(item);
        subscriptions.push(subs);
      }
      result = {
        ...HOST_ERROR_CODES.NO_ERROR,
        subscriptions: subscriptions,
      };
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}

module.exports = {
  putAllSocialNetworks,
  getAllSocialNetworks,
  getAllSexualOrientationsRelationships,
  getAllGenders,
  getAllSubscriptionTypes,
};
