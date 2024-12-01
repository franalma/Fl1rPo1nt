const dbHandler = require("../../database/database_handler");
const logger = require("../../logger/log");
const { DB_INSTANCES } = require("../../database/databases");

async function getAllHobbies() {
  logger.info("Starts getAllHobbies");
  let result = { status: 200, values: [] };
  try {
    const db = DB_INSTANCES.DB_API;
    const values = await dbHandler.findAllWithClient(
      db.client,
      db.collections.hobbies_collection
    );
    for (var item of values) {
      result.values.push({
        id: item.id,
        name: item.name,
      });
    }
  } catch (error) {
    logger.info(error);
    result.status = 500;
  }

  return result;
}

module.exports = {
  getAllHobbies,
};
