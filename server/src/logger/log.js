const winston = require('winston');

 // Configurar el logger
const logger = winston.createLogger({
    level: 'info', // Nivel mínimo de logging
    format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.printf(({ timestamp, level, message }) => {
            // const stack = new Error().stack;
            // const stackLines = stack.split('\n');
            // console.log(stack);
            // const functionName = stackLines[6] ? stackLines[6].trim() : 'Desconocido';
            return `${timestamp} [${level.toUpperCase()}]:${message}`;
            
        }), 
        
    ),
    transports: [
        new winston.transports.Console(), // Imprimir en la consola
        new winston.transports.File({ filename: 'app.log' }) // Guardar en un archivo
    ]
});


function info(value) {
   logger.info(value);
}


module.exports = {
    info
}
