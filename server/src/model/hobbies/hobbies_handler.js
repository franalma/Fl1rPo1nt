const hobbies_collection = "hobbies_collection";
const dbHandler = require('../../database/database_handler');
const logger = require("../../logger/log");

async function getAllHobbies() {
    logger.info("Starts getAllHobbies");
    let result = { status: 200, values: [] };
    try {
        const values = await dbHandler.findAll(hobbies_collection);
        for (var item of values) {
            result.values.push({
                id: item.id,
                name: item.name
            });
        }
    } catch (error) {
        logger.info(error);
        result.status = 500;
    }

    return result;

}


module.exports = {
    getAllHobbies
}