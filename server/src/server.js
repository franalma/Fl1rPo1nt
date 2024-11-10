require('dotenv').config();
const express = require('express');
const authenticateToken = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const { body, validationResult } = require('express-validator');
const validationRules = require('./validators/validation_rules');
const userHandler = require('./model/user/user_handler');


let validationSet = [];
const app = express();
app.use(express.json());

const port = process.env.PORT


function customValidation(req, res, next) {
    logger.info("custom validation");
    const { action } = req.body;
    switch (action) {
        case hostActions.PUT_USER: {
            validationSet = validationRules.NEW_USER_VALIDATION_RULES;
            break;
        }
        case hostActions.DO_LOGIN: {
            validationSet = validationRules.DO_LOGIN_RULES;
            break;
        }
    }

    Promise.all(validationSet.map(validation => validation.run(req)))
        .then(() => next())
        .catch(next);
}



function doValidation(req) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return { errors: errors.array() };
    }
    return null;
}


async function processAuthRequest(req, res) {
    logger.info("starts processAuthRequest");

    try {
        let result = doValidation(req);
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

app.post('/auth', customValidation, (req, res) => {
    try {
        processAuthRequest(req, res);
    } catch (error) {
        logger.info(error);
    }

});

// app.post('/api', authenticateToken, (req, res) => {
//     processRequest(req, res);
// });




app.listen(port, () => {
    dbHandler.connectToDatabase().then(result => {
        if (result == null) {
            throw 'Db connection error';
        } else {
            console.log(`El servidor está corriendo en el puerto ${port}`);
        }
    });

});