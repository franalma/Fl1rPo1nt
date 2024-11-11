const { stringify, parse } = require('flatted');

function printJson(obj) {

    // Usar `flatted` para convertir a JSON y manejar estructuras circulares
    const json = stringify(obj);
    console.log(json);

    // Convertir de nuevo de JSON a objeto
    const parsedObj = parse(json);
    console.log(parsedObj);
}

module.exports = {
    printJson
}

