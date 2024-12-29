require("dotenv").config();
const AWS = require("aws-sdk");
const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");
const { v4: uuidv4 } = require("uuid");
const { printJson } = require("../utils/json_utils");
const { DB_INSTANCES } = require("../database/databases");
const { HOST_ERROR_CODES, genError } = require("../constants/host_error_codes");
const Busboy = require("busboy");
const s3 = new AWS.S3();

async function getPresignedUrl(bucketName, fileKey, expiresInSeconds = 3600) {
  const params = {
    Bucket: bucketName,
    Key: fileKey,
    Expires: expiresInSeconds, // URL expiration time in seconds
  };

  try {
    const url = s3.getSignedUrl("getObject", params);
    console.log("Pre-signed URL:", url);
    return url;
  } catch (error) {
    console.error("Error generating pre-signed URL:", error);
    throw error;
  }
}

async function s3DeleteObject(bucketName, fileKey) {
  logger.info("Starts ");
  try {
    const params = {
      Bucket: bucketName,
      Key: fileKey,
    };
    await s3.deleteObject(params).promise();
    return true;
  } catch (error) {
    logger.info(error);
  }
  return false;
}

async function getSecureSharedImagesUrlByUserId(input) {
  logger.info(
    "Starts getSecureSharedImagesUrlByUserId: " + JSON.stringify(input)
  );
  try {
    const db = DB_INSTANCES.DB_MULT;
    const filters = { user_id: input.user_id };
    const dbFiles = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_images_collection
    );
    let result = { status: 200, files: [] };
    if (dbFiles) {
      for (let file of dbFiles) {
        try {
          const secureUrl = await getPresignedUrl(
            "floiint-bucket",
            `users/images/${input.user_id}/${file.filename}`
          );
          logger.info("Secure url: " + secureUrl);
          result.files.push({
            file_id: file.file_id,
            url: secureUrl,
            created_at: 0,
            filename: "",
          });
        } catch (error) {
          logger.info(error);
        }
      }
      return result;
    }
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

async function removeUserImageByImageIdUserId(input) {
  logger.info("Starts removeUserImageByImageIdUserId");
  let result = { images: [] };

  try {
    const db = DB_INSTANCES.DB_MULT;
    const filters = { user_id: input.user_id, file_id: input.file_id };
    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_images_collection
    );
    if (dbResponse && dbResponse.length > 0) {
      logger.info("Filename: " + dbResponse[0].filename);
      const isDeleted = await s3DeleteObject(
        "floiint-bucket",
        `users/images/${input.user_id}/${dbResponse[0].filename}`
      );
      if (isDeleted) {
        dbResponse = await dbHandler.deleteDocumentWithClient(
          db.client,
          filters,
          db.collections.user_images_collection
        );
        return {
          ...genError(HOST_ERROR_CODES.NO_ERROR),
        };
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
  };
}

async function doUploadImage(event) {
  try {
    logger.info("Starts doUploadImage");
    const db = DB_INSTANCES.DB_MULT;
    let fileBuffer = null;
    let fileName = "";
    let mimeType = "";
    const fields = {};

    const fileUploadPromise = new Promise((resolve, reject) => {
      const contentType =
        event.headers["Content-Type"] || event.headers["content-type"];
      const busboy = Busboy({ headers: { "content-type": contentType } });

      busboy.on("field", (fieldname, value) => {
        fields[fieldname] = value; // Extract text fields
      });
      busboy.on("file", (fieldname, file, fileInfo, encoding, mimetype) => {
        fileName = fileInfo.filename;
        mimeType = fileInfo.mimetype;
        const chunks = [];
        file.on("data", (chunk) => chunks.push(chunk));
        file.on("end", () => {
          fileBuffer = Buffer.concat(chunks);
        });
      });

      busboy.on("finish", async () => {
        if (!fileBuffer) {
          return reject(new Error("File not found in request"));
        }
        const userId = fields.user_id;
        const bucketName = "floiint-bucket";
        const filePath = `users/images/${userId}/${fileName}`;

        const params = {
          Bucket: bucketName,
          Key: filePath,
          Body: fileBuffer,
          ContentType: mimeType,
        };

        try {
          const data = await s3.upload(params).promise();
          resolve({
            statusCode: 200,
            body: JSON.stringify({
              message: "File uploaded successfully",
              fileUrl: data.Location,
            }),
          });
        } catch (uploadError) {
          console.error("Error uploading file:", uploadError);
          reject(uploadError);
        }
      });
      busboy.on("error", (error) => reject(error));
      busboy.end(Buffer.from(event.body, "base64"));
    });

    await fileUploadPromise;

    const doc = {
      user_id: fields.user_id,
      file_id: uuidv4(),
      filename: fileName,
      created_at: Date.now(),
    };
    const dbResponse = await dbHandler.addDocumentWithClient(
      db.client,
      doc,
      db.collections.user_images_collection
    );

    if (dbResponse) {
      return {
        status: 200,
        user_id: fields.user_id,
        file_id: doc.file_id,
      };
    }
  } catch (error) {
    console.error("Error handling multipart request:", error);
    return {
      statusCode: 500,
      body: {
        message: "no added",
        error: error.message,
      },
    };
  }
}

async function doUploadAudio(event) {
  try {
    logger.info("Starts doUploadAudio");
    const db = DB_INSTANCES.DB_MULT;
    let fileBuffer = null;
    let fileName = "";
    let mimeType = "";
    const fields = {};

    const fileUploadPromise = new Promise((resolve, reject) => {
      const contentType =
        event.headers["Content-Type"] || event.headers["content-type"];
      const busboy = Busboy({ headers: { "content-type": contentType } });

      busboy.on("field", (fieldname, value) => {
        fields[fieldname] = value; // Extract text fields
      });
      busboy.on("file", (fieldname, file, fileInfo, encoding, mimetype) => {
        fileName = fileInfo.filename;
        mimeType = fileInfo.mimetype;
        const chunks = [];
        file.on("data", (chunk) => chunks.push(chunk));
        file.on("end", () => {
          fileBuffer = Buffer.concat(chunks);
        });
      });

      busboy.on("finish", async () => {
        if (!fileBuffer) {
          return reject(new Error("File not found in request"));
        }
        const userId = fields.user_id;
        const bucketName = "floiint-bucket";
        const filePath = `users/audios/${userId}/${fileName}`;

        const params = {
          Bucket: bucketName,
          Key: filePath,
          Body: fileBuffer,
          ContentType: mimeType,
        };

        try {
          const data = await s3.upload(params).promise();
          resolve({
            statusCode: 200,
            body: JSON.stringify({
              message: "File uploaded successfully",
              fileUrl: data.Location,
            }),
          });
        } catch (uploadError) {
          console.error("Error uploading file:", uploadError);
          reject(uploadError);
        }
      });
      busboy.on("error", (error) => reject(error));
      busboy.end(Buffer.from(event.body, "base64"));
    });

    await fileUploadPromise;

    const doc = {
      user_id: fields.user_id,
      file_id: uuidv4(),
      filename: fileName,
      created_at: Date.now(),
    };
    const dbResponse = await dbHandler.addDocumentWithClient(
      db.client,
      doc,
      db.collections.user_audios_collection
    );

    if (dbResponse) {
      return {
        status: 200,
        user_id: fields.user_id,
        file_id: doc.file_id,
      };
    }
  } catch (error) {
    console.error("Error handling multipart request:", error);
    return {
      statusCode: 500,
      body: {
        message: "no added",
        error: error.message,
      },
    };
  }
}

async function getUserAudiosByUserId(input) {
  logger.info("Starts getUserAudiosByUserId");
  let result = { ...genError(HOST_ERROR_CODES.NO_ERROR) };
  result.audios = [];
  try {
    const db = DB_INSTANCES.DB_MULT;
    const filters = { user_id: input.user_id };
    const dbFiles = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_audios_collection
    );

    if (dbFiles) {
      result.files = [];
      for (let file of dbFiles) {
        try {
          const secureUrl = await getPresignedUrl(
            "floiint-bucket",
            `users/audios/${input.user_id}/${file.filename}`
          );
          result.files.push({
            file_id: file.file_id,
            url: secureUrl,
            created_at: 0,
            filename: "",
          });
        } catch (error) {
          logger.info(error);
        }
      }

      return result;
    }
  } catch (error) {
    logger.info(error);
    result = {
      ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
    };
  }

  return result;
}

async function removeUserAudioByAudioIdUserId(input) {
  logger.info("Starts removeUserAudioByAudioIdUserId");
  let result = { ...genError(HOST_ERROR_CODES.NO_ERROR) };
  result.images = [];
  try {
    const db = DB_INSTANCES.DB_MULT;
    const filters = { user_id: input.user_id, file_id: input.file_id };
    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_audios_collection
    );
    if (dbResponse && dbResponse.length > 0) {
      logger.info("Filename: " + dbResponse[0].filename);
      const isDeleted = await s3DeleteObject(
        "floiint-bucket",
        `users/audios/${input.user_id}/${dbResponse[0].filename}`
      );
      if (isDeleted) {
        dbResponse = await dbHandler.deleteDocumentWithClient(
          db.client,
          filters,
          db.collections.user_audios_collection
        );
        return {
          ...genError(HOST_ERROR_CODES.NO_ERROR),
        };
      }
    }
  } catch (error) {
    logger.info(error);
    result = {
      ...genError(HOST_ERROR_CODES.NO_ERROR),
    };
  }

  return result;
}

module.exports = {
  doUploadImage,
  getSecureSharedImagesUrlByUserId,
  removeUserImageByImageIdUserId,
  doUploadAudio,
  getUserAudiosByUserId,
  removeUserAudioByAudioIdUserId,
  getPresignedUrl
};
