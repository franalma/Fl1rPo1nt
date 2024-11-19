require('dotenv').config();
const express = require('express');
const requestValidator = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const userHandler = require('./model/user/user_handler');
const contactHandler = require('./model/user/contact_handler');
const qrHandler = require("./model/qr/qr_handler");
const generalValuesHandler = require("./model/general_values/general_values_handler");
const bulkHandler = require("./model/bulk/bulk_handler");
const bulkHostActions = require("./constants/bulk_host_actions");
const flirtHandler = require("./model/flirt/flirt_handler");
const socketHandler = require("./sockets/socket_handler");
const http = require('http');
const fileHandler = require("./images/file_handler");
const app = express();
app.use(express.json());
const port = process.env.PORT
const server = http.createServer(app);
socketHandler.socketInit(server);

const upload = fileHandler.config();


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
                    result = await generalValuesHandler.getAllSocialNetworks();
                    break;
                }
                case hostActions.PUT_ALL_SOCIAL_NETWORKS: {
                    result = await generalValuesHandler.putAllSocialNetworks(req.body.input);
                    break;
                }
                case hostActions.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID: {
                    result = await contactHandler.addUserContactByUserIdContactIdQrId(req.body.input);
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
                case hostActions.GET_USER_BY_DISTANCE_FROM_POINT: {
                    result = await userHandler.getUsersByDistanceFromPoint(req.body.input);
                    break;
                }
                case hostActions.UPDATE_USER_NETWORK_BY_USER_ID: {
                    result = await userHandler.updateUserNetworksByUserId(req.body.input);
                    break;
                }
                case hostActions.UPDATE_USER_SEARCHING_RANGE_BY_USER_ID: {
                    result = await userHandler.updateUserSearchingRangeByUserId(req.body.input);
                    break;
                }

                case hostActions.GET_ALL_SEXUAL_ORIENTATIONS_RELATIONSHIPS: {
                    result = await generalValuesHandler.getAllSexualOrientationsRelationships(req.body.input);
                    break;
                }

                case hostActions.UPDATE_USER_INTERESTS_BY_USER_ID: {
                    result = await userHandler.updateUserInterestsByUserId(req.body.input);
                    break;
                }

                case hostActions.UPDATE_USER_QRS_BY_USER_ID: {
                    result = await userHandler.updateUserQrsByUserId(req.body.input);
                    break;
                }

                case hostActions.PUT_USER_FLIRT_BY_USER_ID: {
                    result = await flirtHandler.putUserFlirts(req.body.input);
                    break;
                }

                case hostActions.UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID: {
                    result = await flirtHandler.udpateUserFlirts(req.body.input);
                    break;
                }
                case hostActions.GET_USER_FLIRTS: {
                    result = await flirtHandler.getUserFlirts(req.body.input);
                    break;
                }
                case hostActions.GET_USER_IMAGES_BY_USER_ID: {
                    result = await fileHandler.getUserImagesByUserId(req.body.input);
                    break;
                }
                case hostActions.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID: {
                    result = await fileHandler.removeUserImageByImageIdUserId(req.body.input);
                    break;
                }
                case hostActions.UPDATE_USER_BIOGRAPHY_BY_USER_ID: {
                    result = await userHandler.updateUserBiographyByUserId(req.body.input);
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

app.post('/upload', requestValidator.requestAuthValidation, upload.single('image'), (req, res) => {
    if (!req.file) {
        return res.status(400).send('No file uploaded.');
    }
    const userId = req.body.user_id;

    fileHandler.doUploadImageByUserId(req, userId).then((result) => {
        console.log("---result: " + result);
        if (result) {
            res.status(200).json(result);
        } else {
            res.status(501).json({
                message: "Not possible to add image"
            })
        }
    });

});

app.get('/protected-image/:file_id', requestValidator.requestAuthValidation, (req, res) => {
    const fileId = req.params.file_id;
    fileHandler.getImageByUrl(fileId).then((result)=>{
        console.log(result);
        if (result!=null){
            res.status(200).sendFile(result.filepath);
        }else{
            res.status(404);
        }
    });     
});



server.listen(port, () => {
    dbHandler.connectToDatabase().then(result => {
        if (result == null) {
            throw 'Db connection error';
        } else {
            console.log(`El servidor está corriendo en el puerto ${port}`);
        }
    });

});