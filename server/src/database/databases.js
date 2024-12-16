// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "FloiintAuth" } ]});
// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "FloiintApi" } ]});
// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "FloiintChat" } ]});
// db.createUser({user:"admin", pwd:"securepassword",roles: [ { role: "readWrite", db: "MultimediaDb" } ]});

const { MongoClient } = require("mongodb");

const dbAuthUri =
  "mongodb://" +
  process.env.DATABASE_AUTH_USER +
  ":" +
  process.env.DATABASE_AUTH_PASS +
  "@" +
  process.env.DATABASE_AUTH_SERVER +
  ":" +
  process.env.DATABASE_AUTH_PORT +
  "/" +
  process.env.DATABASE_AUTH_NAME;

const dbApiUri =
  "mongodb://" +
  process.env.DATABASE_API_USER +
  ":" +
  process.env.DATABASE_API_PASS +
  "@" +
  process.env.DABATASE_API_SERVER +
  ":" +
  process.env.DATABASE_API_PORT +
  "/" +
  process.env.DATABASE_API_NAME;

const dbChatUri =
  "mongodb://" +
  process.env.DATABASE_CHAT_USER +
  ":" +
  process.env.DATABASE_CHAT_PASS +
  "@" +
  process.env.DABATASE_CHAT_SERVER +
  ":" +
  process.env.DATABASE_CHAT_PORT +
  "/" +
  process.env.DATABASE_CHAT_NAME;

const dbMultUri =
  "mongodb://" +
  process.env.DATABASE_MULT_USER +
  ":" +
  process.env.DATABASE_MULT_PASS +
  "@" +
  process.env.DABATASE_MULT_SERVER +
  ":" +
  process.env.DATABASE_MULT_PORT +
  "/" +
  process.env.DATABASE_MULT_NAME;

const DB_INSTANCES = {
  DB_API: {
    database_name: process.env.DATABASE_API_NAME,
    client: new MongoClient(dbApiUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 10, // Use a connection pool
      minPoolSize: 2,  // Keep minimum number of connections
      serverSelectionTimeoutMS: 5000, // Timeout for selecting a server
    }),
    collections: {
      user_collection: "users",
      genders_collection: "genders",
      hobbies_collection: "hobbies",
      user_contact_collection: "user_matchs",
      social_networks_collection: "social_networks",
      user_coordinates_collection: "user_coordinates",
      type_relationships_collection: "types_relationships",
      sex_orientations_collection: "sex_orientations",
      user_audios_collection: "user_audios",
      user_images_collection: "user_images",
      flirts_collection: "flirts",
      user_coordinates_collection: "user_coordinates",
      smart_points_coolection: "smart_points",
    },
  },
  DB_AUTH: {
    database_name: process.env.DATABASE_AUTH_NAME,
    client: new MongoClient(dbAuthUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 10, // Use a connection pool
      minPoolSize: 2,  // Keep minimum number of connections
    }),
    collections: {
      user_collection: "users",
    },
  },
  DB_CHAT: {
    database_name: process.env.DATABASE_CHAT_NAME,
    client: new MongoClient(dbChatUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 10, // Use a connection pool
      minPoolSize: 2,  // Keep minimum number of connections
    }),
    collections: {
      chatroom_collection: "chatrooms",
      pending_message_collection: "pending_messages",
    },
  },
  DB_MULT: {
    database_name: process.env.DATABASE_MULT_NAME,
    client: new MongoClient(dbMultUri, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
      maxPoolSize: 10, // Use a connection pool
      minPoolSize: 2,  // Keep minimum number of connections
    }),
    collections: {
      user_images_collection: "user_images",
      user_audios_collection: "user_audios",
    },
  },
};

module.exports = {
  DB_INSTANCES,
};
