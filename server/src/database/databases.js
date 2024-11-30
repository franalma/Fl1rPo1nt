// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "FloiintAuth" } ]});
// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "FloiintApi" } ]});


const { MongoClient } = require('mongodb');

const dbAuthUri = 'mongodb://' +
    process.env.DATABASE_AUTH_USER + ":" +
    process.env.DATABASE_AUTH_PASS + "@" +
    process.env.DATABASE_AUTH_SERVER + ":" +
    process.env.DATABASE_AUTH_PORT + "/" +
    process.env.DATABASE_AUTH_NAME;

const dbApiUri = 'mongodb://' +
    process.env.DATABASE_API_USER + ":" +
    process.env.DATABASE_API_PASS + "@" +
    process.env.DABATASE_API_SERVER + ":" +
    process.env.DATABASE_API_PORT + "/" +
    process.env.DATABASE_API_NAME;


const DB_INSTANCES = {
    DB_API: {
        database_name: process.env.DATABASE_API_NAME,
        client: new MongoClient(dbApiUri, { useNewUrlParser: true, useUnifiedTopology: true }),
        collections: {
            user_collection: "users"
        }
    },
    DB_AUTH: {
        database_name: process.env.DATABASE_AUTH_NAME,
        client: new MongoClient(dbAuthUri, { useNewUrlParser: true, useUnifiedTopology: true }),
        collections: {
            user_collection: "users"
        }
    }
}

module.exports = {
    DB_INSTANCES
}