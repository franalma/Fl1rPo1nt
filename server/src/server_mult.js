require("dotenv").config();
const express = require("express");
const { header } = require("express-validator");
const logger = require("./logger/log");
const http = require("http");
const fileHandler = require("./files/file_handler");
const s3Handler = require("./files/s3_handler");
const path = require("path");
const { DB_INSTANCES } = require("./database/databases");
const requestValidator = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const hostActions = require("./constants/host_actions");
const { printJson } = require("./utils/json_utils");
const app = express();
app.use(express.json());


async function processGettingImage(req, res) {
  logger.info(`Starts processGettingImage`);
  try {
    const { filename } = req.params;
    const { expires, signature, width, height, quality } = req.query;

    if (fileHandler.validateSignedSignedUrl(filename, expires, signature)) {
      const filePath = path.join(
        process.env.MULTIMEDIA_PATH,
        process.env.IMAGE_DIR_PATH,
        filename
      );
      logger.info(`Filepath=${filePath}`);
      res.set("Content-Type", "image/jpeg");
      fileHandler.resizeImage(
        { filepath: filePath, width: width, height: height, quality: quality },
        res
      );
    } else {
      return res.status(403).send("Invalid signature");
    }
  } catch (error) {
    logger.info(error);
  }
}

async function processGettingAudios(req, res) {
  logger.info(`Starts processGettingAudios`);
  try {
    const { filename } = req.params;
    const { expires, signature } = req.query;

    if (fileHandler.validateSignedSignedUrl(filename, expires, signature)) {
      const filePath = path.join(
        process.env.MULTIMEDIA_PATH,
        process.env.AUDIO_DIR_PATH,
        filename
      );
      logger.info(filePath);
      res.set("Content-Type", "	audio/aac");

      res.status(200).sendFile(filePath, {
        headers: {
          "Content-Type": "audio/aac",
        },
      });
    } else {
      return res.status(403).send("Invalid signature");
    }
  } catch (error) {
    logger.info(error);
  }
}

async function processRequest(req, res) {
  const { action } = req.body;    
  let result = requestValidator.requestDoValidation(req);
  try {
    if (result) {
      res.status(400).json(result);
    } else {
      switch (action) {
        case hostActions.GET_PROTECTED_IMAGES_URLS_BY_USER_ID: {
          result = await s3Handler.getSecureSharedImagesUrlByUserId(
            req.body.input
          );
          break;
        }
        case hostActions.REMOVE_USER_IMAGES_BY_USER_ID_IMAGE_ID: {
          result = await s3Handler.removeUserImageByImageIdUserId(
            req.body.input
          );
          break;
        }
        case hostActions.GET_USER_AUDIOS_BY_USER_ID: {
          result = await s3Handler.getUserAudiosByUserId(req.body.input);
          break;
        }
        case hostActions.REMOVE_USER_AUDIO_BY_USER_ID_AUDIO_ID: {
          result = await s3Handler.removeUserAudioByAudioIdUserId(
            req.body.input
          );
          break;
        }
      }
    }

    if (result && result.status) {
      res.status(result.status).json(result);
    } else {
      res.status(500).json({ message: "Error processing the request" });
    }
  } catch (error) {
    logger.info(error);
  }
}

app.post(
  "/base",
  requestValidator.requestAuthValidation,
  requestValidator.requestFieldsValidation,
  (req, res) => {
    processRequest(req, res);
  }
);

app.post(
  "/upload/image",
  requestValidator.requestAuthValidation,
  (req, res) => {
    logger.info("starts upload");

    const userId = req.params.user_id; // Extract path parameter
    const query = req.query; // Extract query parameters
    const headers = req.headers; // Extract headers
    const context = req.requestContext; // Extract Lambda context (mapped by serverless-express)

    // res.status(200).json({
    //     message: 'User details retrieved',
    //     userId,
    //     query,
    //     headers,
    //     context,
    // });
    // return;

    // if (!req.body.file) {
    //   return res.status(400).send("No file uploaded");
    // }

    s3Handler.doUploadImage(req).then((result) => {
      if (result) {
        res.status(200).json(result);
      } else {
        res.status(501).json({
          message: "Not possible to add image",
        });
      }
    });
  }
);

app.post(
  "/upload/audio",
  requestValidator.requestAuthValidation,

  (req, res) => {
    s3Handler.doUploadAudio(req).then((result) => {
      if (result) {
        res.status(200).json(result);
      } else {
        res.status(501).json({
          message: "Not possible to add audio",
        });
      }
    });
  }
);

// Serve secure images
app.get(
  "/secure-images/:filename",
  // requestValidator.requestAuthValidation,
  (req, res) => {
    logger.info("Secure image getting: " + req.url);

    processGettingImage(req, res);
  }
);

app.get(
  "/secure-audios/:filename",
  // requestValidator.requestAuthValidation,
  (req, res) => {
    logger.info("Secure image getting: " + req.url);

    processGettingAudios(req, res);
  }
);

// server.listen(port, () => {
//   dbHandler.connectToDatabase(DB_INSTANCES.DB_MULT).then((result) => {
//     if (result == null) {
//       throw "Db connection error";
//     } else {
//       console.log(`El servidor API está corriendo en el puerto ${port}`);
//     }
//   });
// });

process.on("SIGINT", async () => {
  dbHandler.connectToDatabase(DB_INSTANCES.MULTIMEDIA_PATH);
  console.log("DB connection pool closed for server mult ");
  process.exit(0);
});

module.exports = {
  app,
};
