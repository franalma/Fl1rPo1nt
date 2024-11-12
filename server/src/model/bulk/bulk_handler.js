const dbHandler = require("../../database/database_handler");
const user_coordinates_collection = "user_coordinates";
const sex_orientations_collection = "sex_orientations";
const type_relationships_collection = "type_relationships";

async function addBulkCoordinates(input) {
    try {
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
            await dbHandler.addDocument(value, user_coordinates_collection);
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
        await dbHandler.addManyDocuments(docs, sex_orientations_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;

}

async function addTypeRelationships(input) {
    try {
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
        await dbHandler.addManyDocuments(docs, type_relationships_collection);
        return 0;
    } catch (error) {
        console.log(error);
    }
    return -1;

}

module.exports = {
    addBulkCoordinates,
    addSexOrientation,
    addTypeRelationships
}