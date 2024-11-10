
const { MongoClient } = require('mongodb');
const logger = require("../logger/log");
const database = process.env.DATABASE_NAME;

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
        // Cerrar la conexión al cliente
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
    }

    return result;
}


async function updateDocument(newDocument, filter, path) {
    await client.connect();
    const db = client.db(database);
    const collection = db.collection(path);
    const update = { $set: newDocument }
    const result = await collection.updateOne(filter, update);
    console.log(`Document updated with id= ${result.modifiedCount}`);
    return result;
}

async function deleteDocument(document, filter, path) {
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        result = await collection.deleteOne(filter);
        console.log(`Document deleted with id= ${result.deletedCount}`);
    } catch (error) {
        logger.info("error found searching: " + error)
    } finally {
        client.close();
    }


    return result;
}

async function findWithFilters(filters, path) {
    logger.info("Starts findWithFilters")
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        result = await collection.findOne(filters);
        logger.info("result: " + result);
    } catch (error) {
        logger.info(error);
    } finally {
        client.close();
    }

    return result;
}




module.exports = {
    connectToDatabase,
    addDocument,
    updateDocument,
    deleteDocument,
    findWithFilters
}