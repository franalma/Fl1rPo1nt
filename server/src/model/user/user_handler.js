const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const { getUserQrByUserId } = require("../qr/qr_handler");
const s3Handler = require("../../files/s3_handler");
const {
  genError,
  HOST_ERROR_CODES,
} = require("./../../constants/host_error_codes");

const databases = require("../../database/databases");
const { DB_INSTANCES } = require("../../database/databases");

async function creatInternalUser(input) {
  const currentTime = Date.now();
  let user = {
    id: input.id,
    name: input.name,
    email: input.email,
    phone: input.phone,
    zip_code: input.zip_code,
    updated_at: input.created_at,
    scanned_count: 0,
    scans_performed: 0,
    networks: [],
    qr_values: [],
    hobbies: [],
    gender: {},
    created_at: currentTime,
    updated_at: currentTime,
    user_interests: {
      relationship: {},
      sex_alternative: {},
      gender_preference: {},
    },
    biography: "",
    profile_image_id: "",
    default_qr_id: "",
    radio_visibility: 10,
    born_date: input.born_date,
    subscription: {},
  };

  return user;
}

async function getImageByUserIdImageId(input) {
  logger.info("Starts getImageByUserIdImageId:" + JSON.stringify(input));
  try {
    const db = DB_INSTANCES.DB_MULT;
    const filters = { $or: input.values };
    logger.info(JSON.stringify(filters));
    const dbFiles = await dbHandler.findWithFiltersAndClient(
      db.client,
      filters,
      db.collections.user_images_collection
    );
    if (dbFiles) {
      let result = { status: 200, files: [] };
      for (let file of dbFiles) {
        try {
          const secureUrl = await s3Handler.getPresignedUrl(
            "floiint-bucket",
            `users/images/${input.user_id}/${file.filename}`
          );
          // const secureUrl = generateSignedImageUrl(file.filename);
          result.files.push({
            file_id: file.file_id,
            url: secureUrl,
            created_at: 0,
            filename: "",
          });
        } catch (error) {
          logger.info(error);
        }
      }
      return result;
    }
  } catch (error) {
    logger.info(error);
  }
  return { status: 500 };
}

async function createPublicProfileUser(input) {
  logger.info("Starts createPublicProfileUser:" + JSON.stringify(input));
  let user = {};
  try {
    user = {
      id: input.id,
      name: input.name,
      user_interest: input.user_interests,
      biography: input.biography,
      hobbies: input.hobbies,
      gender: input.gender,
      default_qr_id: input.default_qr_id,
      born_date: input.born_date,
      subscription: input.subscription,
    };

    if (input.profile_image_id) {
      const query = {
        values: [
          {
            user_id: input.id,
            file_id: input.profile_image_id,
          },
        ],
      };
      query.user_id = input.id;
      const imageData = await getImageByUserIdImageId(query);

      if (imageData.status == 200) {
        user.profile_image =
          imageData.files.length > 0 ? imageData.files[0] : "";
      }
    }
    logger.info("--public profile: " + JSON.stringify(user));
  } catch (error) {
    logger.info(error);
  }

  return user;
}

function createUserLocationExternal(value) {
  logger.info("createUserLocationExternal: " + JSON.stringify(value));
  logger.info("user_id: " + value.user_id);
  const result = {
    user_id: value.user_id,
    location: [value.location.coordinates[1], value.location.coordinates[0]],
  };

  logger.info("createUserLocationExternal result: " + JSON.stringify(result));

  return result;
}

async function checkUserExist(userId) {
  logger.info("Starts checkUserExist: " + userId);
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { id: userId };
    const dbResult = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.user_collection
    );
    if (dbResult && dbResult.length > 0) {
      return true;
    }
  } catch (error) {
    logger.info(error);
  }
  return false;
}

