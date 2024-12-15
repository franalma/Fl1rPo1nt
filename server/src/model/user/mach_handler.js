const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const userHandler = require("./user_handler");
const chatroomHandler = require("./../../chatroom/chatroom_handler");
const smartPointHandler = require("./../smart_points/smart_points_handler");
const { printJson } = require("../../utils/json_utils");
const { sendMatchLost } = require("../../sockets/socket_handler");
const { DB_INSTANCES } = require("../../database/databases");
const {
  genError,
  HOST_ERROR_CODES,
} = require("../../constants/host_error_codes");
const axios = require("axios");

async function createMatchInternalForQr(input) {
  logger.info("Starts createMatchInternalForQr");
  let doc = {
    id: uuidv4(),
    source: input.source,
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
  return doc;
}


async function createMatchInternalForMap(input) {
  logger.info("Starts createMatchInternalForMap: " + JSON.stringify(input));
  let doc = {
    id: uuidv4(),
    source: input.source,
    flirt_id: input.flirt_id,
    location: input.location,
    created_at: Date.now(),
    active: 1,
  };

  const contactPublicProfile = await userHandler.getUserPublicProfileByUserId({ user_id: input.contact_id });
  const contactQrInfo = await userHandler.getUserInfoByUserIdQrId(
    contactPublicProfile.id,
    contactPublicProfile.default_qr_id
  );
  logger.info("--->map contactqrinfo: " + JSON.stringify(contactQrInfo));

  const userQrInfo = await userHandler.getUserInfoByUserIdQrId(
    input.user_id,
    input.user_qr_id
  );


  logger.info("--->map userQrInfo: " + JSON.stringify(userQrInfo));
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

  return doc;
}


async function createMatchInternalForPoint(input) {
  logger.info("Starts createMatchInternalForPoint" + JSON.stringify(input));
  let doc = {
    id: uuidv4(),
    source: input.source,
    flirt_id: input.flirt_id,
    location: input.location,
    created_at: Date.now(),
    active: 1,
  };

  const smartPointInfo = (await smartPointHandler.getSmartPointByPointId(input)).point;
  const userQrInfo = await userHandler.getUserInfoByUserIdQrId(
    input.user_id,
    input.user_qr_id
  );

  const contactInfo = {
    name: smartPointInfo.user_name ? smartPointInfo.user_name : "",
    phone: smartPointInfo.user_phone ? smartPointInfo.user_phone : "",
    audios: false,
    pictures: false,
    networks: smartPointInfo.networks
  }

  doc.users = [
    {
      user_id: input.user_id,
      contact_info: userQrInfo.contact_info,
    },
    {
      user_id: input.contact_id,
      contact_info: JSON.stringify(contactInfo)
    },
  ];

  return doc;
}

async function createMatchExternal(item, input) {
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

    logger.info("contactUser: " + JSON.stringify(contactUser));
    const userInfo = await userHandler.getUserPublicProfileByUserId(
      contactUser
    );

    printJson(userInfo);
    match.profile_image = userInfo.profile_image;
    match.pending_messages =
      await chatroomHandler.getPendingMessagesForUserIdContactId(
        input.user_id,
        contactUser.user_id
      );

    return match;
  } catch (error) {
    logger.info(error);
  }
  return {};
}

