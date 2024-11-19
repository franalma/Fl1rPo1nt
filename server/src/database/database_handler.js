
const { MongoClient } = require('mongodb');
const logger = require("../logger/log");
const database = process.env.DATABASE_NAME;
const json = require("../utils/json_utils");

const uri = 'mongodb://' +
    process.env.DATABASE_USER + ":" +
    process.env.DATABASE_PASS + "@" +
    process.env.DABATASE_SERVER + ":" +
    process.env.DATABASE_PORT + "/" +
    process.env.DATABASE_NAME


const client = new MongoClient(uri, { useNewUrlParser: true, useUnifiedTopology: true });

async function connectToDatabase() {
    logger.info("starts connection:" + uri);

    try {
        await client.connect();
        const db = client.db(database);
        return client;

    } catch (error) {
        console.error('Error loading document:', error);
    } finally {        
        await client.close();
    }
    return null;
}

async function addDocument(document, path) {
    logger.info("Starts addDocument: " + JSON.stringify(document));
    let result = {};
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        result = await collection.insertOne(document);
        console.log(`Document added with id= ${result.insertedId}`);
    } catch (error) {
        logger.info(error);
        return null; 
    }
    finally{
        await client.close(); 
    }

    return result;
}

async function addManyDocuments(document, path) {
    logger.info("Starts addDocument: " + JSON.stringify(document));
    let result = {};
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        result = await collection.insertMany(document);
        console.log(`Document added with id= ${result.insertedId}`);
    } catch (error) {
        logger.info(error);
    }
    finally{
        await client.close(); 
    }

    return result;
}


async function updateDocument(newDocument, filter, path) {
    let result = {};
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        const update = { $set: newDocument }
        // logger.info("--> update info: "+ JSON.stringify(update));
        // logger.info("--> filter info: "+ JSON.stringify(filter));
        result = await collection.updateOne(filter, update);
        console.log(`Num. documents updated= ${result.modifiedCount}`);

        if (result.modifiedCount == 0) {
            logger.info("no documents updated");
            result = null;
        }
    } catch (error) {
        logger.info("error found updating: " + error);
    } finally {
        await client.close();
    }


    return result;
}

async function deleteDocument(filter, path) {
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        result = await collection.deleteOne(filter);
        console.log(`Document deleted with id= ${result.deletedCount}`);
        json.printJson(result);
    } catch (error) {
        logger.info("error found searching: " + error)
    } finally {
        await client.close();
    }


    return result;
}

async function findWithFilters(filters, path) {
    logger.info("Starts findWithFilters: "+ JSON.stringify(filters));
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        const cursor = await collection.find(filters);
        result = await cursor.toArray();
        json.printJson(result);
    } catch (error) {
        logger.info(error);
    } finally {
        await client.close();
    }

    return result;
}

async function findAll(path) {
    logger.info("Starts findAll")
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        logger.info("No filters detected");
        const cursor = await collection.find();
        result = await cursor.toArray();

    } catch (error) {
        logger.info(error);
    } finally {
        await client.close();
    }

    return result;
}




module.exports = {
    connectToDatabase,
    addDocument,
    updateDocument,
    deleteDocument,
    findWithFilters,
    addManyDocuments,
    findAll
}