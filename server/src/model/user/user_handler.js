const logger = require("../../logger/log");
const { v4: uuidv4 } = require("uuid");
const dbHandler = require("../../database/database_handler");
const bcrypt = require("bcrypt");
const tokenHandler = require("../../auth/token_generator");
const { printJson } = require("../../utils/json_utils");
const { getUserQrByUserId } = require("../qr/qr_handler");

const userColletion = "users";
const locationCollection = "user_coordinates";

async function hashPassword(plainPassword) {
  try {
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(plainPassword, salt);
    return hashedPassword;
  } catch (error) {
    console.error("Error al hashear la contraseña:", error);
  }
  return null;
}

async function verifyPassword(plainPassword, hashedPassword) {
  try {
    const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
    return isMatch;
  } catch (error) {
    console.error("Error al verificar la contraseña:", error);
  }
  return false;
}

async function creatInternalUser(input) {
  const currentTime = Date.now();
  let user = {
    id: uuidv4(),
    name: input.name,
    email: input.email,
    phone: input.phone,
    zip_code: input.zip_code,
    created_at: currentTime,
    updated_at: currentTime,
    scanned_count: 0,
    scans_performed: 0,
  };
  user.password = await hashPassword(input.password);
  user.surname = input.surname ? input.surname : "";
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

async function registerUser(input) {
  logger.info("Start registerUser");
  let checkExist = await dbHandler.findWithFilters(
    { email: input.email },
    userColletion
  );
  let result = {};
  if (checkExist.length > 0) {
    result.status = 500;
    result.message = "User already exists";
  } else {
    let user = await creatInternalUser(input);
    let dbResponse = await dbHandler.addDocument(user, userColletion);
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
  }
  return result;
}

async function doLogin(input) {
  logger.info("Start doLogin: " + JSON.stringify(input));
  const hashPass = await hashPassword(input.password);

  logger.info("pass: " + hashPass);
  let result = {};
  const filters = {
    email: input.email,
  };

  let users = await dbHandler.findWithFilters(filters, userColletion);
  logger.info("users: " + JSON.stringify(users));
  if (users && users.length == 1 && users[0].id) {
    const user = users[0];
    const passCheck = await verifyPassword(input.password, user.password);
    logger.info("check pass: " + passCheck);

    if (passCheck) {
      const currentToken = await tokenHandler.generateToken({
        id: user.id,
        email: user.email,
      });
      const currentRefreshToken = await tokenHandler.generateRefreshToken({
        id: user.id,
        email: user.email,
      });
      result = {
        status: 200,
        message: "Login ok",
        response: {
          user_id: user.id,
          name: user.name,
          surname: user.surname,
          email: user.email,
          token: currentToken,
          refresh_token: currentRefreshToken,
          networks: user.networks ? user.networks : [],
          user_interests: user.user_interests
            ? user.user_interests
            : { relationship: {}, sex_alternative: {} },
          qr_values: user.qr_values ? user.qr_values : [],
          biography: user.biography,
          hobbies: user.hobbies,
          profile_image_file_id: user.profile_image_id,
          scanned_count: user.scanned_count ? user.scanned_count : 0,
          scans_performed: user.scans_performed ? user.scans_performed : 0,
          default_qr_id: user.default_qr_id ? user.default_qr_id : ""
        },
      };
    } else {
      result = {
        status: 500,
        message: "Wrong user or password",
      };
    }
  } else {
    result = {
      status: 500,
      message: "Wrong user or password",
    };
  }
  return result;
}

async function getUsersByDistanceFromPoint(input) {
  logger.info("Starts getUsersByDistanceFromPoint: ");
  // const distanceInRadians = input.radio / 6378.1; // 6378.1 es el radio de la Tierra en km
  let result = {};
  const filters = {
    location: {
      $near: {
        $geometry: {
          type: "Point",
          coordinates: [input.longitude, input.latitude],
        },
        $maxDistance: input.radio,
      },
    },
  };

  logger.info("---> filters: " + JSON.stringify(filters));

  const dbResponse = await dbHandler.findWithFilters(
    filters,
    locationCollection
  );
  if (dbResponse) {
    result.status = 200;
    result.flirts = [];
    logger.info("items: " + JSON.stringify(dbResponse));
    for (let item of dbResponse) {
      result.flirts.push(createUserLocationExternal(item));
    }
  } else {
    result.status = 500;
  }
  return result;
}

async function updateUserNetworksByUserId(input) {
  logger.info("Start update");

  let result = {};
  const filters = { id: input.user_id };
  const newValues = { networks: input.values.networks, updated_at: Date.now() };
  logger.info("--> new values: " + JSON.stringify(newValues));
  const dbResponse = await dbHandler.updateDocument(
    newValues,
    filters,
    userColletion
  );
  logger.info("-> db result: " + dbResponse);
  if (dbResponse) {
    result.status = 200;
    result.message = "Networks updated";
    result.networks = input.values.networks;
  } else {
    result.status = 500;
  }
  return result;
}

async function updateUserSearchingRangeByUserId(input) {
  logger.info("Starts updateUserSearchingRangeByUserId");
  let result = {};
  const filters = { id: input.user_id };
  const newValues = {
    exploring_max_radio: input.distance,
    updated_at: Date.now(),
  };
  const dbResponse = await dbHandler.updateDocument(
    newValues,
    filters,
    userColletion
  );
  logger.info("-> db result: " + dbResponse);
  if (dbResponse) {
    result.status = 200;
    result.message = "Exploring radio updated";
    result.distance = input.distance;
  } else {
    result.status = 500;
  }
  return result;
}

async function updateUserInterestsByUserId(input) {
  logger.info("Starts updateUserInterestsByUserId");
  let result = {};
  const filters = { id: input.user_id };
  const newValues = {
    user_interests: input.values.user_interests,
    updated_at: Date.now(),
  };
  const dbResponse = await dbHandler.updateDocument(
    newValues,
    filters,
    userColletion
  );
  logger.info("-> db result: " + dbResponse);
  if (dbResponse) {
    result.status = 200;
    result.message = "User interests updated";
  } else {
    result.status = 500;
  }
  return result;
}

async function updateUserQrsByUserId(input) {
  logger.info("Starts updateUserInterestsByUserId");
  let result = {};
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
  const dbResponse = await dbHandler.updateDocument(
    newValues,
    filters,
    userColletion
  );
  logger.info("-> db result: " + dbResponse);
  if (dbResponse) {
    result.status = 200;
    result.message = "User QR values updated";
    result.qr_values = qrValues;
  } else {
    result.status = 500;
  }
  return result;
}

async function getUserInfoByUserIdQrId(userId, qrId) {
  logger.info("Starts getUserInfoByUserIdQrId. user_id: " + userId + " qr_id: " + qrId);
  const filter = { id: userId, qr_values: { $elemMatch: { qr_id: qrId } } };
  let dbResponse = await dbHandler.findWithFilters(filter, userColletion);  
  let result = {};
  if (dbResponse) {
    logger.info("checking...");
    for (let item of dbResponse[0].qr_values) {
      if (item.qr_id === qrId) {
        result.contact_info = item.content;
        break;
      }
    }
  }
  return result;
}

async function updateUserBiographyByUserId(input) {
  logger.info("Starts updateUserBiographyByUserId");
  let result = { status: 200, message: "Biography updated" };
  try {
    const filters = { id: input.user_id };

    const newValues = {
      biography: input.biography,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocument(newValues, filters, userColletion);
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
    const filters = { id: input.user_id };

    const newValues = {
      hobbies: input.hobbies,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocument(newValues, filters, userColletion);
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
  logger.info("Starts updateUserNameByUserId");
  let result = { status: 200, message: "Use name updated" };
  try {
    const filters = { id: input.user_id };

    const newValues = {
      name: input.user_name,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocument(newValues, filters, userColletion);
  } catch (error) {
    logger.info(error);
    result = {
      status: 500,
      message: "Error updating user name",
    };
  }
  return result;
}

async function updateUserImageProfileByUserId(input) {
  logger.info("Starts updateUserImageProfileByUserId");
  let result = { status: 200, message: "User image profile updated" };
  try {
    const filters = { id: input.user_id };

    const newValues = {
      profile_image_id: input.image_id,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocument(newValues, filters, userColletion);
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
      return { status: 500, message: "Qr not valid" }
    }
    const filters = { id: input.user_id };
    const newValues = {
      default_qr_id: input.qr_id,
      updated_at: Date.now(),
    };
    await dbHandler.updateDocument(newValues, filters, userColletion);
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
    const userScanner = await dbHandler.findWithFilters(
      { id: userId },
      userColletion
    );
    const userScanned = await dbHandler.findWithFilters(
      { id: contactId },
      userColletion
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


    await dbHandler.updateDocument(newValues1, { id: userId }, userColletion);
    await dbHandler.updateDocument(
      newValues2,
      { id: contactId },
      userColletion
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

module.exports = {
  registerUser,
  doLogin,
  getUsersByDistanceFromPoint,
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
  updateUserDefaultQrByUserId
};
