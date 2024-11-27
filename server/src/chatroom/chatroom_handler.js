const chatroomCollection = "chatroom_collection";
const userContactCollection = "users_matchs";


const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");

async function getMatchByMatchIdInternal(input) {
  try {
    logger.info("Starts getMatchByMatchIdInternal");
    const matchId = input.match_id;
    const filter = { id: matchId };
    const dbResponse = await dbHandler.findWithFilters(filter, userContactCollection);

    if (dbResponse && (dbResponse.length > 0)) {
      let result = dbResponse[0];
      result.status = 200;
      logger.info("Match complete: "+JSON.stringify(result));
      return result;
    }
    
  }
  catch (error) {
    printJson(error);
  }
  return { status: 500 };
}



async function putMessageInChatroomByMatchId(input) {
  logger.info("Starts putMessageInChatroomByMatchId");
  try {
    const matchId = input.match_id;
    const senderId = input.sender_id;
    const receiverId = input.receiver_id;
    const message = input.message;
    const send_at = input.sent_at;
    const currentCollectionSender = chatroomCollection + "-" + matchId + "-" + senderId.substring(0, 5);
    const currentCollectionReceiver = chatroomCollection + "-" + matchId + "-" + receiverId.substring(0, 5);
    const matchInfo = await getMatchByMatchIdInternal(input);
    if (matchInfo.active == 1) {
      const payload = {
        match_id: matchId,
        sender_id: senderId,
        receiver_id: receiverId,
        message: message,
        sent_at: send_at,

      };

      await dbHandler.addDocument(payload, currentCollectionSender);
      await dbHandler.addDocument(payload, currentCollectionReceiver);
      return { status: 200 };
    } else {
      return { status: 403 };
    }

  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

async function getMessagesInChatroomByMatchId(input) {
  logger.info("Starts getMessagesInChatroomByMatchId");
  try {
    const matchId = input.match_id;
    const userId = input.user_id;
    const currentCollection = chatroomCollection + "-" + matchId + "-" + userId.substring(0, 5);
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

async function deleteChatRoomByMatchIdUserId(input) {
  logger.info("Starts deleteChatRoomByMatchIdUserId");
  try {
    const matchId = input.match_id;
    const userId = input.user_id;
    const currentCollection = chatroomCollection + "-" + matchId + "-" + userId.substring(0, 5);
    await dbHandler.deleteCollection(currentCollection);

    return { status: 200, messages: [] };
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}


async function removeChatroomForMatch(match) {
  try {
    logger.info("Starts removeChatroomForMatchId:" + JSON.stringify(match));
    const matchId = match.id;
    const user1 = match.users[0].user_id;
    const user2 = match.users[1].user_id;
    const currentCollectionUser1 = chatroomCollection + "-" + matchId + "-" + user1.substring(0, 5);
    const currentCollectionUser2 = chatroomCollection + "-" + matchId + "-" + user2.substring(0, 5);

    await dbHandler.deleteCollection(currentCollectionUser1);
    await dbHandler.deleteCollection(currentCollectionUser2);
    return 0;

  } catch (error) {
    logger.info(error);
  }
  return -1;
}




module.exports = {
  putMessageInChatroomByMatchId,
  getMessagesInChatroomByMatchId,
  deleteChatRoomByMatchIdUserId,
  removeChatroomForMatch
};
