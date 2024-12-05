const dbHandler = require("../../database/database_handler");
const {DB_INSTANCES} = require("../../database/databases");
const logger = require("../../logger/log");

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
        await dbHandler.addManyDocumentsWithClient(dbInfo.client,docs, dbInfo.collections.sex_orientations_collection);
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

async function addHobbies(input){
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
        await dbHandler.addManyDocumentsWithClient(dbInfo.client,docs, dbInfo.collections.hobbies_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;
}

async function addGenderIdentity(input){
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


module.exports = {
    addBulkCoordinates,
    addSexOrientation,
    addTypeRelationships,
    addBaseNetworks, 
    addHobbies,
    addGenderIdentity
}