const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const userContactCollection = "users_matchs";
const sockerHandler = require("../../sockets/socket_handler");
const userHandler = require("./user_handler");
const { printJson } = require("../../utils/json_utils");

async function createMatchInternal(input) {
  logger.info("Starts createMatchInternal");
  let doc = {
    id: uuidv4(),
    source: 0,
    point_id: -1,
    flirt_id: input.flirt_id,
    location: input.location,
    created_at: Date.now(),
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
      contact_info: userQrInfo.contact_info
    },
    {
      user_id: input.contact_id,
      contact_info: contactQrInfo.contact_info
    },
  ];

  printJson(doc);
  return doc;
}

async function addUserContactByUserIdContactIdQrId(input) {
  logger.info("Starts addUserContactByUserIdContactIdQrId");
  let result = { status: 500 };

  try {
    let doc = await createMatchInternal(input);
    let dbResponse = await dbHandler.addDocument(doc, userContactCollection);

    if (dbResponse) {
      const updateUsersInfo = await userHandler.updateUserScansByUserIdContactId(
        input.user_id,
        input.contact_id
      );

      result = {
        status: 200,
        message: "Contact added sucessfully",
        contact_info: doc.contact_info,
        scans_performed: updateUsersInfo.scans_performed
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

async function removeUserContactByUserIdContactId(input) {
  logger.info("Starts removeUserContactByUserIdContactId");
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
    const filters = { users: { $elemMatch: { user_id: input.user_id } } };
    const dbResponse = await dbHandler.findWithFilters(filters, userContactCollection);

    if (dbResponse) {
      result.matchs = [];
      for (let item of dbResponse) {
        let contactUser = {};
        if (item.users[0].user_id === input.user_id) {
          contactUser = {
            user_id: item.users[1].user_id,
            contact_info: JSON.parse(item.users[1].contact_info)
          }

        } else {
          contactUser = {
            user_id: item.users[0].user_id,
            contact_info: JSON.parse(item.users[0].contact_info)
          }
        }


        let sharing = item.users[0].user_id === input.user_id ? JSON.parse(item.users[0].contact_info) : JSON.parse(item.users[1].contact_info);
        result.status = 200;
        result.matchs.push(
          {
            match_id: item.id,
            flirt_id: item.flirt_id,
            contact: contactUser,
            sharing: sharing

          }
        )
      }
    }
  } catch (error) {
    logger.info(error);
  }
  return result;



}

module.exports = {
  addUserContactByUserIdContactIdQrId,
  removeUserContactByUserIdContactId,
  getUserContactsByUserId,
  getAllUserMatchsByUserId
};