async function registerUser(input) {
  logger.info("Start registerUser: " + JSON.stringify(input));
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;

    let user = await creatInternalUser(input);
    let dbResponse = await dbHandler.addDocumentWithClient(
      db.client,
      user,
      db.collections.user_collection
    );
    if (dbResponse) {
      result = {
        status: 200,
        message: "User created successfully",
        response: {
          user_id: user.id,
          create_at: user.created_at,
        },
      };
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}

async function getUserInfoByUserId(input) {
  logger.info("Starts getUserInfoByUserId");
  let result = {};
  try {
    const dbApi = databases.DB_INSTANCES.DB_API;
    let filters = {
      id: input.id,
    };
    logger.info("-->filter: " + JSON.stringify(filters));
    let dbRes = await dbHandler.findWithFiltersAndClient(
      dbApi.client,
      filters,
      dbApi.collections.user_collection
    );

    const user = dbRes[0];

    result = {
      response: {
        user_id: input.id,
        name: user.name,
        phone: user.phone,
        email: input.email,
        token: input.token,
        refresh_token: input.currentRefreshToken,
        networks: user.networks,
        user_interests: user.user_interests,
        qr_values: user.qr_values,
        biography: user.biography,
        hobbies: user.hobbies,
        profile_image_id: user.profile_image_id,
        scanned_count: user.scanned_count,
        scans_performed: user.scans_performed,
        default_qr_id: user.default_qr_id,
        radio_visibility: user.radio_visibility,
        gender: user.gender ? user.gender : {},
        born_date: user.born_date,
        subscription: user.subscription,
      },
    };

    return result;
  } catch (error) {
    logger.info(error);
  }
  return result;
}

async function updateUserNetworksByUserId(input) {
  logger.info("Start updateUserNetworksByUserId");
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      networks: input.values.networks,
      updated_at: Date.now(),
    };
    const dbResponse = await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
    if (dbResponse) {
      result.status = 200;
      result.message = "Networks updated";
      result.networks = input.values.networks;
    } else {
      result.status = 500;
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function updateUserSearchingRangeByUserId(input) {
  logger.info("Starts updateUserSearchingRangeByUserId");
  let result = {};

  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      exploring_max_radio: input.distance,
      updated_at: Date.now(),
    };
    const dbResponse = await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
    if (dbResponse) {
      result.status = 200;
      result.message = "Exploring radio updated";
      result.distance = input.distance;
    } else {
      result.status = 500;
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function updateUserInterestsByUserId(input) {
  logger.info("Starts updateUserInterestsByUserId :" + JSON.stringify(input));

  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      user_interests: input.values.user_interests,
      updated_at: Date.now(),
    };
    const dbResponse = await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
    logger.info("-> db result: " + dbResponse);
    if (dbResponse) {
      return {
        ...genError(HOST_ERROR_CODES.NO_ERROR),
      };
    }
  } catch (error) {
    logger.info(error);
  }

  return {
    ...genError(HOST_ERROR_CODES.INTERNAL_SERVER_ERROR),
  };
}

async function updateUserQrsByUserId(input) {
  logger.info("Starts updateUserInterestsByUserId");
  let result = {};

  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    let qrValues = [];
    for (let item of input.qr_values) {
      let qr = {
        user_id: input.user_id,
        qr_id: uuidv4(),
        name: item.name,
        content: item.content,
      };
      qrValues.push(qr);
    }
    const newValues = {
      qr_values: qrValues,
      updated_at: Date.now(),
    };
    const dbResponse = await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
    if (dbResponse) {
      result.status = 200;
      result.message = "User QR values updated";
      result.qr_values = qrValues;
    } else {
      result.status = 500;
    }
  } catch (error) {
    logger.info(error);
  }
  return result;
}

async function checkQrExist(userId, qrId) {
  logger.info("Starts checkQrExist: userID: " + userId + " qrId: " + qrId);
  // try {
  //   const db = DB_INSTANCES.DB_API;
  //   const filter = { id: userId , qr_values};
  //   const dbResult = await dbHandler.findWithFiltersAndClient(
  //     db.client,
  //     filter,
  //     db.collections.qr
  //   );
  //   if (dbResult && dbResult.length > 0) {
  //     return true;
  //   }
  // } catch (error) {
  //   logger.info(error);
  // }
  return false;
}

async function getUserInfoByUserIdQrId(userId, qrId) {
  logger.info(
    "Starts getUserInfoByUserIdQrId. user_id: " + userId + " qr_id: " + qrId
  );
  let result = {};
  try {
    const db = DB_INSTANCES.DB_API;
    const filter = { id: userId, qr_values: { $elemMatch: { qr_id: qrId } } };
    let dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.user_collection
    );

    if (dbResponse) {
      for (let item of dbResponse[0].qr_values) {
        if (item.qr_id === qrId) {
          result.contact_info = item.content;
          break;
        }
      }
    }
  } catch (error) {
    logger.info(error);
  }

  return result;
}

async function updateUserBiographyByUserId(input) {
  logger.info("Starts updateUserBiographyByUserId");
  let result = { status: 200, message: "Biography updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      biography: input.biography,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating biography",
    };
  }
  return result;
}

async function updateUserHobbiesByUserId(input) {
  logger.info("Starts updateUserHobbiesByUserId");
  let result = { status: 200, message: "Hobbies updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      hobbies: input.hobbies,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating hobbies",
    };
  }
  return result;
}

async function updateUserNameByUserId(input) {
  logger.info("Starts updateUserNameByUserId:" + JSON.stringify(input));
  let result = { status: 200, message: "User name updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      name: input.user_name,
      updated_at: Date.now(),
    };
    logger.info(`filters: ${JSON.stringify(filters)}`);
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user name",
    };
  }
  return result;
}

async function updateUserRadioVisibility(input) {
  logger.info("Starts updateUserRadioVisibility:" + JSON.stringify(input));
  let result = { status: 200, message: "User visibility updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      radio_visibility: input.radio_visibility,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user visibility",
    };
  }
  return result;
}

