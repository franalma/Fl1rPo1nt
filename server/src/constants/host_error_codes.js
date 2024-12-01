const HOST_ERROR_CODES = {
  TEMPLATE: {
    code: 0,
    status: 200,
    description: "Template error",
  },
  USER_NOT_EXIST: {
    code: -1,
    status: 200,
    description: "User does not exist",
  },
};

function getError (input){
    const value = HOST_ERROR_CODES[input.value];
    return {
        status: value.status, 
        code: value.code, 
        description: value.description
    }
}

module.exports = {
    HOST_ERROR_CODES,
    getError
};
