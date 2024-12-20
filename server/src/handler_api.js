const serverless = require("serverless-http");
const apiServer = require("./server_api");
const logger = require("./logger/log");
const dbHandler = require("./database/database_handler");
const { DB_INSTANCES } = require("./database/databases");
const { printJson } = require("./utils/json_utils");

exports.handler = async (event, context) => {
  try {
    await dbHandler.connectToDatabase(DB_INSTANCES.DB_API);
    const serverlessHandler = serverless(apiServer.app);
    const response = await serverlessHandler(event, context);
    const result = {
      statusCode: 200,
      headers: {
        "Content-Type": "application/json", // Set Content-Type
      },
      body: JSON.stringify(response.body),
    };

    return result;
  } catch (error) {
    logger.info(error);
  }
};
