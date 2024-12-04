const { error } = require("winston");

const HOST_ERROR_CODES = {
  TEMPLATE: {
    error_code: -1,
    status: 200,
    description: "Template error",
  },

  NO_ERROR: {
    error_code: 0,
    status: 200,
    description: "Ok",
  },

  USER_NOT_ACTIVATED: {
    error_code: -100,
    status: 200,
    description: "User required activation",
  },
  USER_EXIST: {
    error_code: -101,
    status: 200,
    description: "User exists",
  },
  NOT_POSSIBLE_TO_REGISTER_USER: {
    error_code: -102,
    status: 200,
    description: "Not possible to add user",
  },

  WRONG_USER_PASS: {
    error_code: -103,
    status: 200,
    description: "Wrong user/password",
  },
  USER_NOT_EXIST: {
    error_code: -104,
    status: 200,
    description: "User does not exist",
  },

  USER_BLOCKED: {
    error_code: -105,
    status: 200,
    description: "User blocked",
  },

  USER_ALREADY_IN_YOUR_CONTACTS: {
    error_code: -401,
    status: 200,
    description: "User already in your contatcs",
  },



  
  NOT_AUTHORIZED:{
    error_code: -404,
    status: 403,
    description: "Not authorized",
  },

  INTERNAL_SERVER_ERROR:{
    error_code: -500,
    status: 500,
    description: "Internal server errorr",
  }
};

function genError (value){
    
    const result=  {
        status: value.status, 
        error_code: value.error_code, 
        description: value.description
    }
    console.log(JSON.stringify(result));
    return result; 
}

module.exports = {
    HOST_ERROR_CODES,
    genError
};
