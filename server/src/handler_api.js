require("dotenv").config();
const serverless = require("serverless-http");
const logger = require("./logger/log");
const { printJson } = require("./utils/json_utils");
const dbHandler = require("./database/database_handler");
const { DB_INSTANCES } = require("./database/databases");
const apiServer = require("./server_api");
const authServer = require('./server_auth');

switch (process.env.HANDLER) {
    case "api": {

        exports.handler = async (event, context) => {
            try {
                await dbHandler.connectToDatabase(DB_INSTANCES.DB_API);
                const serverlessHandler = serverless(apiServer.app);
                const response = await serverlessHandler(event, context);
                const result = {
                    headers: {
                        "Content-Type": "application/json", // Set Content-Type
                    },
                    body: response.body,
                };

                return result;
            } catch (error) {
                logger.info(error);
            }
        };
        break;
    }

    case "auth":
        exports.handler = async (event, context) => {
            await dbHandler.connectToDatabase(DB_INSTANCES.DB_AUTH);
            const serverlessHandler = serverless(authServer.app);
            const response = await serverlessHandler(event, context);
            const result = {
                headers: {
                    "Content-Type": "application/json", // Set Content-Type
                },
                body: response.body,
            };

            return result;
        }
        
}


