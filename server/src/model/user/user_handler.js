const logger = require('../../logger/log');
const { v4: uuidv4 } = require('uuid');
const dbHandler = require('../../database/database_handler');
const bcrypt = require('bcrypt');
const tokenHandler = require('../../auth/token_generator')

const userColletion = "users";

async function hashPassword(plainPassword) {
    try {

        const salt = await bcrypt.genSalt(10);
        const hashedPassword = await bcrypt.hash(plainPassword, salt);
        return hashedPassword;

    } catch (error) {
        console.error('Error al hashear la contraseña:', error);
    }
    return null;
}

async function verifyPassword(plainPassword, hashedPassword) {
    try {
        const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
        return isMatch;
    } catch (error) {
        console.error('Error al verificar la contraseña:', error);
    }
    return false;
}

async function creatInternalUser(input) {
    const currentTime = Date.now(); 
    let user = {
        id: uuidv4(),
        name: input.name,
        email: input.email,
        phone: input.phone, 
        zip_code:input.zip_code,
        created_at: currentTime,
        update_at: currentTime
    }
    user.password = await hashPassword(input.password);
    user.surname = input.surname ? input.surname : ""
    return user;
}




async function registerUser(input) {
    logger.info("Start registerUser");
    let checkExist = await dbHandler.findWithFilters({ email: input.email }, userColletion);
    let result = {};
    if (checkExist) {
        result.status = 500;
        result.message = "User already exists";

    } else {
        let user = await creatInternalUser(input);
        let dbResponse = await dbHandler.addDocument(user, userColletion);
        if (dbResponse) {
            result = {
                status: 200,
                message: "User created successfully",
                response: {
                    user_id: user.id, 
                    create_at: user.created_at
                }

            };
        }
    }
    return result;
}

async function doLogin(input) {
    logger.info("Start doLogin: " + JSON.stringify(input));
    const hashPass = await hashPassword(input.password);

    logger.info("pass: " + hashPass);
    let result = {};
    const filters = {
        email: input.email,
    };

    let user = await dbHandler.findWithFilters(filters, userColletion);
    logger.info("user: " + JSON.stringify(user));
    if (user && user.id) {
        const passCheck = await verifyPassword(input.password, user.password);
        if (passCheck) {
            const currentToken = await tokenHandler.generateToken({ id: user.id, email: user.email })
            const currentRefreshToken = await tokenHandler.generateRefreshToken({ id: user.id, email: user.email })
            result = {
                status: 200,
                message: "Login ok",
                response: {
                    user_id: user.id,
                    name: user.name,
                    surname: user.surname,
                    email: user.email,
                    token: currentToken,
                    refresh_token: currentRefreshToken
                }
            }
        } else {
            result = {
                status: 500,
                message: "Wrong user or password"
            }
        }
    } else {
        result = {
            status: 500,
            message: "Wrong user or password"
        }
    }
    return result;

}




module.exports = {
    registerUser,
    doLogin
}



