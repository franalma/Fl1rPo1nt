const multer = require('multer');
const path = require('path');
const rootDir = "/Users/fran/Desktop/Projects/Personal/Fl1rPo1nt/Fl1rPo1nt/server_profile_image";
const fs = require('fs');
const dbHandler = require("./../database/database_handler");
const userImageCollection = "user_images";
const logger = require("../logger/log");
const { v4: uuidv4 } = require('uuid');
let upload;



function config() {
    // Configure multer for file storage
    const storage = multer.diskStorage({
        destination: (req, file, cb) => {
            cb(null, rootDir);
        },
        filename: (req, file, cb) => {
            cb(null, Date.now() + path.extname(file.originalname)); // Unique file name
        }
    });



    if (!fs.existsSync(rootDir)) {
        fs.mkdirSync(rootDir);
    }

    upload = multer({ storage: storage });
    return upload;

}

async function doUploadImageByUserId(req, userId) {
    console.log("Starts doUploadImageByUserId: " + userId);
    try {
        await upload.single('image');
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

async function getImageByUrl(fileId) {

    logger.info("Starts getImageByUrl: " + fileId);
    const filters = { file_id: fileId }
    const dbResponse = await dbHandler.findWithFilters(filters, userImageCollection);

    if (dbResponse) {
        let fileName = dbResponse[0].filename;
        const filePath = path.join(rootDir, fileName);
        console.log(filePath);

        // Check if the file exists
        let value = await fs.access(filePath, fs.constants.F_OK, () => { });

        if (value) {
            console.log("err");
            return null;

        } else {
            console.log("no error");
            return {
                status: 200,
                filepath: filePath
            }
        }
    }



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
                let fileName = item.filename;
                const filePath = path.join(rootDir, fileName);
                const imageData = fs.readFileSync(filePath);

                result.images.push({
                    file_id: item.file_id,
                    created_at: item.created_at,
                    file: imageData.toString('base64')
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
            const filePath = rootDir + "/" + dbResponse[0].filename;
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



module.exports = {
    doUploadImageByUserId,
    config,
    getImageByUrl,
    getUserImagesByUserId,
    removeUserImageByImageIdUserId
}