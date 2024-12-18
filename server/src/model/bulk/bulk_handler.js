const dbHandler = require("../../database/database_handler");
const { DB_INSTANCES } = require("../../database/databases");
const logger = require("../../logger/log");
const authUtils = require("../../auth/auth_utils");
const { v4: uuidv4 } = require("uuid");
const userHandler = require("../../model/user/user_handler");
const { printJson } = require("../../utils/json_utils");

function ageToEpoch(age) {
    const currentDate = new Date();
    const birthYear = currentDate.getFullYear() - age;
    const birthDate = new Date(birthYear, 0, 1);
    const epochTime = Math.floor(birthDate.getTime() / 1000);
    return epochTime;
}


async function createBulkUserAuthInternal(input) {
    logger.info("Starts createUserAuthInternal:" + JSON.stringify(input));
    try {
        const currentTime = Date.now();
        let user = {
            id: uuidv4(),
            email: input.email,
            name: input.name,
            created_at: currentTime,
            updated_at: currentTime,
            activated: 1,
            last_login: 0,
            enabled: 1
        };
        user.password = await authUtils.hashPassword(input.password);
        return user;
    } catch (error) {
        logger.info(error);
    }
    return {};
}

async function addBulkCoordinates(input) {
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let userId = 1;

        for (let item of input.coordinates) {
            let value = {
                user_id: userId,
                name: "User_" + userId,
                location: {
                    type: "Point",
                    coordinates: [item.longitude, item.latitude]
                }
            };
            await dbHandler.addDocumentWithClient(dbInfo.client,
                value, dbInfo.collections.user_coordinates_collection);
            userId++;
        }
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;

}

