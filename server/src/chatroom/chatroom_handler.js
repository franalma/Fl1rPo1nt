const chatroomCollection = "chatroom_collection";
const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");

async function putMessageInChatroomByMatchId(input) {
  logger.info("Starts putMessageInChatroomByMatchId");
  try {
    const matchId = input.match_id;
    const senderId = input.sender_id;
    const receiverId = input.receiver_id;
    const message = input.message;
    const send_at = input.sent_at;
    const currentCollection = chatroomCollection + "/" + matchId;

    const payload = {
      match_id: matchId,
      sender_id: senderId,
      receiver_id: receiverId,
      message: message,
      sent_at: send_at,
    };
    await dbHandler.addDocument(payload, currentCollection);
    return { status: 200 };
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

async function getMessagesInChatroomByMatchId(input) {
  logger.info("Starts getMessagesInChatroomByMatchId");
  try {
    const matchId = input.match_id;
    const currentCollection = chatroomCollection + "/" + matchId;
    const dbMessages = await dbHandler.findAll(currentCollection);
    let result = { status: 200, messages: [] };

    for (let item of dbMessages) {
      result.messages.push({
        match_id: item.match_id,
        sender_id: item.sender_id,
        receiver_id: item.receiver_id,
        message: item.message,
        sent_at: item.sent_at,
      });
    }
    return result;
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

module.exports = {
  putMessageInChatroomByMatchId,
  getMessagesInChatroomByMatchId,
};
