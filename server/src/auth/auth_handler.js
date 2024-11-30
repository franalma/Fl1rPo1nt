const logger = require("../logger/log");
const dbHandler = require("../database/database_handler");
const authUtils = require("./auth_utils");
const databases = require("../database/databases");
const { v4: uuidv4 } = require("uuid");
const userHandler = require("../model/user/user_handler");
const { printJson } = require("../utils/json_utils");
const mailHandler = require("../mail/mail_handler");
const tokenHandler = require("./token_generator");

const authDatabase = databases.DB_INSTANCES.DB_AUTH;

async function createUserAuthInternal(input) {
    logger.info("Starts createUserAuthInternal:" + JSON.stringify(input));
    try {
        const currentTime = Date.now();
        let user = {
            id: uuidv4(),
            email: input.email,
            name: input.name,
            created_at: currentTime,
            updated_at: currentTime,
            activated: 0,
            last_login: 0,
            enabled: 0
        };
        user.password = await authUtils.hashPassword(input.password);
        return user;
    } catch (error) {
        logger.info(error);
    }
    return {};
}


async function doRegisterUser(input) {
    logger.info("Starts doRegisterUser: " + JSON.stringify(input));
    let result = { status: 200 };
    try {
        let user = await createUserAuthInternal(input);
        logger.info(`internal user: ${JSON.stringify(user)}`);
        let dbResult = await dbHandler.addDocumentWithClient(authDatabase.client, user, authDatabase.collections.user_collection);


        if (dbResult != null) {
            logger.info("registered");
            result.description = "User registered";
            const userProfile = {
                id: user.id,
                created_at: user.created_at,
                email: user.email,
                phone: input.phone,
                name: user.name,
                surname: input.surname,
                zip_code: input.zip_code
            }
            const isCreated = await userHandler.registerUser(userProfile);

            if (isCreated && isCreated.status == 200) {
                result.user_id = user.id;
                const token = tokenHandler.generateToken(user);
                const newValues = {
                    token: token
                };
                await dbHandler.updateDocumentWithClient(authDatabase.client, newValues, { id: user.id }, authDatabase.collections.user_collection);
                await mailHandler.sendMailToUser(user.email, token, user.id);
            } else {
                await dbHandler.deleteDocumentWithClient(authDatabase.client, { id: user.id }, authDatabase.collections.user_collection);
                result.description = "Not possible to create user";
                result.status = 500;
            }


        } else {
            result.description = "User exists";
            result.status = 302;
        }

    } catch (error) {
        logger.info(error);
        result = { status: 500, info: error };
    }
    return result;
}

async function activateAccount(token, userId) {
    logger.info("Starts activateAccount");
    try {
        const filters = { token: token, id: userId };
        const newValues = {
            activated: 1,
            enabled: 1
        };
        const dbResult = await dbHandler.updateDocumentWithClient(authDatabase.client, newValues, filters, authDatabase.collections.user_collection);
        if (dbResult != null){
            return true; 
        }
        
    } catch (error) {
        logger.info(error);
    }
    return false; 
}


module.exports = {
    doRegisterUser,
    activateAccount
}

