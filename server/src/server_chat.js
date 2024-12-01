const dbHandler = require("./database/database_handler");
require("dotenv").config();
const express = require("express");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const userHandler = require("./model/user/user_handler");
const contactHandler = require("./model/user/mach_handler");
const socketHandler = require("./sockets/socket_handler");
const http = require("http");
const chatroomHandler = require("./chatroom/chatroom_handler");
const { header } = require("express-validator");
const requestValidator = require("./auth/validate_request");
const { body } = require('express-validator');
const { DB_INSTANCES } = require("./database/databases");

//Init
const app = express();
app.use(express.json());
const port = process.env.SERVER_PORT_CHAT;
const server = http.createServer(app);
socketHandler.socketInit(server);


const validationRules = {
    DELETE_CHATROOM_FROM_MATCH_ID_USER_ID_RULES: [
        body('input.user_id').notEmpty().isString().withMessage("User id is required"),
        body('input.match_id').notEmpty().isString().withMessage("match_id is required"),

    ]
}


function requestFieldsValidation(req, res, next) {
    logger.info("custom requestFieldsValidation");
    const { action } = req.body;
    switch (action) {
        case hostActions.PUT_MESSAGE_TO_USER_WITH_USER_ID: {
            logger.info("---> pendint to control request from " + action);
            break;

        }
        case hostActions.GET_CHATROOM_MESSAGES_BY_MATCH_ID: {
            logger.info("---> pendint to control request from " + action);
            break;
        }
        case hostActions.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID: {
            validationSet = validationRules.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID_RULES
            break;
        }
    }
    Promise.all(validationSet.map(validation => validation.run(req)))
        .then(() => next())
        .catch(next);
}

async function processRequest(req, res) {
    logger.info("processRequest");
    try {
        let result = requestValidator.requestDoValidation(req);
        if (result) {
            res.status(400).json(result);
        } else {
            const { action } = req.body;
            logger.info(action);

            switch (action) {
                case hostActions.PUT_MESSAGE_TO_USER_WITH_USER_ID: {
                    const receiverId = req.body.input.receiver_id;
                    const senderId = req.body.input.sender_id;
                    const matchId = req.body.input.match_id;
                    const message = req.body.input.message;
                    logger.info(
                        "--message: " +
                        message +
                        " receiver: " +
                        receiverId +
                        " match_id:" +
                        matchId
                    );

                    await chatroomHandler.putMessageInChatroomByMatchId(req.body.input);

                    await socketHandler.sendChatMessage(
                        "chat_message",
                        receiverId,
                        senderId,
                        message,
                        matchId
                    );

                    break;
                }

                case hostActions.GET_CHATROOM_MESSAGES_BY_MATCH_ID: {
                    result = await chatroomHandler.getMessagesInChatroomByMatchId(
                        req.body.input
                    );
                    break;
                }

                case hostActions.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID: {
                    result = await chatroomHandler.deleteChatRoomByMatchIdUserId(
                        req.body.input
                    );
                    break;
                }
            }
        }

        if (result && result.status) {
            res.status(result.status).json(result);
        } else {
            res.status(500).json({ message: "Error processing the request" });
        }
    } catch (error) {
        logger.info(error);
    }

}


app.post("/",
    requestValidator.requestAuthValidation,
    requestFieldsValidation,
    (req, res) => {
        processRequest(req, res);
    }
);




server.listen(port, () => {
    dbHandler.connectToDatabase(DB_INSTANCES.DB_CHAT).then((result) => {
        if (result == null) {
            throw "Db connection error";
        } else {
            console.log(`El servidor API está corriendo en el puerto ${port}`);
        }
    });
});
