
const { MongoClient } = require('mongodb');
const logger = require("../logger/log");
const database = process.env.DATABASE_NAME;
const json = require("../utils/json_utils");
const { cli } = require('winston/lib/winston/config');
// const { DB_INSTANCES } = require("./databases")

async function connectToDatabase(input) {
    logger.info("Starts connectToDatabase:" + input.database_name);

    try {
        await input.client.connect();
        const db = input.client.db(input.database_name);
        return input.client;

    } catch (error) {
        console.error('Error loading document:', error);
    } finally {
        await input.client.close();
    }
    return null;
}

async function addDocument(document, path) {
    logger.info("Starts addDocument: " + printJson(document));
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
    finally {
        await client.close();
    }
    return result;
}

async function addDocumentWithClient(client,document, path) {
    logger.info("Starts addDocumentWithClient: " + JSON.stringify(document));
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
    finally {
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
    finally {
        await client.close();
    }

    return result;
}

async function addManyDocumentsWithClient(client, document, path) {
    logger.info("Starts addManyDocumentsWithClient: " + JSON.stringify(document));
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
    finally {
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

async function updateDocumentWithClient(client, newDocument, filter, path) {
    let result = {};
    try {
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);
        const update = { $set: newDocument }        
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

async function deleteDocumentWithClient(client, filter, path) {
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

async function deleteCollection(path) {
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        result = await db.collection(path).drop();
        console.log(`Collection deleted with id= ${result}`);
        json.printJson(result);
    } catch (error) {
        logger.info("error found searching: " + error)
    } finally {
        await client.close();
    }
    return result;
}

async function deleteCollectionWithClient(client,path) {
    let result = null;
    try {
        await client.connect();
        const db = client.db(database);
        result = await db.collection(path).drop();
        console.log(`Collection deleted with id= ${result}`);
        json.printJson(result);
    } catch (error) {
        logger.info("error found searching: " + error)
    } finally {
        await client.close();
    }
    return result;
}

async function findWithFilters(client, filters, path) {
    logger.info("Starts findWithFilters");
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

async function findWithFiltersAndClient(client, filters, path) {
    logger.info("Starts findWithFiltersAndClient: " + JSON.stringify(filters));
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

async function findWithFiltersAndClientWitPagination(client, filters, path) {
    logger.info("Starts findWithFiltersAndClient: " + JSON.stringify(filters));
    let result = null;
    try {        
        if (client && client.topology && client.topology.isConnected()) {
            await client.connect(); 
        }
        await client.connect();
        const db = client.db(database);
        const collection = db.collection(path);        
        const cursor = await collection.aggregate(filters);
        const documents = await cursor.toArray();
        result = {               
            documents:documents
        };
        

        
    } catch (error) {
        logger.info(error);
    } finally {
        //  await client.close();
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

async function findAllWithClient(client, path) {
    logger.info("Starts findAllWithClient")
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
    findAll,
    deleteCollection,
    addDocumentWithClient,
    deleteDocumentWithClient,
    updateDocumentWithClient,
    addManyDocumentsWithClient,
    findWithFiltersAndClient,
    findAllWithClient,
    deleteCollectionWithClient,
    findWithFiltersAndClientWitPagination
    // connectToAuthDatabase
}