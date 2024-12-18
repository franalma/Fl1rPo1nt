require("dotenv").config();
const { printJson } = require("./utils/json_utils");
const express = require("express");
const logger = require("./logger/log");
const dbHandler = require("./database/database_handler");
const bulkHandler = require("./model/bulk/bulk_handler");
const bulkHostActions = require("./constants/bulk_host_actions");
const http = require("http");

const app = express();
app.use(express.json());
const port = process.env.SERVER_PORT_BULK;
const server = http.createServer(app);


async function procesBulkRequest(req, res) {
    const { action } = req.body;
    let result = -1;
    switch (action) {
      case bulkHostActions.BULK_TEST_COORDINATE: {
        result = await bulkHandler.addBulkCoordinates(req.body.input);
        break;
      }
      case bulkHostActions.BULK_LOAD_SEX_ORIENTATIONS: {
        result = await bulkHandler.addSexOrientation(req.body.input);
        break;
      }
      case bulkHostActions.BULK_LOAD_TYPE_RELATIONSHIPS: {
        result = await bulkHandler.addTypeRelationships(req.body.input);
        break;
      }
      case bulkHostActions.BUKL_PUT_ALL_SOCIAL_NETWORKS: {
        result = await bulkHandler.addBaseNetworks(req.body.input);
        break;
      }
      case bulkHostActions.BULK_PUT_ALL_HOBBIES: {
        result = await bulkHandler.addHobbies(req.body.input);
        break;
      }
      case bulkHostActions.BULK_PUT_ALL_GENDERS: {
        result = await bulkHandler.addGenderIdentity(req.body.input);
        break;
      }
      case bulkHostActions.BULK_POPULATE_USERS:{
        logger.info("populating users");
        for (let item of req.body.input){
          result = await bulkHandler.bulkPopulateUsers(item);
        }
        
        break; 
      }
    }
    logger.info("Request response: "+result);
    if (result == 0) {
      res.status(200).json({});
    } else {
      res.status(500).json({});
    }
  }

  app.post("/", (req, res) => {
    procesBulkRequest(req, res);
  });
  
  
  server.listen(port, () => {
    console.log(`El servidor BULK está corriendo en el puerto ${port}`);
  });
  