async function updateUserGenderByUserId(input) {
  logger.info("Starts updateUserGenderByUserId: " + JSON.stringify(input));
  let result = { status: 200, message: "User gender updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      gender: input.gender,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user gender",
    };
  }
  return result;
}

async function updateUserImageProfileByUserId(input) {
  logger.info("Starts updateUserImageProfileByUserId");
  let result = { status: 200, message: "User image profile updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const newValues = {
      profile_image_id: input.image_id,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user image id",
    };
  }
  return result;
}

async function updateUserDefaultQrByUserId(input) {
  logger.info("Starts updateUserDefaultQrByUserId:" + JSON.stringify(input));
  let result = { status: 200, message: "Use default qr id updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    let found = false;
    let values = await getUserQrByUserId(input);
    if (values) {
      for (let item of values.items) {
        logger.info(item.qr_id);
        if (item.qr_id === input.qr_id) {
          found = true;
          break;
        }
      }
    }
    if (!found) {
      return { status: 500, message: "Qr not valid" };
    }
    const filters = { id: input.user_id };
    const newValues = {
      default_qr_id: input.qr_id,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues,
      filters,
      db.collections.user_collection
    );
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user default qr id",
    };
  }
  return result;
}

async function updateUserScansByUserIdContactId(userId, contactId) {
  logger.info("Starts updateUserScansPerformedByUserId");
  let result = { status: 200, message: "User scans performed updated" };
  try {
    const db = DB_INSTANCES.DB_API;
    const userScanner = await dbHandler.findWithFiltersAndClient(
      db.client,
      { id: userId },
      db.collections.user_collection
    );
    const userScanned = await dbHandler.findWithFiltersAndClient(
      db.client,
      { id: contactId },
      db.collections.user_collection
    );
    let scansPerformed = 1;
    if (userScanner[0].scans_performed) {
      scansPerformed = userScanner[0].scans_performed + 1;
    }

    let scanned = 1;
    if (userScanned[0].scanned_count) {
      scanned = userScanned[0].scanned_count + 1;
    }

    const newValues1 = {
      scans_performed: scansPerformed,
      updated_at: Date.now(),
    };

    const newValues2 = {
      scanned_count: scanned,
      updated_at: Date.now(),
    };

    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues1,
      { id: userId },
      db.collections.user_collection
    );
    await dbHandler.updateDocumentWithClient(
      db.client,
      newValues2,
      { id: contactId },
      db.collections.user_collection
    );
    result.scanned = scanned;
    result.scans_performed = scansPerformed;
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user name",
    };
  }
  return result;
}

async function getUserPublicProfileByUserId(input) {
  let result = {};
  try {
    logger.info("Starts getUserPublicProfileByUserId:" + JSON.stringify(input));
    const db = DB_INSTANCES.DB_API;
    const filter = { id: input.user_id };
    const dbResponse = await dbHandler.findWithFiltersAndClient(
      db.client,
      filter,
      db.collections.user_collection
    );
    if (dbResponse) {
      const userDB = dbResponse[0];
      result = await createPublicProfileUser(userDB);
      result.status = 200;
    }

    return result;
  } catch (error) {
    logger.info(error);
  }

  return { status: 500 };
}

async function updateSubscriptionByUserId(input) {
  logger.info("Starts updateSubscriptionByUserId");  
  try {
    const db = DB_INSTANCES.DB_API;
    const filters = { id: input.user_id };
    const bUserExist = await checkUserExist(input.user_id);

    if (bUserExist) {
      const now = Date.now(); 
      input.subscription.created_at = now; 
      const newValues = {
        subscription: input.subscription,
        updated_at: now
      };
      await dbHandler.updateDocumentWithClient(
        db.client,
        newValues,
        filters,
        db.collections.user_collection
      );
      return { ...HOST_ERROR_CODES.NO_ERROR };
    } else {
      return {
        ...HOST_ERROR_CODES.USER_NOT_EXIST,
      };
    }
  } catch (error) {
    logger.info(error);
  }
  return { ...HOST_ERROR_CODES.SUBSCRIPTION_UPDATE_ERROR };
}

module.exports = {
  registerUser,
  updateUserNetworksByUserId,
  updateUserSearchingRangeByUserId,
  updateUserInterestsByUserId,
  updateUserQrsByUserId,
  getUserInfoByUserIdQrId,
  updateUserBiographyByUserId,
  updateUserHobbiesByUserId,
  updateUserNameByUserId,
  updateUserImageProfileByUserId,
  updateUserScansByUserIdContactId,
  updateUserDefaultQrByUserId,
  updateUserRadioVisibility,
  updateUserGenderByUserId,
  getUserPublicProfileByUserId,
  getUserInfoByUserId,
  checkUserExist,
  checkQrExist,
  updateSubscriptionByUserId,
};
