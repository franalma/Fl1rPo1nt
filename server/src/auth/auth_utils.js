
const bcrypt = require("bcryptjs");
const logger = require("../logger/log");

async function hashPassword(plainPassword) {
    logger.info("Starts hashPassword");
    try {
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(plainPassword, salt);
      return hashedPassword;
    } catch (error) {
      console.error("Error al hashear la contraseña:", error);
    }
    return null;
  }
  
  async function verifyPassword(plainPassword, hashedPassword) {
    logger.info("Starts verifyPassword");
    try {
      const isMatch = await bcrypt.compare(plainPassword, hashedPassword);
      return isMatch;
    } catch (error) {
      console.error("Error al verificar la contraseña:", error);
    }
    return false;
  }


  module.exports ={
    hashPassword,
    verifyPassword

  }