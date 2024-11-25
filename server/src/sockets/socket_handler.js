const socketIo = require('socket.io');
const logger = require('../logger/log');
const jsonUtils = require('../utils/json_utils');

let io;
let mapSockets = {};

function socketInit(server) {
    logger.info("Starts socket init");
    try {
        io = socketIo(server);

        io.on('connection', (s) => {
            logger.info("New connection socket_id:" + s.id);
            logger.info("user_id:" + s.handshake.query.user_id);
            const userId = s.handshake.query.user_id;
            mapSockets[userId] = { "user_id": userId, "socket": s };
            
            s.on('disconnect', (socket) => {
                logger.info("Disconnect socket_id:" + socket.id);
            });
        });
    } catch (error) {
        logger.info(error);
    }

}

function sendMessageToUser(action, userId, scanned, message) {
    logger.info("Starts sendMessageToUser userId: " + userId);
    try {
        const socket = mapSockets[userId]["socket"];
        logger.info("socket id:" + socket.id)
        if (socket) {
            let payload = {
                send_at: Date.now(),
                scanned: scanned,
                message: message
            }
            payload = JSON.stringify(payload);
            socket.emit(action, payload);
            logger.info("after send value");
        }
    } catch (error) {
        logger.info(error);
    }
}

function sendChatMessage(action, userId, message) {
    logger.info("Starts sendChatMessage userId: " + userId);
    try {
        const socket = mapSockets[userId]["socket"];
        logger.info("socket id:" + socket.id)
        if (socket) {
            let payload = {
                send_at: Date.now(),                
                message: message
            }
            payload = JSON.stringify(payload);
            socket.emit(action, payload);
            logger.info("after send value");
        }
    } catch (error) {
        logger.info(error);
    }
}





module.exports = {
    socketInit,
    sendMessageToUser,
    sendChatMessage
}

