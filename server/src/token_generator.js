require("dotenv").config();
const jwt = require('jsonwebtoken');

function generateToken(user, tokenLife = process.env.TOKEN_LIFE) {
  console.log("Token life: "+tokenLife);
  const payload = {
      id: user.id,
      email: user.email
  };

  const secretKey = process.env.SECRET_TOKEN;
  // const tokenLife = process.env.TOKEN_LIFE;

  const options = {
      expiresIn: tokenLife
  };

  return jwt.sign(payload, secretKey, options);
}

const token = generateToken("test@floiint.com");
console.log(token);