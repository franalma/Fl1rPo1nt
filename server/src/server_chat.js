
require("dotenv").config();
const express = require("express");
const logger = require("./logger/log");
const hostActions = require("./constants/host_actions");
const http = require("http");
const chatroomHandler = require("./chatroom/chatroom_handler");
const { header } = require("express-validator");
const requestValidator = require("./auth/validate_request");
const { body } = require("express-validator");
const { DB_INSTANCES } = require("./database/databases");
const axios = require("axios");
const dbHandler = require("./database/database_handler");
const { printJson } = require("./utils/json_utils");
const app = express();
app.use(express.json());

async function sendToSocketServer(endpoint, data) {
    logger.info("Starts sendToSocketServer");
    try {
        const url = "http://" + process.env.SOCKET_SERVER + ":" + process.env.SOCKET_SERVER_PORT + endpoint;
        logger.info("--->url: " + url);

        const headers = {
            "Content-Type": "application/json",
        };
        const response = await axios.post(url, data, { headers });
        printJson(response);

        if (response.status == 200 && response.sent) {
            return true;
        }

    } catch (error) {
        logger.info(error);
    }
    return false;
}

const validationRules = {
    DELETE_CHATROOM_FROM_MATCH_ID_USER_ID_RULES: [
        body("input.user_id")
            .notEmpty()
            .isString()
            .withMessage("User id is required"),
        body("input.match_id")
            .notEmpty()
            .isString()
            .withMessage("match_id is required"),
    ],

    REMOVE_PENDING_CHAT_MESSGES_BY_USER_ID_SENDER_ID_RULES: [
        body("input.user_id")
            .notEmpty()
            .isString()
            .withMessage("User id is required"),
        body("input.sender_id")
            .notEmpty()
            .isString()
            .withMessage("Sender id is required"),
    ],
};

function requestFieldsValidation(req, res, next) {
    logger.info("custom requestFieldsValidation: " + JSON.stringify(req, body));

    let validationSet = [];
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
            validationSet =
                validationRules.DELETE_CHATROOM_FROM_MATCH_ID_USER_ID_RULES;
            break;
        }

        case hostActions.REMOVE_PENDING_CHAT_MESSGES_BY_USER_ID_SENDER_ID: {
            validationSet =
                validationRules.REMOVE_PENDING_CHAT_MESSGES_BY_USER_ID_SENDER_ID_RULES;
            break;
        }
    }
    Promise.all(validationSet.map((validation) => validation.run(req)))
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

                    const response = await chatroomHandler.putMessageInChatroomByMatchId(req.body.input);
                    if (response.status == 200) {
                        const socketPayload = {
                            message_type: "chat_message",
                            receiver_id: receiverId,
                            sender_id: senderId,
                            message: message,
                            match_id: matchId,
                        };

                        const isMessageSent = await sendToSocketServer("/chat", socketPayload);

                        if (isMessageSent == false) {
                            await chatroomHandler.putPendingMessage(receiverId, senderId);
                        }
                        result = { status: 200, message: "OK" };

                    }
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

                case hostActions.REMOVE_PENDING_CHAT_MESSGES_BY_USER_ID_SENDER_ID: {
                    result = await chatroomHandler.removePendingMessagesForUserContactId(
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

app.post(
    "/chat/base",
    requestValidator.requestAuthValidation,
    requestFieldsValidation,
    (req, res) => {
        processRequest(req, res);
    }
);


module.exports = {
    app,
};
