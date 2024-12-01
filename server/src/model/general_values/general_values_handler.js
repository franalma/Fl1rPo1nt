const logger = require("../../logger/log");
const dbHandler = require("../../database/database_handler");
const { DB_INSTANCES } = require("../../database/databases");

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

function createGenderExternal(item) {
  result = {
    id: item.id,
    name: item.name,
    color: item.color,
  };
  return result;
}

async function putAllSocialNetworks(input) {
  let result = {};
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
        result = {
          status: 200,
          message: "Social networks created successfully",
        };
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getAllSocialNetworks() {
  logger.info("Starts getAllSocialNetworks");
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const dbResponse = await dbHandler.findAllWithClient(
      db.client,
      db.social_networks_collection
    );

    if (dbResponse) {
      result.status = 200;
      result.networks = [];
      for (let network of dbResponse) {
        let item = createSocialNetworkExternal(network);
        result.networks.push(item);
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
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
      let dbResponse2 = await dbHandler.findAll(typeRelationshipsCollection);
      for (let item of dbResponse2) {
        let value = {
          id: item.id,
          name: item.name,
          color: item.color,
          description: item.description,
        };
        result.type_relationships.push(value);
      }
      result.status = 200;
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
};
