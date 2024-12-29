const socketIo = require("socket.io");
const logger = require("../logger/log");
const jsonUtils = require("../utils/json_utils");

let io;
let mapUserSocket = new Map();
let mapSocketUser = new Map();

function socketInit(server) {
  logger.info("Starts socket init");
  try {
    io = socketIo(server);
    logger.info("after socket init");
    io.on("connection", (s) => {
      logger.info("New connection socket_id:" + s.id);
      logger.info("user_id:" + s.handshake.query.user_id);
      const userId = s.handshake.query.user_id;
      mapUserSocket.set(userId, { user_id: userId, socket: s });

      mapSocketUser.set(s.id, { user_id: userId, socket: s });

      s.on("disconnect", (socket) => {
        
        logger.info("Disconnect socket_id:" + s.id);
        const info = mapSocketUser.get(s.id);
        mapSocketUser.delete(s.id);
        mapUserSocket.delete(info.user_id);
      });
    });
  } catch (error) {
    logger.info(error);
  }
}

function sendMessageToUser(action, userId, scanned, message) {
  logger.info("Starts sendMessageToUser userId: " + userId);
  try {    
    const socket = mapUserSocket.get(userId).socket;
    logger.info("socket id:" + socket.id);
    if (socket) {
      let payload = {
        send_at: Date.now(),
        scanned: scanned,
        message: message,
      };
      payload = JSON.stringify(payload);
      socket.emit(action, payload);
      logger.info("after send value");
    }
  } catch (error) {
    logger.info(error);
  }
}

function sendMatchLost(action, userId, matchId) {
  logger.info("Starts sendMachLost userId: " + userId);
  try {
    const socket = mapUserSocket.get(userId).socket;
    logger.info("socket id:" + socket.id);
    if (socket) {
      let payload = {
        send_at: Date.now(),
        match_id: matchId
      };
      payload = JSON.stringify(payload);
      socket.emit(action, payload);
    }
  } catch (error) {
    logger.info(error);
  }
}



function sendChatMessage(action, receiverId, senderId, message, matchId) {
  logger.info("Starts sendChatMessage userId: " + receiverId);
  try {
    if (mapUserSocket.get(receiverId)) {
      const socket = mapUserSocket.get(receiverId).socket;

      if (socket) {
        logger.info("socket id:" + socket.id);
        let payload = {
          send_at: Date.now(),
          message: message,
          sender_id: senderId,
          match_id: matchId,
          receiver_id: receiverId,
        };
        payload = JSON.stringify(payload);
        socket.emit(action, payload);
        logger.info("after send value");
      }
    }
    else {
      logger.info("user not connected");
      return false;
    }
  } catch (error) {
    logger.info(error);
  }
  return true;
}

module.exports = {
  socketInit,
  sendMessageToUser,
  sendChatMessage,
  sendMatchLost
};
