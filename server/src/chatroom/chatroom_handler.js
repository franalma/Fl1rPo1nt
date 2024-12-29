const dbHandler = require("../database/database_handler");
const logger = require("../logger/log");
const { HOST_ERROR_CODES, genError } = require("../constants/host_error_codes");
const { DB_INSTANCES } = require("../database/databases");
const { printJson } = require("../utils/json_utils");

async function getMatchByMatchIdInternal(input) {
  try {
    logger.info("Starts getMatchByMatchIdInternal");
    const matchId = input.match_id;
    const filter = { id: matchId };
    const db = DB_INSTANCES.DB_API;
    const dbResponse = await dbHandler.findWithFiltersAndClient(db.client, filter, db.collections.user_contact_collection);

    if (dbResponse && (dbResponse.length > 0)) {
      let info = dbResponse[0];
      result = {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        ...info
      }
      logger.info("Match complete: " + JSON.stringify(result));
      return result;
    }
  }
  catch (error) {
    printJson(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function putMessageInChatroomByMatchId(input) {
  logger.info("Starts putMessageInChatroomByMatchId: "+JSON.stringify(input));
  try {
    const matchId = input.match_id;
    const senderId = input.sender_id;
    const receiverId = input.receiver_id;
    const message = input.message;
    const send_at = input.sent_at;
    const db = DB_INSTANCES.DB_CHAT;


    const currentCollectionSender = db.collections.chatroom_collection + "-" + matchId + "-" + senderId.substring(0, 5);
    const currentCollectionReceiver = db.collections.chatroom_collection + "-" + matchId + "-" + receiverId.substring(0, 5);
    const matchInfo = await getMatchByMatchIdInternal(input);
    if (matchInfo.active == 1) {
      const payload = {
        match_id: matchId,
        sender_id: senderId,
        receiver_id: receiverId,
        message: message,
        sent_at: send_at,

      };

      await dbHandler.addDocumentWithClient(db.client, payload, currentCollectionSender);
      await dbHandler.addDocumentWithClient(db.client, payload, currentCollectionReceiver);
      return { ...genError(HOST_ERROR_CODES.NO_ERROR) };
    } else {
      return { ...genError(HOST_ERROR_CODES.NOT_AUTHORIZED) };
    }

  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function getMessagesInChatroomByMatchId(input) {
  logger.info("Starts getMessagesInChatroomByMatchId");
  try {
    const matchId = input.match_id;
    const userId = input.user_id;
    const db = DB_INSTANCES.DB_CHAT;
    const currentCollection = db.collections.chatroom_collection + "-" + matchId + "-" + userId.substring(0, 5);
    const dbMessages = await dbHandler.findAllWithClient(db.client, currentCollection);
    let values = [];
    for (let item of dbMessages) {

      values.push({
        match_id: item.match_id,
        sender_id: item.sender_id,
        receiver_id: item.receiver_id,
        message: item.message,
        sent_at: item.sent_at,
      });
    }
    const result = { ...genError(HOST_ERROR_CODES.NO_ERROR), messages: values }
    return result;
  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function deleteChatRoomByMatchIdUserId(input) {
  logger.info("Starts deleteChatRoomByMatchIdUserId");
  try {
    const matchId = input.match_id;
    const userId = input.user_id;
    const db = DB_INSTANCES.DB_CHAT;
    const currentCollection = db.collections.chatroom_collection + "-" + matchId + "-" + userId.substring(0, 5);
    await dbHandler.deleteCollectionWithClient(db.client, currentCollection);

    return { ...genError(HOST_ERROR_CODES.NO_ERROR) };
  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}


async function removeChatroomForMatch(match) {
  try {
    logger.info("Starts removeChatroomForMatchId:" + JSON.stringify(match));
    const matchId = match.id;
    const user1 = match.users[0].user_id;
    const user2 = match.users[1].user_id;
    const db = DB_INSTANCES.DB_CHAT;
    const currentCollectionUser1 = db.collections.chatroom_collection + "-" + matchId + "-" + user1.substring(0, 5);
    const currentCollectionUser2 = db.collections.chatroom_collection + "-" + matchId + "-" + user2.substring(0, 5);

    await dbHandler.deleteCollectionWithClient(db.client, currentCollectionUser1);
    await dbHandler.deleteCollectionWithClient(db.client, currentCollectionUser2);
    return { ...genError(HOST_ERROR_CODES.NO_ERROR) };

  } catch (error) {
    logger.info(error);
  }
  return { ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR) };
}

async function putPendingMessage(receiverId, senderId) {
  logger.info("Starts putPendingMessage");
  try {
    const db = DB_INSTANCES.DB_CHAT;
    const filters = { user_id: receiverId, sender_id: senderId };
    let messageInfo = {};
    let value = 1;
    const dbResponse = await dbHandler.findWithFiltersAndClient(db.client, filters, db.collections.pending_message_collection);
    if (dbResponse != null && dbResponse.length > 0) {
      const messageInfo = dbResponse[0];

      if (messageInfo) {
        messageInfo.n_messages = messageInfo.n_messages + 1;
        // logger.info("Counter " + counter);


      }
      await dbHandler.updateDocumentWithClient(db.client, messageInfo, filters, db.collections.pending_message_collection);
    } else {
      messageInfo = {
        user_id: receiverId,
        sender_id: senderId,
        n_messages: value
      }
      await dbHandler.addDocumentWithClient(db.client, messageInfo, db.collections.pending_message_collection);
    }
  } catch (error) {
    logger.info(error);
  }
}

async function getPendingMessagesForUserIdContactId(userId, senderId) {
  logger.info("Starts getPendingMessagesForUserIdContactId");
  try {
    const db = DB_INSTANCES.DB_CHAT;
    const filters = { user_id: userId, sender_id: senderId };

    const dbResponse = await dbHandler.findWithFiltersAndClient(db.client, filters, db.collections.pending_message_collection);
    if (dbResponse != null && dbResponse.length > 0) {
      return dbResponse[0].n_messages;
    }
  } catch (error) {
    logger.info(error);
  }
  return 0;
}

async function removePendingMessagesForUserContactId(input) {
  logger.info("Starts removePendingMessages");
  try {
    const db = DB_INSTANCES.DB_CHAT;
    const filters = { user_id: input.user_id, sender_id: input.sender_id };
    await dbHandler.deleteDocumentWithClient(db.client, filters, db.collections.pending_message_collection);
    return {
      ...genError(HOST_ERROR_CODES.NO_ERROR)
    }

  } catch (error) {
    logger.info(error);
  }
  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR)
  }
}



module.exports = {
  putMessageInChatroomByMatchId,
  getMessagesInChatroomByMatchId,
  deleteChatRoomByMatchIdUserId,
  removeChatroomForMatch,
  putPendingMessage,
  getPendingMessagesForUserIdContactId,
  removePendingMessagesForUserContactId
};
