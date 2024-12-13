const logger = require("../logger/log");
const dbHandler = require("../database/database_handler");
const authUtils = require("./auth_utils");
const databases = require("../database/databases");
const { v4: uuidv4 } = require("uuid");
const userHandler = require("../model/user/user_handler");
const { printJson } = require("../utils/json_utils");
const mailHandler = require("../mail/mail_handler");
const tokenHandler = require("./token_generator");
const { genError, HOST_ERROR_CODES } = require("./../constants/host_error_codes")
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
                zip_code: input.zip_code,
                born_date: input.born_date
            }
            const isCreated = await userHandler.registerUser(userProfile);

            if (isCreated && isCreated.status == 200) {
                result.user_id = user.id;
                const tokenLife = process.env.TOKEN_ACTIVATION_LIFE;
                const token = tokenHandler.generateToken(user, tokenLife);
                const newValues = {
                    token: token
                };
                await dbHandler.updateDocumentWithClient(authDatabase.client, newValues, { id: user.id }, authDatabase.collections.user_collection);
                await mailHandler.sendMailToUser(user.email, token, user.id);
                result = genError(HOST_ERROR_CODES.NO_ERROR);
            } else {
                await dbHandler.deleteDocumentWithClient(authDatabase.client, { id: user.id }, authDatabase.collections.user_collection);
                result = genError(HOST_ERROR_CODES.NOT_POSSIBLE_TO_REGISTER_USER);
            }


        } else {
            result = genError(HOST_ERROR_CODES.USER_EXIST);
        }

    } catch (error) {
        logger.info(error);
        result = genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR);
    }
    return result;
}

async function activateAccount(token, userId) {
    logger.info("Starts activateAccount");
    try {
        let result = tokenHandler.verifyToken(token);
        if (result == true) {
            const filters = { token: token, id: userId, activated: 0 };
            const newValues = {
                activated: 1,
                enabled: 1
            };
            const dbResult = await dbHandler.updateDocumentWithClient(authDatabase.client, newValues, filters, authDatabase.collections.user_collection);
            if (dbResult != null) {

                return true;
            }
        }

    } catch (error) {
        logger.info(error);
    }
    return false;
}

async function doLogin(input) {
    logger.info("Start doLogin: " + JSON.stringify(input));
    let result = {};
    try {
        const dbAuth = databases.DB_INSTANCES.DB_AUTH;
           
        let filters = {
            email: input.email,
        };

        let users = await dbHandler.findWithFiltersAndClient(dbAuth.client, filters, dbAuth.collections.user_collection);
        logger.info("users: " + JSON.stringify(users));
        if (users && users.length == 1 && users[0].id) {
            let user = users[0];
            if (user.activated == 1) {
                logger.info("user is activated");
                if (user.enabled == 1) {
                    logger.info("User is unlocked");
                    const passCheck = await authUtils.verifyPassword(input.password, user.password);
                    logger.info("check pass: " + passCheck);

                    if (passCheck) {
                        const currentToken = tokenHandler.generateToken({
                            id: user.id,
                            email: user.email,
                        });
                        const currentRefreshToken = tokenHandler.generateRefreshToken({
                            id: user.id,
                            email: user.email,
                        });
                        user.token = currentToken;
                        user.currentRefreshToken = currentRefreshToken;
                        let userInfo = await userHandler.getUserInfoByUserId(user);
                        logger.info("----->name: "+userInfo.name);
                        result = { ...genError(HOST_ERROR_CODES.NO_ERROR) , ...userInfo };
                        const updatedInfo = {
                            last_login: Date.now(),
                        }
                        //update last login
                        await dbHandler.updateDocumentWithClient(dbAuth.client, updatedInfo, { id: user.id }, dbAuth.collections.user_collection);

                    } else {
                        result = genError(HOST_ERROR_CODES.WRONG_USER_PASS);
                    }


                } else {
                    logger.info("User is blocked");
                    result = genError(HOST_ERROR_CODES.USER_BLOCKED);
                }

            } else {
                logger.info("user is not activated");
                result = genError(HOST_ERROR_CODES.USER_NOT_ACTIVATED);
            }

        } else {
            result = genError(HOST_ERROR_CODES.WRONG_USER_PASS);
        }
    } catch (error) {
        logger.info(error);
    }


    return result;
}

module.exports = {
    doRegisterUser,
    activateAccount,
    doLogin
}

