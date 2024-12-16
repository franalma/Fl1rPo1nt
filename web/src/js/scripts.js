const radius = 100;

function getRandomPosition(canvasId) {
    const canvas = document.getElementById(canvasId);
    const x = Math.random() * (canvas.width - 2 * radius) + radius;
    const y = Math.random() * (canvas.height - 2 * radius) + radius;
    return { x, y };
}


function createCircle(canvasId, x, y,color1, color2) {

    const canvas = document.getElementById(canvasId);
    const ctx = canvas.getContext('2d');

    // Define the center and radius of the circle
    const centerX = canvas.width / 2;
    const centerY = canvas.height / 2;
    

    // Create a gradient for the circle
    const gradient = ctx.createLinearGradient(centerX - radius, centerY, centerX + radius, centerY);
    gradient.addColorStop(0, color1);  // Start color
    gradient.addColorStop(1, color2);  // End color

    // Draw the circle with the gradient
    ctx.beginPath();
    ctx.arc(x, y, radius, 0, Math.PI * 2); // Full circle
    ctx.closePath();
    ctx.fillStyle = gradient;
    ctx.fill();

}

// Function to clear the canvas
function clearCanvas(id) {
    const canvas = document.getElementById(id);
    const ctx = canvas.getContext('2d');
    ctx.clearRect(0, 0, canvas.width, canvas.height);
}

function animateCircle(canvasId, color1, color2) {
    clearCanvas(canvasId); // Clear previous circle
    const { x, y } = getRandomPosition(canvasId); // Get new random position
    createCircle(canvasId,x, y, color1, color2); // Draw the circle at the new position
}
