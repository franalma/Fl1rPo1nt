const tokenHandler = require("./token_generator");
const logger = require("../logger/log");
const { body, validationResult } = require("express-validator");
const validationRules = require("../validators/validation_rules");
const hostActions = require("../constants/host_actions");
const { printJson } = require("../utils/json_utils");
let validationSet = [];

function requestAuthValidation(req, res, next) {
  logger.info("Starts requestAuthValidation");
  const authHeader = req.headers["authorization"];

  logger.info(JSON.stringify(req.headers));
  const token = authHeader && authHeader.split(" ")[1];

  if (!token) {
    return res.status(401).json({ message: "auth token not found" });
  }

  const isTokenValid = tokenHandler.verifyToken(token);

  if (isTokenValid) {
    next();
  } else {
    res.status(403).json({ message: "No valid token or expired" });
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
    case hostActions.PUT_ALL_SOCIAL_NETWORKS: {
      validationSet = validationRules.PUT_ALL_SOCIAL_NETWORKS_RULES;
      break;
    }
    case hostActions.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID: {
      validationSet =
        validationRules.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID_RULES;
      break;
    }
    case hostActions.REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID: {
      validationSet =
        validationRules.REMOVE_USER_CONTACT_BY_USER_ID_CONTACT_ID_RULES;
      break;
    }
    case hostActions.GET_USER_CONTACTS_BY_USER_ID: {
      validationSet = validationRules.GET_USER_CONTACTS_BY_USER_ID_RULES;
      break;
    }
    case hostActions.GET_USER_BY_DISTANCE_FROM_POINT: {
      validationSet = validationRules.GET_USER_BY_DISTANCE_FROM_POINT_RULES;
      break;
    }
    case hostActions.UPDATE_USER_NETWORK_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_NETWORK_BY_USER_ID_RULES;
      break;
    }
    case hostActions.UPDATE_USER_SEARCHING_RANGE_BY_USER_ID: {
      validationSet =
        validationRules.UPDATE_USER_SEARCHING_RANGE_BY_USER_ID_RULES;
      break;
    }
    case hostActions.UPDATE_USER_INTERESTS_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_INTERESTS_BY_USER_ID_RULES;
      break;
    }
    case hostActions.UPDATE_USER_QRS_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_QRS_BY_USER_ID_RULES;
      break;
    }
    case hostActions.PUT_USER_FLIRT_BY_USER_ID: {
      validationSet = validationRules.PUT_USER_FLIRT_BY_USER_ID_RULES;
      break;
    }

    case hostActions.UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID: {
      validationSet =
        validationRules.UPDATE_USER_FLIRT_BY_USER_ID_FLIRT_ID_RULES;
      break;
    }

    case hostActions.GET_USER_FLIRTS: {
      validationSet = validationRules.GET_USER_FLIRTS_RULES;
      break;
    }
    case hostActions.GET_USER_IMAGES_BY_USER_ID: {
      validationSet = validationRules.GET_USER_IMAGES_BY_USER_RULES;
      break;
    }
    case hostActions.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID: {
      validationSet = validationRules.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_RULES;
      break;
    }
    case hostActions.UPDATE_USER_BIOGRAPHY_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_BIOGRAPHY_BY_USER_RULES;
      break;
    }

    case hostActions.UPDATE_USER_HOBBIES_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_HOBBIES_BY_USER_RULES;
      break;
    }

    case hostActions.UPDATE_USER_IMAGE_PROFILE_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_IMAGE_PROFILE_BY_USER_RULES;
      break;
    }

    case hostActions.UPDATE_USER_DEFAULT_QR_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_DEFAULT_QR_BY_USER_ID_RULES;
      break;
    }
    case hostActions.GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY: {
      validationSet =
        validationRules.GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY_RULES;
      break;
    }

    case hostActions.UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID: {
      validationSet =
        validationRules.UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID_RULES;
      break;
    }

    case hostActions.UPDATE_USER_GENDER_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_GENDER_BY_USER_ID_RULES;
      break;
    }

    case hostActions.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID: {
      validationSet =
        validationRules.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID_RULES;
      break;
    }

    case hostActions.DISABLE_MATCH_BY_MATCH_ID_USER_ID: {
      validationSet = validationRules.DISABLE_MATCH_BY_MATCH_ID_USER_ID_RULES;
      break;
    }

    case hostActions.GET_USER_PUBLIC_PROFILE_BY_USER_ID: {
      validationSet = validationRules.GET_USER_PUBLIC_PROFILE_BY_USER_ID_RULES;
      break;
    }

    case hostActions.GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID: {
      validationSet =
        validationRules.GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID_RULES;
      break;
    }

    case hostActions.GET_PROTECTED_IMAGES_URLS_BY_USER_ID: {
      validationSet =
        validationRules.GET_PROTECTED_IMAGES_URLS_BY_USER_ID_RULES;
      break;
    }

    case hostActions.PUT_SMART_POINT_BY_USER_ID: {
      validationSet = validationRules.PUT_SMART_POINT_BY_USER_ID_RULES;
      break;
    }

    case hostActions.UPDATE_SMART_POINT_STATUS_BY_POINT_ID: {
      validationSet =
        validationRules.UPDATE_SMART_POINT_STATUS_BY_POINT_ID_RULES;
      break;
    }

    case hostActions.UPDATE_SMART_POINTS_STATUS_BY_USER_ID: {
      validationSet =
        validationRules.UPDATE_SMART_POINTS_STATUS_BY_USER_ID_RULES;
      break;
    }

    case hostActions.GET_ALL_SMART_POINTS_BY_USER_ID: {
      validationSet = validationRules.GET_ALL_SMART_POINTS_BY_USER_ID_RULES;
      break;
    }

    case hostActions.REMOVE_SMART_POINT_BY_POINT_ID: {
      validationSet = validationRules.REMOVE_SMART_POINT_BY_POINT_ID_RULES;
      break;
    }
    case hostActions.GET_SMART_POINTS_BY_POINT_ID: {
      validationSet = validationRules.GET_SMART_POINTS_BY_POINT_ID_RULES;
      break;
    }

    case hostActions.UPDATE_MATCH_AUDIO_ACCESS_BY_MATCH_ID_USER_ID: {
      validationSet = validationRules.UPDATE_MATCH_AUDIO_ACCESS_BY_MATCH_ID_USER_ID_RULES;
      break;
    }

    case hostActions.UPDATE_MATCH_PICTURE_ACCESS_BY_MATCH_ID_USER_ID: {
      validationSet = validationRules.UPDATE_MATCH_PICTURE_ACCESS_BY_MATCH_ID_USER_ID_RULES;
      break;
    }

    case hostActions.UPDATE_USER_SUBSCRIPTION_BY_USER_ID: {
      validationSet = validationRules.UPDATE_USER_SUBSCRIPTION_BY_USER_ID_RULES;
      break;
    }

    default: {
      logger.info("No request verification needed for " + action);
      validationSet = [];
    }
  }

  Promise.all(validationSet.map((validation) => validation.run(req)))
    .then(() => next())
    .catch(next);
}

function requestDoValidation(req) {
  logger.info("Starts requestDoValidation");
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return { errors: errors.array() };
  }
  return null;
}

module.exports = {
  requestAuthValidation,
  requestFieldsValidation,
  requestDoValidation,
};
