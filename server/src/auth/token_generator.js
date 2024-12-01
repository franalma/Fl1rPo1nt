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

function generateRefreshToken(user) {
    const payload = {
        id: user.id,
        email: user.email
    };

    const secretKey = process.env.SECRET_REFRESH_TOKEN;
    const tokenLife = process.env.REFRESH_TOKEN_LIFE;

    const options = {
        expiresIn: tokenLife
    };

    return jwt.sign(payload, secretKey, options);
}




function verifyToken(token) {
    console.log("verifyToken: " + token);
    const secretKey = process.env.SECRET_TOKEN;

    let ret = true;

    try {
        // Verificar el token
        const decoded = jwt.verify(token, secretKey);
        console.log('Token válido:', decoded);
    } catch (error) {
        ret = false;
    }
    return ret;

}


module.exports = {
    generateToken,
    verifyToken,
    generateRefreshToken
}