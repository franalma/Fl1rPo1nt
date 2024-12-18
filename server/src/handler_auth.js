const serverless = require('serverless-http');
const authServer = require('./server_auth');
const dbHandler = require("./database/database_handler");
const { DB_INSTANCES } = require("./database/databases");


exports.handler = async (event, context )=>{
    const result = await dbHandler.connectToDatabase(DB_INSTANCES.DB_AUTH);
    const serverlessHandler = serverless(authServer.app);    
    const response = await serverlessHandler(event, context);
    return response;
}