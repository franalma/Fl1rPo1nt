const logger = require("../../logger/log");
const dbHandler = require("../../database/database_handler");
const socialNetworksCollection = "social_networks";
const typeRelationshipsCollection = "type_relationships";
const sexOrientationCollection = "sex_orientations";

function createSocialNetWork(item) {
    logger.info("Starts createSocialNetWork: "+JSON.stringify(item));
    result = {
        social_network_id: item.id,
        name: item.name,
        created_at: Date.now()
    }
    return result;
}

function createSocialNetworkExternal(item) {
    
    result = {
        social_network_id: item.id,
        name: item.name
    }
    return result;
}


async function putAllSocialNetworks(input) {
    logger.info("Starts putAllSocialNetworks: "+JSON.stringify(input.networks));
    let result = {};
    
    for (let network of input.networks) {
        logger.info("network info: "+JSON.stringify(network));
        let item = createSocialNetWork(network);
        
        const dbResponse = await dbHandler.addDocument(item, socialNetworksCollection);
        if (dbResponse) {
            result = {
                status: 200,
                message: "Social networks created successfully",
            };
        }
    }
    return result;
}

async function getAllSocialNetworks() {
    logger.info("Starts getAllSocialNetworks");
    let result = {};
    const dbResponse = await dbHandler.findAll(socialNetworksCollection);

    if (dbResponse) {
        result.status = 200;
        result.networks = [];
        for (let network of dbResponse) {
            let item = createSocialNetworkExternal(network);
            result.networks.push(item);
        }
    }


    return result;
}

async function getAllSexualOrientationsRelationships(){
    logger.info("Starts getAllSexualOrientationsRelationships");

    let result = {};
    result.sex_orientation = [];
    result.type_relationships = [];
    let dbResponse = await dbHandler.findAll(sexOrientationCollection);

    if (dbResponse) {                
        for (let item of dbResponse) {            
            let value = {
                id:item.id, 
                name: item.name, 
                color: item.color, 
                description: item.description
            };
            result.sex_orientation.push(value);
        }
        let dbResponse2 = await dbHandler.findAll(typeRelationshipsCollection);
        for (let item of dbResponse2) {            
            let value = {
                id:item.id, 
                name: item.name, 
                color: item.color, 
                description: item.description
            };
            result.type_relationships.push(value);
        }
      result.status = 200; 
    }

    return result; 

}



module.exports = {
    putAllSocialNetworks,
    getAllSocialNetworks,
    getAllSexualOrientationsRelationships,
    
}