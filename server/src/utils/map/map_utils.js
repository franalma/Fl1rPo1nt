const NodeGeocoder = require('node-geocoder');

const options = {
    provider: 'google', // Puedes usar 'google', 'mapquest', etc.
    apiKey: ""
    
};

const geocoder = NodeGeocoder(options);

async function getCoordinates(zipCode) {
    try {
        const res = await geocoder.geocode(zipCode);
        if (res.length === 0) {
            throw new Error('No se encontraron coordenadas para el código postal');
        }
        return { latitude: res[0].latitude, longitude: res[0].longitude };
    } catch (error) {
        console.error('Error al obtener las coordenadas:', error);
    }
}

function calculateDistance(coord1, coord2) {
    const R = 6371; // Radio de la Tierra en kilómetros
    const dLat = (coord2.latitude - coord1.latitude) * (Math.PI / 180);
    const dLon = (coord2.longitude - coord1.longitude) * (Math.PI / 180);

    const a =
        Math.sin(dLat / 2) * Math.sin(dLat / 2) +
        Math.cos(coord1.latitude * (Math.PI / 180)) *
        Math.cos(coord2.latitude * (Math.PI / 180)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c; // Distancia en kilómetros

    return distance;
}

module.exports = {
    calculateDistance,
    getCoordinates
}