async function getMatchByMatchIdInternal(input) {
  try {
    logger.info("Starts getMatchByMatchIdInternal");
    const db = DB_INSTANCES.DB_API;
    const matchId = input.match_id;
    const filter = { id: matchId };
    const dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.user_contact_collection
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
  logger.info(
    "Starts addUserContactByUserIdContactIdQrId:" + JSON.stringify(input)
  );

  try {
    const db = DB_INSTANCES.DB_API;

    const isUserExist = await userHandler.checkUserExist(input.user_id);
    const isContactExist = await userHandler.checkUserExist(input.contact_id);

    if (!isUserExist || !isContactExist) {
      return {
        ...genError(HOST_ERROR_CODES.USER_NOT_EXIST),
      };
    }

    if (input.user_id == input.contact_id) {
      return {
        ...genError(HOST_ERROR_CODES.MATCH_CONTACTS_CONFLICT),
      };
    }

    let doc = {};
    if (input.source == 0) {
      //qr
      doc = await createMatchInternalForQr(input);
    } else if (input.source == 1) {
      //point
      doc = await createMatchInternalForPoint(input);
    } else if (input.source == 2) {
      //map
      doc = await createMatchInternalForMap(input);
    }



    let dbResponse = await dbHandler.addDocumentWithClient(
      db.client,
      doc,
      db.collections.user_contact_collection
    );

    if (dbResponse) {
      const updateUsersInfo =
        await userHandler.updateUserScansByUserIdContactId(
          input.user_id,
          input.contact_id
        );

      result = {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
        contact_info: doc.contact_info,
        scans_performed: updateUsersInfo.scans_performed,
      };

      const requestedUserInfo = await userHandler.getUserPublicProfileByUserId(
        input
      );

      const payload = {
        action: "new_contact_request",
        contact_id: input.contact_id,
        scanned: updateUsersInfo.scanned,
        requested_user: requestedUserInfo,
      };

      const urlRealTimeHost = `${process.env.CHAT_HOST_PATH}:${process.env.SERVER_PORT_CHAT}${process.env.NEW_CONTACT_ENDPOINT}`;
      logger.info(`real time url: ${urlRealTimeHost}`);
      const resNewContact = await axios.post(urlRealTimeHost, payload);
      printJson(resNewContact);
      if (resNewContact.status == 200) {
        return result;
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return { ...genError(HOST_ERROR_CODES.USER_ALREADY_IN_YOUR_CONTACTS) };
}

async function getUserContactsByUserId(input) {
  logger.info("Starts getUserContactsByUserId");
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { user_id: input.user_id };
    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.user_contact_collection
    );

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
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function getAllUserMatchsByUserId(input) {
  logger.info("Starts getAllUserMatchsByUserId: " + JSON.stringify(input));
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = {
      users: { $elemMatch: { user_id: input.user_id } },

    };

    if (!input.include_disabled) {
      filters.active = 1;
    }

    const dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_contact_collection
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
    const db = DB_INSTANCES.DB_API;
    const requesterId = input.user_id;
    const matchId = input.match_id;
    const filter = { id: matchId };
    const payload = {
      active: 0,
      requester_id: requesterId,
      updated_at: Date.now(),
    };
    logger.info(JSON.stringify(payload));
    const dbResponse = await dbHandler.updateDocumentWithClient(
      db.client,
      payload,
      filter,
      db.collections.user_contact_collection
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


async function updateAudiosAccessForMarchIdContactId(input) {
  logger.info("Starts updateAudiosAccessForMarchIdContactId:"+JSON.stringify(input));
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { id: input.match_id };
    let docs = await dbHandler.findWithFiltersAndClient(db.client, filter, db.collections.user_contact_collection);
    if (docs && docs.length > 0) {
      let doc = docs[0];
      let contactInfo = {};
      if (doc.users[0].user_id == input.user_id) {
        contactInfo = JSON.parse(doc.users[0].contact_info);
        contactInfo.audios = input.audio_access;
        doc.users[0].contact_info = JSON.stringify(contactInfo);
      } else {
        contactInfo = JSON.parse(doc.users[1].contact_info);
        contactInfo.audios = input.audio_access;
        doc.users[1].contact_info = JSON.stringify(contactInfo);
      }
      await dbHandler.updateDocumentWithClient(db.client, doc, filter, db.collections.user_contact_collection);
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR)
      }
    }
  } catch (error) {
    logger.info(error);
    return {
      ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR)
    }
  }
  return {
    ...genError(HOST_ERROR_CODES.NOT_POSSIBLE_TO_UPDATE_MATCH)
  }
}

async function updatePicturesAccessForMarchIdContactId(input) {
  logger.info("Starts updatePicturesAccessForMarchIdContactId:"+JSON.stringify(input));
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { id: input.match_id };
    let docs = await dbHandler.findWithFiltersAndClient(db.client, filter, db.collections.user_contact_collection);
    if (docs && docs.length > 0) {
      let doc = docs[0];
      let contactInfo = {};
      if (doc.users[0].user_id == input.user_id) {
        contactInfo = JSON.parse(doc.users[0].contact_info);
        contactInfo.pictures = input.picture_access;
        doc.users[0].contact_info = JSON.stringify(contactInfo);
      } else {
        contactInfo = JSON.parse(doc.users[1].contact_info);
        contactInfo.pictures = input.picture_access;
        doc.users[1].contact_info = JSON.stringify(contactInfo);
      }
      await dbHandler.updateDocumentWithClient(db.client, doc, filter, db.collections.user_contact_collection);
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR)
      }
    }
  } catch (error) {
    logger.info(error);
    return {
      ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR)
    }
  }
  return {
    ...genError(HOST_ERROR_CODES.NOT_POSSIBLE_TO_UPDATE_MATCH)
  }
}



module.exports = {
  addUserContactByUserIdContactIdQrId,
  getUserContactsByUserId,
  getAllUserMatchsByUserId,
  diableMatchByMatchIdUserId,
  updateAudiosAccessForMarchIdContactId,
  updatePicturesAccessForMarchIdContactId
};
