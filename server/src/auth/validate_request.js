const tokenHandler = require("./token_generator");
const logger = require("../logger/log");



function requestValidation(req, res, next) {
    logger.info("Init");
    const authHeader = req.headers['authorization'];

    logger.info(JSON.stringify(req.headers));
    const token = authHeader && authHeader.split(' ')[1];

    if (!token) {
        return res.status(401).json({ message: 'auth token not found' });
    }

    const isTokenValid = tokenHandler.verifyToken(token);

    if (isTokenValid) {
        next();
    } else {
        es.status(403).json({ message: 'No valid token or expired' });
    }



}

module.exports = {
    requestValidation
}