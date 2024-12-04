const dbHandler = require("../../database/database_handler");
const logger = require("../../logger/log");
const { DB_INSTANCES } = require("../../database/databases");
const { HOST_ERROR_CODES, genError } = require("../../constants/host_error_codes")

async function getAllHobbies() {
  logger.info("Starts getAllHobbies");
  let result = { values: [] };
  try {
    const db = DB_INSTANCES.DB_API;
    const values = await dbHandler.findAllWithClient(
      db.client,
      db.collections.hobbies_collection
    );
    let hobbies = [];
    for (var item of values) {
      hobbies.push({
        id: item.id,
        name: item.name,
      });
    }
    result = { ...genError(HOST_ERROR_CODES.NO_ERROR), values: hobbies };
  } catch (error) {
    logger.info(error);
    result = { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
  }

  return result;
}

module.exports = {
  getAllHobbies,
};
