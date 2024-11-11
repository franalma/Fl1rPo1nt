const logger = require("../../logger/log");
const dbHandler = require("../../database/database_handler");
const collection = "social_networks";

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
        social_network_id: item.social_network_id,
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
        
        const dbResponse = await dbHandler.addDocument(item, collection);
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
    const dbResponse = await dbHandler.findWithFilters([], collection);

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



module.exports = {
    putAllSocialNetworks,
    getAllSocialNetworks
}