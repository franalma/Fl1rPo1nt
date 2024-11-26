const { v4: uuidv4 } = require('uuid');
const dbHandler = require('../../database/database_handler');
const logger = require("../../logger/log");

const FLIRT_ACTIVE = 1;
const FLIRT_INACTIVE = 0;
const flirtsCollection = "user_flirts";
const userColletion = "users";

async function putUserFlirts(input) {
    logger.info("Starts putUserFlirts");
    let checkExist = await dbHandler.findWithFilters({ id: input.user_id }, userColletion);
    let result = {};
    if (!checkExist) {
        result.status = 500;
        result.message = "User does not exists";

    } else {
        const currentTime = Date.now();

        //check if there is any active flirt for user_id
        checkExist = await dbHandler.findWithFilters({ user_id: input.user_id, status: FLIRT_ACTIVE }, flirtsCollection);
        if (checkExist.length == 0) {
            let flirt = {
                flirt_id: uuidv4(),
                user_id: input.user_id,
                relationship_id: input.relationship_id,
                relationship_name: input.relationship_name,
                sex_alternative_id: input.orientation_id,
                sex_alternative_name: input.orientation_name,
                location: {
                    type: "Point",
                    coordinates: [input.location.longitude, input.location.latitude]

                },

                status: FLIRT_ACTIVE,
                created_at: currentTime,
                updated_at: currentTime,
            };

            let dbResponse = await dbHandler.addDocument(flirt, flirtsCollection);
            if (dbResponse) {
                result = {
                    status: 200,
                    message: "Flirt registered successfully",
                    response: {
                        flirt_id: flirt.flirt_id,
                        created_at: flirt.created_at,
                        status: FLIRT_ACTIVE,
                        location: input.location,
                    }
                };
            }
        } else {
            result = {
                status: 501,
                message: "There is another flirt active"
            };
        }
    }
    return result;
}

async function udpateUserFlirts(input) {
    logger.info("Starts udpateUserFlirts");
    let checkExist = await dbHandler.findWithFilters({ id: input.user_id }, userColletion);
    let result = {};
    if (!checkExist) {
        result.status = 500;
        result.message = "User does not exists";

    } else {
        const currentTime = Date.now();
        let filters = {
            user_id: input.user_id,
            flirt_id: input.flirt_id
        };

        let newDoc = {
            updated_at: Date.now()
        };
        if (input.values.location) {
            newDoc.location = input.values.location;
        }
        if (input.values.status != null) {
            newDoc.status = input.values.status;
        }


        //check if there is any active flirt for user_id
        const dbResponse = await dbHandler.updateDocument(newDoc, filters, flirtsCollection);
        if (dbResponse) {
            result = {
                status: 200,
                message: "Flirt updated successfully",
                response: {
                    flirt_id: newDoc.flirt_id,
                    updated_at: newDoc.updated_at
                }
            };
        } else {
            result = {
                status: 501,
                message: "Flirt update failed"
            };
        }
    }
    return result;
}

async function getUserFlirts(input) {
    logger.info("Starts getUserFlirts");
    let filters = {};
    filters.user_id = input.filters.user_id;

    if (input.filters.status != null) {
        filters.status = input.filters.status;
    }

    let dbResponse = await dbHandler.findWithFilters(filters, flirtsCollection);
    let result = {};
    result.flirts = [];

    if (dbResponse) {
        result.status = 200;

        for (var item of dbResponse) {
            let flirt = {
                user_id: item.user_id,
                flirt_id: item.flirt_id,
                created_at: item.created_at,
                updated_at: item.updated_at,
                status: item.status,
                location: {
                    latitude: item.location.coordinates[1],
                    longitude: item.location.coordinates[0],
                },
                relationship_name: item.relationship_name,
                orientation_name: item.orientation_name
            }
            result.flirts.push(flirt);
        }
    }
    return result;
}



async function getActiveFlirtsFromPointAndTendency(input) {
    logger.info("Starts getActiveFlirtsFromPointAndTendency");
    let filters = {
        flirt_id: { $ne: input.flirt_id },
        location: {
            $near: {
                $geometry: {
                    type: "Point",
                    coordinates: [input.longitude, input.latitude],
                },
                $maxDistance: input.radio,
            },
        },
        status: 1,
        sex_alternative_id: input.sex_alternative_id
    };


    let dbResponse = await dbHandler.findWithFilters(filters, flirtsCollection);
    let result = {};
    result.flirts = [];

    if (dbResponse) {
        result.status = 200;

        for (var item of dbResponse) {
            let flirt = {
                user_id: item.user_id,
                flirt_id: item.flirt_id,
                location: item.location,
                relationship_name: item.relationship_name,
                orientation_name: item.orientation_name
            }
            result.flirts.push(flirt);
        }
    }
    return result;
}





module.exports = {
    putUserFlirts,
    udpateUserFlirts,
    getUserFlirts, getActiveFlirtsFromPointAndTendency
}