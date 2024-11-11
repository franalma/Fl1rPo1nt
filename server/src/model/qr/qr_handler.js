const logger = require("../../logger/log");
const { v4: uuidv4 } = require('uuid');
const dbHandler = require('../../database/database_handler');
const userColletion = "user_qr";

function createInternalQr(input) {
    logger.info("Start createInternalQr");
    const value = {
        qr_id: uuidv4(),
        user_id: input.user_id,
        qr_content: input.qr_content,
        created_at: Date.now()
    }
    return value;
}
function createExternalQrInfo(item){
    logger.info("Start createExternalQrInfo: "+JSON.stringify(item));
    return {
        user_id: item.user_id, 
        qr_id: item.qr_id, 
        qr_content: item.qr_content, 
        qr_created_at: item.created_at

    }
}

async function addUserQrByUserId(input) {
    logger.info("Starts addUserQrByUserId: " + JSON.stringify(input));
    let item = createInternalQr(input);
    let result = {};
    let dbResponse = await dbHandler.addDocument(item, userColletion);
    if (dbResponse) {
        result = {
            status: 200,
            message: "QR added successfully",
            response: {
                user_id: item.user_id,
                qr_id: item.qr_id,
                create_at: item.created_at
            }

        };
        return result;
    }
}

async function removeUserQrByUserIdQrId(input) {
    logger.info("Starts removeUserQrByUserIdQrId: " + JSON.stringify(input));
    let filters = { user_id: input.user_id, qr_id: input.qr_id };
    let result = {};
    let dbResponse = await dbHandler.deleteDocument(filters, userColletion);
    if (dbResponse) {
        result = {
            status: 200,
            message: "QR removed successfully",            
        };
        return result;
    }
}

async function getUserQrByUserId(input) {
    logger.info("Starts getUserQrByUserId: " + JSON.stringify(input));
    let filters = { user_id: input.user_id};
    let result = {};
    let dbResponse = await dbHandler.findWithFilters(filters, userColletion);    
    if (dbResponse) {
        result.status = 200; 
        result.items =[];
        for (let index in dbResponse){
            let item = createExternalQrInfo(dbResponse[index]);
            result.items.push(item);
        }
        
        return result;
    }
    
    
}


module.exports = {
    addUserQrByUserId,
    removeUserQrByUserIdQrId,
    getUserQrByUserId
}