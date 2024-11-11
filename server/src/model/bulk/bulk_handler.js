const dbHandler = require("../../database/database_handler");
const colletion = "user_coordinates";

async function addBulkCoordinates(input) {
    try{
        let userId = 1;
        for (let item of input.coordinates) {
            let value = {
                user_id: userId,
                name: "User_" + userId,
                location: {
                    type: "Point",
                    coordinates: [item.latitude, item.longitude]
                }
            };
            await dbHandler.addDocument(value, colletion);
            userId++;
        }
        return 0; 
    }catch(error){
        console.log(error);
    }
    return -1;
    
}

module.exports = {
    addBulkCoordinates
}