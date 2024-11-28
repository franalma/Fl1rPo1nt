const userContactCollection = "users_matchs";

const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");

const sockerHandler = require("../../sockets/socket_handler");
const userHandler = require("./user_handler");
const chatroomHandler = require("./../../chatroom/chatroom_handler");
const { printJson } = require("../../utils/json_utils");
const { sendMatchLost } = require("../../sockets/socket_handler");

async function createMatchInternal(input) {
  logger.info("Starts createMatchInternal");
  let doc = {
    id: uuidv4(),
    source: 0,
    point_id: -1,
    flirt_id: input.flirt_id,
    location: input.location,
    created_at: Date.now(),
    active: 1,
  };

  const contactQrInfo = await userHandler.getUserInfoByUserIdQrId(
    input.contact_id,
    input.contact_qr_id
  );

  const userQrInfo = await userHandler.getUserInfoByUserIdQrId(
    input.user_id,
    input.user_qr_id
  );

  doc.users = [
    {
      user_id: input.user_id,
      contact_info: userQrInfo.contact_info,
    },
    {
      user_id: input.contact_id,
      contact_info: contactQrInfo.contact_info,
    },
  ];

  printJson(doc);
  return doc;
}

async function createMatchExternal(item, input)  {
  logger.info("createMatchExternal " + JSON.stringify(item));
  try {
    let contactUser = {};
    if (item.users[0].user_id === input.user_id) {
      contactUser = {
        user_id: item.users[1].user_id,
        contact_info: JSON.parse(item.users[1].contact_info),
      };
    } else {
      contactUser = {
        user_id: item.users[0].user_id,
        contact_info: JSON.parse(item.users[0].contact_info),
      };
    }

    let sharing =
      item.users[0].user_id === input.user_id
        ? JSON.parse(item.users[0].contact_info)
        : JSON.parse(item.users[1].contact_info);
    let match = {
      match_id: item.id,
      flirt_id: item.flirt_id,
      contact: contactUser,
      sharing: sharing,
    };

    logger.info("contactUser: "+JSON.stringify(contactUser));
    const userInfo = await userHandler.getUserPublicProfileByUserId(contactUser); 
    printJson(userInfo);
    match.profile_image = userInfo.profile_image; 



    return match;
  } catch (error) {
    logger.info(error);
  }
  return {};
}

async function getMatchByMatchIdInternal(input) {
  try {
    logger.info("Starts getMatchByMatchIdInternal");
    const matchId = input.match_id;
    const filter = { id: matchId };
    const dbResponse = await dbHandler.findWithFilters(
      filter,
      userContactCollection
    );

    if (dbResponse && dbResponse.length > 0) {
      let result = dbResponse[0];
      result.status = 200;
      logger.info("Match complete: " + JSON.stringify(result));
      return result;
    }
  } catch (error) {
    printJson(error);
  }
  return { status: 500 };
}

async function addUserContactByUserIdContactIdQrId(input) {
  logger.info("Starts addUserContactByUserIdContactIdQrId");
  let result = { status: 500 };

  try {
    let doc = await createMatchInternal(input);
    let dbResponse = await dbHandler.addDocument(doc, userContactCollection);

    if (dbResponse) {
      const updateUsersInfo =
        await userHandler.updateUserScansByUserIdContactId(
          input.user_id,
          input.contact_id
        );

      result = {
        status: 200,
        message: "Contact added sucessfully",
        contact_info: doc.contact_info,
        scans_performed: updateUsersInfo.scans_performed,
      };
      const message = {
        requested_user_id: input.user_id,
      };
      sockerHandler.sendMessageToUser(
        "new_contact_request",
        input.contact_id,
        updateUsersInfo.scanned,
        message
      );
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getUserContactsByUserId(input) {
  logger.info("Starts getUserContactsByUserId");
  const filter = { user_id: input.user_id };
  let dbResponse = await dbHandler.findWithFilters(
    filter,
    userContactCollection
  );
  let result = {};

  if (dbResponse) {
    result.status = 200;
    result.contacts = [];
    for (var item of dbResponse) {
      result.contacts.push({
        user_id: item.user_id,
        contact_info: item.contact_info,
      });
    }
  }

  return result;
}

async function getAllUserMatchsByUserId(input) {
  logger.info("Starts getAllUserMatchsByUserId");
  let result = {};
  try {
    const filters = {
      users: { $elemMatch: { user_id: input.user_id } },
      active: 1,
    };
    const dbResponse = await dbHandler.findWithFilters(
      filters,
      userContactCollection
    );

    if (dbResponse) {
      result.matchs = [];
      for (let item of dbResponse) {
        const match = await createMatchExternal(item, input);
        result.matchs.push(match);
      }
      result.status = 200;
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}

async function diableMatchByMatchIdUserId(input) {
  try {
    logger.info("Starts disableMatchByMatchId: " + JSON.stringify(input));
    const requesterId = input.user_id;
    const matchId = input.match_id;
    const filter = { id: matchId };
    const payload = {
      active: 0,
      requester_id: requesterId,
      updated_at: Date.now(),
    };
    logger.info(JSON.stringify(payload));
    const dbResponse = await dbHandler.updateDocument(
      payload,
      filter,
      userContactCollection
    );

    if (dbResponse) {
      const matchInfo = await getMatchByMatchIdInternal(input);
      const deletionResult = await chatroomHandler.removeChatroomForMatch(
        matchInfo
      );
      logger.info("Deletion result: " + deletionResult);

      let userToNotify = "";
      if (matchInfo.users[0].user_id == requesterId) {
        userToNotify = matchInfo.users[1].user_id;
      } else {
        userToNotify = matchInfo.users[0].user_id;
      }
      sendMatchLost("match_lost", userToNotify, matchId);

      return { status: 200 };
    }
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

module.exports = {
  addUserContactByUserIdContactIdQrId,
  getUserContactsByUserId,
  getAllUserMatchsByUserId,
  diableMatchByMatchIdUserId,
};
