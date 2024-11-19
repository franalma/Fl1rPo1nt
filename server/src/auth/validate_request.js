const tokenHandler = require("./token_generator");
const logger = require("../logger/log");
const { body, validationResult } = require('express-validator');
const validationRules = require('../validators/validation_rules');
const hostActions = require("../constants/host_actions");
let validationSet = [];

function requestAuthValidation(req, res, next) {
    logger.info("Init");
    const authHeader = req.headers['authorization'];

    logger.info(JSON.stringify(req.headers));
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'auth token not found' });
    }

    const isTokenValid = tokenHandler.verifyToken(token);

    if (isTokenValid) {
        next();
    } else {
        res.status(403).json({ message: 'No valid token or expired' });
    }

}

function requestFieldsValidation(req, res, next) {
    logger.info("custom requestFieldsValidation");
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
        // case hostActions.PUT_USER_QR_BY_USER_ID:{
        //     validationSet = validationRules.PUT_QR_BY_USER_ID_RULES;
        //     break; 
        // }
        // case hostActions.DELETE_USER_QR_BY_USER_ID_QR_ID:{
        //     validationSet = validationRules.REMOVE_QR_BY_USER_ID_QR_ID_RULES;
        //     break; 
        // }
        // case hostActions.GET_USER_QR_BY_USER_ID:{
        //     validationSet = validationRules.GET_QR_BY_USER_ID_RULES;
        //     break; 
        // }
        case hostActions.PUT_ALL_SOCIAL_NETWORKS:{
            validationSet = validationRules.PUT_ALL_SOCIAL_NETWORKS_RULES;
            break; 
        }
        case hostActions.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID:{
            validationSet = validationRules.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID_RULES;
            break; 
        }
        case hostActions.REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID:{
            validationSet = validationRules.REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES;
            break; 
            
        }
        case hostActions.GET_USER_CONTACTS_BY_USER_ID:{
            validationSet = validationRules.GET_USER_CONTACTS_BY_USER_ID_RULES
            break; 
        }
        case hostActions.GET_USER_BY_DISTANCE_FROM_POINT:{
            validationSet = validationRules.GET_USER_BY_DISTANCE_FROM_POINT_RULES
            break; 
        }
        case hostActions.UPDATE_USER_NETWORK_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_NETWORK_BY_USER_ID_RULES
            break; 
        }
        case hostActions.UPDATE_USER_SEARCHING_RANGE_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_SEARCHING_RANGE_BY_USER_ID_RULES
            break; 
        }
        case hostActions.UPDATE_USER_INTERESTS_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_INTERESTS_BY_USER_ID_RULES
            break; 
        }
        case hostActions.UPDATE_USER_QRS_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_QRS_BY_USER_ID_RULES
            break; 
        }
        case hostActions.PUT_USER_FLIRT_BY_USER_ID:{
            validationSet = validationRules.PUT_USER_FLIRT_BY_USER_ID_RULES
            break; 
        }

        case hostActions.UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID:{
            validationSet = validationRules.UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID_RULES
            break; 
        }

        case hostActions.GET_USER_FLIRTS:{
            validationSet = validationRules.GET_USER_FLIRTS_RULES
            break; 
        }
        case hostActions.GET_USER_IMAGES_BY_USER_ID:{
            validationSet = validationRules.GET_USER_IMAGES_BY_USER_RULES
            break; 
        }
        case hostActions.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID:{
            validationSet = validationRules.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_RULES
            break; 
        }
        case hostActions.UPDATE_USER_BIOGRAPHY_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_BIOGRAPHY_BY_USER_RULES
            break; 
        }

        case hostActions.UPDATE_USER_HOBBIES_BY_USER_ID:{
            validationSet = validationRules.UPDATE_USER_HOBBIES_BY_USER_RULES
            break; 
        }

        

        
        
        
        
        

        default:{
            logger.info("No request verification needed for "+action);
            validationSet = [];
        }


    }

    Promise.all(validationSet.map(validation => validation.run(req)))
        .then(() => next())
        .catch(next);
}

function requestDoValidation(req) {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
        return { errors: errors.array() };
    }
    return null;
}

module.exports = {
    requestAuthValidation,
    requestFieldsValidation, 
    requestDoValidation
}