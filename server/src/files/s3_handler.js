require("dotenv").config();
const multer = require("multer");
const AWS = require('aws-sdk');
const path = require("path");
const fs = require("fs");
const sharp = require("sharp");
const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");
const { v4: uuidv4 } = require("uuid");
const crypto = require("crypto");
const { printJson } = require("../utils/json_utils");
const { DB_INSTANCES } = require("../database/databases");
const { HOST_ERROR_CODES, genError } = require("../constants/host_error_codes")
const rootDir = process.env.MULTIMEDIA_PATH;
const secImageKey = process.env.SEC_IMAGE_KEY;
// const rootDirImages = rootDir + process.env.IMAGE_DIR_PATH;
// const rootDirAudios = rootDir + process.env.AUDIO_DIR_PATH;
// const userImageCollection = process.env.DB_IMAGE_COLLECTION;
// const userAudioCollection = process.env.DB_AUDIO_COLLECTION;
let uploadAudios;
let uploadImages;


const s3 = new AWS.S3();

function configImages() {
    storage = multer.memoryStorage(); // Store the file in memory
    uploadImages = multer({ storage: storage });
    return uploadImages;
}


async function doUploadImageByUserId(req, userId) {
    console.log("Starts doUploadImageByUserId: " + userId);
    try {
        const db = DB_INSTANCES.DB_MULT;
        const file = req.file;
        const bucketName = "floiint-bucket";
        const filePath = "users/images";

        const params = {
            Bucket: bucketName,
            Key: file.originalname, // Use the original file name
            Body: file.buffer, // File content from Multer
            ContentType: file.mimetype, // File MIME type
            Key: filePath,        
        };

        // Upload the file to S3
        const data = await s3.upload(params).promise();
        console.log(`File uploaded successfully at ${data.Location}`);





        //   const doc = {
        //     user_id: userId,
        //     file_id: uuidv4(),
        //     filename: fileName,
        //     created_at: Date.now(),
        //   };
        //   const dbResponse = await dbHandler.addDocumentWithClient(
        //     db.client,
        //     doc,
        //     db.collections.user_images_collection
        //   );

        //   if (dbResponse) {
        //     return {
        //       status: 200,
        //       user_id: userId,
        //       file_id: doc.file_id,
        //     };
        //   }
    } catch (error) {
        console.log(error);
    }
    return null;
}

module.exports = {
    doUploadImageByUserId,
    configImages
}