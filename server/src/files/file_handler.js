const multer = require('multer');
const path = require('path');
const rootDir = process.env.MULTIMEDIA_PATH;;
const rootDirImages = rootDir+"/server_user_images";
const rootDirAudios = rootDir+"/server_user_audios";
const fs = require('fs');
const dbHandler = require("../database/database_handler");
const userImageCollection = "user_images";
const userAudioCollection = "user_audios";
const logger = require("../logger/log");
const { v4: uuidv4 } = require('uuid');
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


async function getUserImagesByUserId(input) {
    logger.info("Starts getUserImagesByUserId");
    let result = { status: 200 };
    result.images = [];
    try {
        const filters = { user_id: input.user_id };
        const dbResponse = await dbHandler.findWithFilters(filters, userImageCollection);

        if (dbResponse) {

            for (var item of dbResponse) {
                try{
                    let fileName = item.filename;
                    const filePath = path.join(rootDirImages, fileName);
                    const imageData = fs.readFileSync(filePath);
    
                    result.images.push({
                        file_id: item.file_id,
                        created_at: item.created_at,
                        file: imageData.toString('base64')
                    });
                }catch(error){
                    logger.info(error);
                }
                
            }
        }
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
        const dbResponse = await dbHandler.findWithFilters(filters, userAudioCollection);

        if (dbResponse) {

            for (var item of dbResponse) {
                let fileName = item.filename;
                const filePath = path.join(rootDirAudios, fileName);
                const audioData = fs.readFileSync(filePath);

                result.audios.push({
                    file_id: item.file_id,
                    created_at: item.created_at,
                    file: audioData.toString('base64')
                });
            }
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
    removeUserAudioByAudioIdUserId
}