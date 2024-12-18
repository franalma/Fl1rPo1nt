const serverless = require('serverless-http');
const apiServer = require('./server_api');
const dbHandler = require("./database/database_handler");
const { DB_INSTANCES } = require("./database/databases");


exports.handler = async (event, context )=>{
    const result = await dbHandler.connectToDatabase(DB_INSTANCES.DB_API);
    const serverlessHandler = serverless(apiServer.app);    
    const response = await serverlessHandler(event, context);
    return response;
}