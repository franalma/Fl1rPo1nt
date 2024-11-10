require('dotenv').config();

const logger = require("./logger/log")
const tokenizator = require("./auth/token_generator");
const dbHandler = require("./database/database_handler");
const mapUtils = require("./utils/map/map_utils");
const { log } = require('winston');

const token = tokenizator.generateToken({
    id: 2929383,
    email: "fra@g.com"
});

// logger.info("token: " + token);

// let isValid = tokenizator.verifyToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjkyOTM4MywiZW1haWwiOiJmcmFAZy5jb20iLCJpYXQiOjE3MzA5ODk1NDAsImV4cCI6MTczMDk5MzE0MH0.qK5FhzKJVfmqHZeCT0Zc2izNzH-qcn-AwykWzSXxdyk");
// // isValid = tokenizator.verifyToken("eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MjkyOTM4MywiZW1haWwiOiJmcmFAZy5jb20iLCJpYXQiOjE3MzA5ODk1NDAsImV46MTczMDk5MzE0MH0.qK5FhzKJVfmqHZeCT0Zc2izNzH-qcn-AwykWzSXxdyk");
// // console.log("isValid: " + isValid);

// logger.info("isValid: " + isValid);

// dbHandler.addDocument({user:"test"}, "users").then(result => {
//     logger.info(JSON.stringify(result));
// });

async function test(){
    const cord1 = await mapUtils.getCoordinates("28050"); 
    const cord2 = await mapUtils.getCoordinates("28412");
    const distante = mapUtils.calculateDistance(cord1, cord2);
    logger.info(`Distance ${distante}`) 
}

test(); 
