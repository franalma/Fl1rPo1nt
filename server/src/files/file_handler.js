const multer = require('multer');
const path = require('path');
const fs = require('fs');
const sharp = require('sharp');
const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");
const { v4: uuidv4 } = require('uuid');
const crypto = require('crypto');
const { printJson } = require('../utils/json_utils');

const rootDir = process.env.MULTIMEDIA_PATH;
const secImageKey = process.env.SEC_IMAGE_KEY;
const rootDirImages = rootDir + process.env.IMAGE_DIR_PATH;
const rootDirAudios = rootDir + process.env.AUDIO_DIR_PATH;
const userImageCollection = process.env.DB_IMAGE_COLLECTION;
const userAudioCollection = process.env.DB_AUDIO_COLLECTION;
let uploadAudios;
let uploadImages;


function configImages() {
    // Configure multer for file storage
    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
            cb(null, rootDirImages);
        },
        filename: (req, file, cb) => {
            cb(null, Date.now() + path.extname(file.originalname)); // Unique file name
        }
    });

    if (!fs.existsSync(rootDirImages)) {
        fs.mkdirSync(rootDirImages);
    }

    uploadImages = multer({ storage: storage });
    return uploadImages;
}

function configAudios() {

    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
            cb(null, rootDirAudios);
        },
        filename: (req, file, cb) => {
            cb(null, Date.now() + path.extname(file.originalname));
        }
    });

    if (!fs.existsSync(rootDirAudios)) {
        fs.mkdirSync(rootDirAudios);
    }

    uploadAudios = multer({ storage: storage });
    return uploadAudios;
}

function generateSignedImageUrl(filename, expiresIn = 300) { // expiresIn is in seconds
    logger.info("Starts generateSignedUrl")
    const expirationTime = Math.floor(Date.now() / 1000) + expiresIn;
    const signature = crypto
        .createHmac('sha256', secImageKey)
        .update(`${filename}:${expirationTime}`)
        .digest('hex');

    return `${process.env.HOST_PATH}/secure-images/${filename}?expires=${expirationTime}&signature=${signature}`;
}

function generateSignedAudiosUrl(filename, expiresIn = 300) { // expiresIn is in seconds
    logger.info("Starts generateSignedUrl")
    const expirationTime = Math.floor(Date.now() / 1000) + expiresIn;
    const signature = crypto
        .createHmac('sha256', secImageKey)
        .update(`${filename}:${expirationTime}`)
        .digest('hex');

    return `${process.env.HOST_PATH}/secure-audios/${filename}?expires=${expirationTime}&signature=${signature}`;
}

function validateSignedSignedUrl(value, expires, signature) {
    logger.info(`Starts validateSignedSignedUrl value:${value} expires: ${expires}, signature: ${signature}`);
    if (Math.floor(Date.now() / 1000) > parseInt(expires, 10)) {
        logger.info("time")
        return false;
    }

    // Verify signature
    const expectedSignature = crypto
        .createHmac('sha256', secImageKey)
        .update(`${value}:${expires}`)
        .digest('hex');

    if (signature !== expectedSignature) {
        logger.info("wron signature")
        return false;
    }

    return true;
}


function resizeImage(input, response) {
    logger.info("Starts resizeImage");
    try {
        const width = input.width;
        const height = input.height;
        const filepath = input.filepath;
        const quality = input.quality;

        if (fs.existsSync(filepath)) {
            const transformer = sharp(filepath)
                .resize(
                    width ? parseInt(width) : null,
                    height ? parseInt(height) : null
                )
                .jpeg({ quality: quality ? parseInt(quality) : 100 }); // Default quality 80%

            transformer.pipe(response);
        }
    } catch (error) {
        logger.info(error);
    }
}


async function doUploadImageByUserId(req, userId) {
    console.log("Starts doUploadImageByUserId: " + userId);
    try {
        await uploadImages.single('image');
        const fileName = path.basename(req.file.path);
        const doc = {
            user_id: userId,
            file_id: uuidv4(),
            filename: fileName,
            created_at: Date.now()
        }
        const dbResponse = await dbHandler.addDocument(doc, userImageCollection);

        if (dbResponse) {
            return {
                status: 200,
                user_id: userId,
                file_id: doc.file_id
            }
        }
    } catch (error) {
        console.log(error);
    }
    return null;
}

async function doUploadAudioByUserId(req, userId) {
    console.log("Starts doUploadAudioByUserId: " + userId);
    try {
        await uploadAudios.single('audio');
        const fileName = path.basename(req.file.path);
        const doc = {
            user_id: userId,
            file_id: uuidv4(),
            filename: fileName,
            created_at: Date.now()
        }
        const dbResponse = await dbHandler.addDocument(doc, userAudioCollection);

        if (dbResponse) {
            return {
                status: 200,
                user_id: userId,
                file_id: doc.file_id
            }
        }
    } catch (error) {
        console.log(error);
    }
    return null;
}