async function addSexOrientation(input) {
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let docs = [];
        for (let item of input.orientations) {
            let value = {
                id: item.id,
                name: item.name,
                color: item.color,
                descripcion: item.description,
                created_ad: Date.now()
            };
            docs.push(value);
        }
        await dbHandler.addManyDocumentsWithClient(dbInfo.client, docs, dbInfo.collections.sex_orientations_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;

}

async function addTypeRelationships(input) {
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let docs = [];
        for (let item of input.orientations) {
            let value = {
                id: item.id,
                name: item.name,
                color: item.color,
                descripcion: item.description,
                created_ad: Date.now()
            };
            docs.push(value);
        }
        await dbHandler.addManyDocumentsWithClient(dbInfo.client, docs, dbInfo.collections.type_relationships_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;

}

async function addBaseNetworks(input) {
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let docs = [];
        for (let item of input.networks) {
            let value = {
                id: item.id,
                name: item.name,
                created_ad: Date.now()
            };
            docs.push(value);
        }
        await dbHandler.addManyDocumentsWithClient(dbInfo.client, docs, dbInfo.collections.social_networks_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;
}

async function addHobbies(input) {
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let docs = [];
        for (let item of input.hobbies) {
            let value = {
                id: item.id,
                name: item.hobby,
                created_ad: Date.now()
            };
            docs.push(value);
        }
        await dbHandler.addManyDocumentsWithClient(dbInfo.client, docs, dbInfo.collections.hobbies_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;
}

async function addGenderIdentity(input) {
    logger.info("Starts addGenderIdentity");
    try {
        const dbInfo = DB_INSTANCES.DB_API;
        let docs = [];
        for (let item of input.genders) {
            let value = {
                id: item.id,
                name: item.name,
                color: item.color,
                created_ad: Date.now()
            };
            docs.push(value);
        }
        await dbHandler.addManyDocumentsWithClient(dbInfo.client, docs, dbInfo.collections.genders_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;
}

async function bulkUpdateUserGender(input) {
    logger.info("Starts bulkUpdateUserGender: " + JSON.stringify(input.user_id));
    try {
        const db = DB_INSTANCES.DB_API;
        const filters = { id: input.gender_id };
        const gendersDb = await dbHandler.findWithFiltersAndClient(db.client, filters, db.collections.genders_collection);
        const genderDb = gendersDb[0];
        const localGender = {
            id: genderDb.id,
            name: genderDb.name,
            color: genderDb.color
        };

        await dbHandler.updateDocumentWithClient(db.client,
            { gender: localGender },
            { id: input.user_id },
            db.collections.user_collection);

    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateNetWorks(input) {
    logger.info("Starts bulkUpdateNetWorks: " + JSON.stringify(input.user_id));
    try {
        const values = {
            user_id: input.user_id,
            values: {
                networks: input.networks
            }
        }
        await userHandler.updateUserNetworksByUserId(values);
    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateQrValues(input) {
    logger.info("Starts bulkUpdateQrValues: " + JSON.stringify(input.user_id));
    try {
        let qrValues = [];
        for (let item of input.qr_values) {
            const value = {
                user_id: input.user_id,
                name: item.name,
                content: JSON.stringify(item.content)
            }
            qrValues.push(value);
        }
        input.qr_values = qrValues;
        await userHandler.updateUserQrsByUserId(input);


    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateHobbiesValues(input) {
    logger.info("Starts bulkUpdateHobbiesValues: " + JSON.stringify(input.user_id));
    try {
        const db = DB_INSTANCES.DB_API;
        let hobbies = [];
        for (let item of input.hobbies) {
            let dbRes = await dbHandler.findWithFiltersAndClient(db.client, { id: item }, db.collections.hobbies_collection);
            const value = {
                id: dbRes[0].id,
                name: dbRes[0].name
            }
            hobbies.push(value);
        }
        input.hobbies = hobbies;
        await userHandler.updateUserHobbiesByUserId(input);


    } catch (error) {
        logger.info(error);
    }
}

async function bulkUserInterest(input) {
    logger.info("Starts bulkUserInterest: " + JSON.stringify(input.user_id));
    try {
        const db = DB_INSTANCES.DB_API;
        const dbRel = await dbHandler.findWithFiltersAndClient(db.client, { id: input.relationship_id }, db.collections.type_relationships_collection);
        const dbGen = await dbHandler.findWithFiltersAndClient(db.client, { id: input.gender_preference_id }, db.collections.genders_collection);
        const dbSex = await dbHandler.findWithFiltersAndClient(db.client, { id: input.sex_alternative_id }, db.collections.sex_orientations_collection);
        let userInterest = {
            relationship: {
                id: dbRel[0].id,
                name: dbRel[0].name,
                color: dbRel[0].color,
            },
            sex_alternative: {
                id: dbSex[0].id,
                name: dbSex[0].name,
                color: dbSex[0].color,
            },
            gender_preference: {
                id: dbGen[0].id,
                name: dbGen[0].name,
                color: dbGen[0].color,
            },
        };

        input.values = {
            user_interests: userInterest
        }

        await userHandler.updateUserInterestsByUserId(input);


    } catch (error) {
        logger.info(error);
    }
}

async function bulkpdateBiography(input) {
    logger.info("Starts bulkpdateBiography: " + JSON.stringify(input.user_id));
    try {
        await userHandler.updateUserBiographyByUserId(input);
    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateDefaultQr(input) {
    logger.info("Starts bulkUpdateProfileImageId: " + JSON.stringify(input.user_id));
    try {
        const user = await userHandler.getUserInfoByUserId(input);
        input.default_qr = user.qr_values[0].qr_id;

        userHandler.updateUserDefaultQrByUserId(input);
    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateDefaultImageProfile(input) {
    logger.info("Starts bulkUpdateProfileImageId: " + JSON.stringify(input.user_id));
    try {
        await userHandler.updateUserImageProfileByUserId(input);
    } catch (error) {
        logger.info(error);
    }
}

async function bulkUpdateBornDate(input) {
    logger.info("Starts bulkUpdateBornDate: " + JSON.stringify(input.user_id));
    try {
        const db = DB_INSTANCES.DB_API;
        const epochAge = ageToEpoch(input.age);
        await dbHandler.updateDocumentWithClient(db.client, { born_date: epochAge }, { id: input.user_id }, db.collections.user_collection);

    } catch (error) {
        logger.info(error);
    }
}

async function bulkPopulateUsers(input) {
    logger.info("Starts bulkPopulateUsers");
    let result = { status: 200 };
    try {
        const authDatabase = DB_INSTANCES.DB_AUTH;
        let user = await createBulkUserAuthInternal(input);
        logger.info(`internal user: ${JSON.stringify(user)}`);
        let dbResult = await dbHandler.addDocumentWithClient(authDatabase.client, user, authDatabase.collections.user_collection);
        if (dbResult != null) {
            logger.info("registered");
            result.description = "User registered";
            const userProfile = {
                id: user.id,
                created_at: user.created_at,
                email: user.email,
                phone: input.phone,
                name: user.name,
                surname: input.surname,
                zip_code: input.zip_code,
                born_date: input.born_date
            }
            input.user_id = user.id;
            await userHandler.registerUser(userProfile);

            await bulkUpdateUserGender(input);
            await bulkUpdateNetWorks(input);
            await bulkUpdateQrValues(input);
            await bulkUpdateHobbiesValues(input);
            await bulkUserInterest(input);
            await bulkpdateBiography(input);
            await bulkUpdateProfileImageId(input);
            await bulkUpdateDefaultImageProfile(input);
            await bulkUpdateBornDate(input);
            return result;
        }

    } catch (error) {
        logger.info(error);
    }
    return result;

}


module.exports = {
    addBulkCoordinates,
    addSexOrientation,
    addTypeRelationships,
    addBaseNetworks,
    addHobbies,
    addGenderIdentity,
    bulkPopulateUsers
}