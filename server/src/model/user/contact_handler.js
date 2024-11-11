const logger = require('../../logger/log');
const { v4: uuidv4 } = require('uuid');
const dbHandler = require('../../database/database_handler');
const userColletion = "users_contacts";


function createUserContactInternal(input){

}



async function addUserContactByUserIdContactId(input){
    logger.info("Starts addUserContact");
}

async function removeUserContactByUserIdContactId(input){
    logger.info("Starts removeUserContactByUserIdContactId");
}

async function getUserContactsByUserId(input){
    logger.info("Starts getUserContactsByUserId");
}

module.exports = {
    addUserContactByUserIdContactId,
    removeUserContactByUserIdContactId,
    getUserContactsByUserId
}

