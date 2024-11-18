const multer = require('multer');
const path = require('path');
const rootDir = "/Users/fran/Desktop/Projects/Personal/Fl1rPo1nt/Fl1rPo1nt/server_profile_image";
const fs = require('fs');
const dbHandler = require("./../database/database_handler");
const userImageCollection = "user_images";

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
            filename: fileName,
            created_at: Date.now()
        }
        const dbResponse = await dbHandler.addDocument(doc, userImageCollection);

        if (dbResponse) {
            return {
                status: 200,
                user_id: userId,
                filename: fileName
            }
        }
    } catch (error) {
        console.log(error);
    }
    return null;

}

async function getImageByUrl(fileName) {
    const filePath = path.join(rootDir, fileName);
    console.log(filePath);

    // Check if the file exists
    let value = await fs.access(filePath, fs.constants.F_OK , ()=>{});

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
function callback(){
    
}



module.exports = {
    doUploadImageByUserId,
    config,
    getImageByUrl
}