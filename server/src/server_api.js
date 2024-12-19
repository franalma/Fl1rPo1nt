require("dotenv").config();
const express = require("express");
const requestValidator = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const userHandler = require("./model/user/user_handler");
const contactHandler = require("./model/user/mach_handler");
const qrHandler = require("./model/qr/qr_handler");
const generalValuesHandler = require("./model/general_values/general_values_handler");
const flirtHandler = require("./model/flirt/flirt_handler");
const http = require("http");
const fileHandler = require("./files/file_handler");
const hobbiesHandler = require("./model/hobbies/hobbies_handler");
const chatroomHandler = require("./chatroom/chatroom_handler");
const path = require("path");
const { printJson } = require("./utils/json_utils");
const { header } = require("express-validator");
const { DB_INSTANCES } = require("./database/databases");
const smartpoint_handler = require("./model/smart_points/smart_points_handler");

//Init
const app = express();
app.use(express.json());
// const port = process.env.SERVER_PORT_API;
// const server = http.createServer(app);

async function processRequest(req, res) {
  logger.info("processRequest:" + JSON.stringify(req.body));

  try {
    let result = requestValidator.requestDoValidation(req);
    if (result) {
      res.status(400).json(result);
    } else {
      const { action } = req.body;
      logger.info(action);
      switch (action) {
        // case hostActions.PUT_USER_QR_BY_USER_ID: {
        //   result = await qrHandler.addUserQrByUserId(req.body.input);
        //   break;
        // }
        // case hostActions.DELETE_USER_QR_BY_USER_ID_QR_ID: {
        //   result = await qrHandler.removeUserQrByUserIdQrId(req.body.input);
        //   break;
        // }
        case hostActions.GET_USER_QR_BY_USER_ID: {
          result = await qrHandler.getUserQrByUserId(req.body.input);
          break;
        }
        case hostActions.GET_ALL_SOCIAL_NETWORKS: {
          result = await generalValuesHandler.getAllSocialNetworks();
          break;
        }
        case hostActions.PUT_ALL_SOCIAL_NETWORKS: {
          result = await generalValuesHandler.putAllSocialNetworks(
            req.body.input
          );
          break;
        }
        case hostActions.UPDATE_USER_IMAGE_PROFILE_BY_USER_ID: {
          result = await userHandler.updateUserImageProfileByUserId(
            req.body.input
          );
          break;
        }
        case hostActions.PUT_USER_CONTACT_BY_USER_ID_CONTACT_ID_QR_ID: {
          result = await contactHandler.addUserContactByUserIdContactIdQrId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_USER_CONTACTS_BY_USER_ID: {
          result = await contactHandler.getUserContactsByUserId(req.body.input);
          break;
        }
        // case hostActions.GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY: {
        //   result = await userHandler.getUsersByDistanceFromPoint(
        //     req.body.input
        //   );
        //   break;
        // }
        case hostActions.UPDATE_USER_NETWORK_BY_USER_ID: {
          result = await userHandler.updateUserNetworksByUserId(req.body.input);
          break;
        }

        case hostActions.GET_ALL_SEXUAL_ORIENTATIONS_RELATIONSHIPS: {
          result =
            await generalValuesHandler.getAllSexualOrientationsRelationships(
              req.body.input
            );
          break;
        }

        case hostActions.GET_ALL_GENDERS: {
          result = await generalValuesHandler.getAllGenders(req.body.input);
          break;
        }

        case hostActions.UPDATE_USER_INTERESTS_BY_USER_ID: {
          result = await userHandler.updateUserInterestsByUserId(
            req.body.input
          );
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
        
        case hostActions.UPDATE_USER_BIOGRAPHY_BY_USER_ID: {
          result = await userHandler.updateUserBiographyByUserId(
            req.body.input
          );
          break;
        }
        case hostActions.GET_ALL_HOBBIES: {
          result = await hobbiesHandler.getAllHobbies(req.body.input);
          break;
        }

        case hostActions.UPDATE_USER_HOBBIES_BY_USER_ID: {
          result = await userHandler.updateUserHobbiesByUserId(req.body.input);
          break;
        }

        case hostActions.UPDATE_USER_NAME_BY_USER_ID: {
          result = await userHandler.updateUserNameByUserId(req.body.input);
          break;
        }

        case hostActions.UPDATE_USER_DEFAULT_QR_BY_USER_ID: {
          result = await userHandler.updateUserDefaultQrByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_ALL_USER_MATCHS_BY_USER_ID: {
          result = await contactHandler.getAllUserMatchsByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_ACTIVE_FLIRTS_FROM_POINT_AND_TENDENCY: {
          result = await flirtHandler.getActiveFlirtsFromPointAndTendency(
            req.body.input
          );
          break;
        }

        case hostActions.UPDATE_USER_RADIO_VISIBILITY_BY_USER_ID: {
          result = await userHandler.updateUserRadioVisibility(req.body.input);
          break;
        }

        case hostActions.UPDATE_USER_GENDER_BY_USER_ID: {
          result = await userHandler.updateUserGenderByUserId(req.body.input);
          break;
        }

        case hostActions.DISABLE_MATCH_BY_MATCH_ID_USER_ID: {
          result = await contactHandler.diableMatchByMatchIdUserId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_USER_PROTECTED_URL_FOR_FILE_ID_USER_ID: {
          result = await fileHandler.getImageByUserIdImageId(req.body.input);
          break;
        }

        case hostActions.GET_USER_PUBLIC_PROFILE_BY_USER_ID: {
          result = await userHandler.getUserPublicProfileByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.PUT_SMART_POINT_BY_USER_ID: {
          result = await smartpoint_handler.putUserSmartPointByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_ALL_SMART_POINTS_BY_USER_ID: {
          result = await smartpoint_handler.getAllSmartPointsByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.UPDATE_SMART_POINT_STATUS_BY_POINT_ID: {
          result = await smartpoint_handler.updaterSmartPointStatusByPointId(
            req.body.input
          );
          break;
        }

        case hostActions.UPDATE_SMART_POINTS_STATUS_BY_USER_ID: {
          result = await smartpoint_handler.updateAllPointsStatusByUserId(
            req.body.input
          );
          break;
        }

        case hostActions.REMOVE_SMART_POINT_BY_POINT_ID: {
          result = await smartpoint_handler.removeSmartPointByPointId(
            req.body.input
          );
          break;
        }

        case hostActions.GET_SMART_POINTS_BY_POINT_ID: {
          result = await smartpoint_handler.getSmartPointByPointId(
            req.body.input
          );
          break;
        }

        case hostActions.UPDATE_MATCH_AUDIO_ACCESS_BY_MATCH_ID_USER_ID: {
          result = await contactHandler.updateAudiosAccessForMarchIdContactId(
            req.body.input
          );
          break;
        }

        case hostActions.UPDATE_MATCH_PICTURE_ACCESS_BY_MATCH_ID_USER_ID: {
          result = await contactHandler.updatePicturesAccessForMarchIdContactId(
            req.body.input
          );
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

app.post(
  "/api",
  requestValidator.requestAuthValidation,
  requestValidator.requestFieldsValidation,
  (req, res) => {
    processRequest(req, res);
  }
);

// server.listen(port, () => {
//   dbHandler.connectToDatabase(DB_INSTANCES.DB_API).then((result) => {
//     if (result == null) {
//       throw "Db connection error";
//     } else {
//       console.log(`El servidor API está corriendo en el puerto ${port}`);
//     }
//   });
// });


process.on('SIGINT', async () => {
  dbHandler.connectToDatabase(DB_INSTANCES.DB_API)
  console.log('DB connection pool closed for server api ');
  process.exit(0);
});

module.exports = {
  app,
};
