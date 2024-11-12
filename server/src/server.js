require('dotenv').config();
const express = require('express');
const requestValidator = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const userHandler = require('./model/user/user_handler');
const contactHandler = require('./model/user/contact_handler');
const qrHandler = require("./model/qr/qr_handler");
const socialHandler = require("./model/social_network/social_network_handler");
const bulkHandler = require("./model/bulk/bulk_handler");
const bulkHostActions = require ("./constants/bulk_host_actions");

const app = express();
app.use(express.json());

const port = process.env.PORT


async function processAuthRequest(req, res) {
    logger.info("starts processAuthRequest");

    try {
        let result = requestValidator.requestDoValidation(req);
        if (result) {
            res.status(400).json(result);

        } else {
            const { action } = req.body;
            logger.info(action);
            switch (action) {
                case hostActions.PUT_USER: {
                    result = await userHandler.registerUser(req.body.input);
                    break;
                }
                case hostActions.DO_LOGIN: {
                    result = await userHandler.doLogin(req.body.input);
                    break;
                }
            }
            if (result && result.status) {
                res.status(result.status).json(result);
            } else {
                res.status(500).json({ message: "Error processing the request" });
            }
        }
    } catch (error) {
        logger.info("processAuthRequest:" + error);
    }
}

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
    }

    if (result == 0) {
        res.status(200).json({})
    } else {
        res.status(500).json({});
    }
}

async function processRequest(req, res) {
    logger.info("processRequest");

    try {
        let result = requestValidator.requestDoValidation(req);
        if (result) {
            res.status(400).json(result);

        } else {
            const { action } = req.body;
            logger.info(action);
            switch (action) {
                case hostActions.PUT_USER_QR_BY_USER_ID: {
                    result = await qrHandler.addUserQrByUserId(req.body.input);
                    break;
                }
                case hostActions.DELETE_USER_QR_BY_USER_ID_QR_ID: {
                    result = await qrHandler.removeUserQrByUserIdQrId(req.body.input);
                    break;
                }
                case hostActions.GET_USER_QR_BY_USER_ID: {
                    result = await qrHandler.getUserQrByUserId(req.body.input);
                    break;
                }
                case hostActions.GET_ALL_SOCIAL_NETWORKS: {
                    result = await socialHandler.getAllSocialNetworks();
                    break;
                }
                case hostActions.PUT_ALL_SOCIAL_NETWORKS: {
                    result = await socialHandler.putAllSocialNetworks(req.body.input);
                    break;
                }
                case hostActions.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID: {
                    result = await contactHandler.addUserContactByUserIdContactId(req.body.input);
                    break;
                }
                case hostActions.REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID: {
                    result = await contactHandler.removeUserContactByUserIdContactId(req.body.input);
                    break;
                }
                case hostActions.GET_USER_CONTACTS_BY_USER_ID: {
                    result = await contactHandler.getUserContactsByUserId(req.body.input);
                    break;
                }
                case hostActions.GET_USER_BY_DISTANCE_FROM_POINT:{
                    result = await userHandler.getUsersByDistanceFromPoint(req.body.input);
                    break;
                }



            }
            if (result && result.status) {
                res.status(result.status).json(result);
            } else {
                res.status(500).json({ message: "Error processing the request" });
            }
        }
    } catch (error) {
        logger.info("processRequest:" + error);
    }
}


app.post('/auth', requestValidator.requestFieldsValidation, (req, res) => {
    try {
        processAuthRequest(req, res);
    } catch (error) {
        logger.info(error);
    }

});

app.post('/api', requestValidator.requestAuthValidation, requestValidator.requestFieldsValidation, (req, res) => {
    processRequest(req, res);
});


app.post('/bulk', (req, res) => {
    procesBulkRequest(req, res);
});



app.listen(port, () => {
    dbHandler.connectToDatabase().then(result => {
        if (result == null) {
            throw 'Db connection error';
        } else {
            console.log(`El servidor está corriendo en el puerto ${port}`);
        }
    });

});