async function getSecureSharedImagesUrlByUserId(input) {
    logger.info("Starts getSecureSharedImagesUrlByUserId");
    try {
        const filters = { user_id: input.user_id };
        const dbFiles = await dbHandler.findWithFilters(filters, userImageCollection);
        let result = { status: 200, files: [] };
        if (dbFiles) {
            for (let file of dbFiles) {
                try {
                    const secureUrl = generateSignedImageUrl(file.filename);
                    logger.info("Secure url: " + secureUrl);
                    result.files.push({ file_id: file.file_id, url: secureUrl, created_at: 0, filename: "" });
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


async function getImageByUserIdImageId(input) {
    logger.info("Starts getImageByUserIdImageId:" + JSON.stringify(input));
    try {
        const filters = { $or: input.values };
        logger.info(JSON.stringify(filters));
        const dbFiles = await dbHandler.findWithFilters(filters, userImageCollection);
        if (dbFiles) {
            let result = { status: 200, files: [] };
            for (let file of dbFiles) {
                try {
                    const secureUrl = generateSignedImageUrl(file.filename)
                    result.files.push({ file_id: file.file_id, url: secureUrl, created_at: 0, filename: "" });
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


async function getUserImagesByUserId(input) {
    logger.info("Starts getUserImagesByUserId");
    let result = { status: 200 };
    result.images = [];
    try {
        // const filters = { user_id: input.user_id };
        // const dbResponse = await dbHandler.findWithFilters(filters, userImageCollection);

        // if (dbResponse) {

        //     for (var item of dbResponse) {
        //         try {
        //             let fileName = item.filename;
        //             const filePath = path.join(rootDirImages, fileName);
        //             const imageData = fs.readFileSync(filePath);

        //             result.images.push({
        //                 file_id: item.file_id,
        //                 created_at: item.created_at,
        //                 file: imageData.toString('base64')
        //             });
        //         } catch (error) {
        //             logger.info(error);
        //         }

        //     }
        // }
    } catch (error) {
        logger.info(error);
        result.status = 500;
    }

    return result;
}

async function getUserAudiosByUserId(input) {
    logger.info("Starts getUserAudiosByUserId");
    let result = { status: 200 };
    result.audios = [];
    try {
        const filters = { user_id: input.user_id };
        const dbFiles = await dbHandler.findWithFilters(filters, userAudioCollection);

        if (dbFiles) {

            // for (var item of dbResponse) {
            //     let fileName = item.filename;
            //     const filePath = path.join(rootDirAudios, fileName);
            //     const audioData = fs.readFileSync(filePath);

            //     result.audios.push({
            //         file_id: item.file_id,
            //         created_at: item.created_at,
            //         file: audioData.toString('base64')
            //     });
            // }

            let result = { status: 200, files: [] };
            for (let file of dbFiles) {
                try {
                    const secureUrl = generateSignedAudiosUrl(file.filename)
                    result.files.push({ file_id: file.file_id, url: secureUrl, created_at: 0, filename: "" });
                } catch (error) {
                    logger.info(error);
                }
            }
            printJson(result);
            return result;
        }
    } catch (error) {
        logger.info(error);
        result.status = 500;
    }

    return result;
}

async function removeUserImageByImageIdUserId(input) {
    logger.info("Starts removeUserImageByImageIdUserId");
    let result = { status: 200 };
    result.images = [];
    try {
        const filters = { user_id: input.user_id, file_id: input.file_id };
        let dbResponse = await dbHandler.findWithFilters(filters, userImageCollection);
        if (dbResponse && dbResponse.length > 0) {
            const filePath = rootDirImages + "/" + dbResponse[0].filename;
            logger.info("Filename: " + filePath);

            fs.unlink(filePath, (err) => {
                if (err) {
                    result.status = 500;
                }
            });
            dbResponse = await dbHandler.deleteDocument(filters, userImageCollection);

        };
    } catch (error) {
        logger.info(error);
        result.status = 500;
    }

    return result;

}

async function removeUserAudioByAudioIdUserId(input) {
    logger.info("Starts removeUserAudioByAudioIdUserId");
    let result = { status: 200 };
    result.images = [];
    try {
        const filters = { user_id: input.user_id, file_id: input.file_id };
        let dbResponse = await dbHandler.findWithFilters(filters, userAudioCollection);
        if (dbResponse && dbResponse.length > 0) {
            const filePath = rootDirAudios + "/" + dbResponse[0].filename;
            logger.info("Filename: " + filePath);

            fs.unlink(filePath, (err) => {
                if (err) {
                    result.status = 500;
                }
            });
            dbResponse = await dbHandler.deleteDocument(filters, userAudioCollection);

        };
    } catch (error) {
        logger.info(error);
        result.status = 500;
    }

    return result;

}



module.exports = {
    doUploadImageByUserId,
    configAudios,
    configImages,
    getUserImagesByUserId,
    removeUserImageByImageIdUserId,
    doUploadAudioByUserId,
    getUserAudiosByUserId,
    removeUserAudioByAudioIdUserId,
    getImageByUserIdImageId,
    getSecureSharedImagesUrlByUserId,
    validateSignedSignedUrl,
    resizeImage

}