require("dotenv").config();
const express = require("express");
const logger = require("./logger/log");
const http = require("http");
const fileHandler = require("./files/file_handler");
const path = require("path");
const { DB_INSTANCES } = require("./database/databases");
const requestValidator = require("./auth/validate_request");
const dbHandler = require("./database/database_handler");
const userHandler = require("./model/user/user_handler");

//Init
const app = express();
app.use(express.json());
const port = process.env.SERVER_PORT_MULT;
const server = http.createServer(app);

const uploadImages = fileHandler.configImages();
const uploadAudios = fileHandler.configAudios();

async function processGettingImage(req, res) {
  logger.info(`Starts processGettingImage`);
  try {
    const { filename } = req.params;
    const { expires, signature, width, height, quality } = req.query;

    //TODO restore signature validation
    if (fileHandler.validateSignedSignedUrl(filename, expires, signature)) {
      const filePath = path.join(
        process.env.MULTIMEDIA_PATH,
        process.env.IMAGE_DIR_PATH,
        filename
      );
      logger.info(filePath);
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
  logger.info("processRequest");
  let result = requestValidator.requestDoValidation(req);
  try {
    if (result) {
      res.status(400).json(result);
    } else {
      const { action } = req.body;
      logger.info(action);
      switch (action) {
        
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

app.post("/", (req, res) => {
  processRequest();
});

app.post(
  "/upload/image",
  requestValidator.requestAuthValidation,
  uploadImages.single("image"),
  (req, res) => {
    logger.info("starts upload")
    if (!req.file) {
      return res.status(400).send("No file uploaded.");
    }
    const userId = req.body.user_id;

    fileHandler.doUploadImageByUserId(req, userId).then((result) => {
      console.log("---result: " + result);
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
  uploadAudios.single("audio"),
  (req, res) => {
    if (!req.file) {
      logger.info("no audio file");
      return res.status(400).send("No file uploaded.");
    }
    const userId = req.body.user_id;

    fileHandler.doUploadAudioByUserId(req, userId).then((result) => {
      console.log("---result: " + result);
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

server.listen(port, () => {
  dbHandler.connectToDatabase(DB_INSTANCES.DB_MULT).then((result) => {
    if (result == null) {
      throw "Db connection error";
    } else {
      console.log(`El servidor API está corriendo en el puerto ${port}`);
    }
  });
});
