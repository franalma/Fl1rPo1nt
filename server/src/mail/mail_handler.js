const fs = require("fs");
const image =
  "/Users/sierra/Desktop/Projects/Personal/Fl1rPo1nt/server/src/mail/mail_logo.png";

// Function to convert a file to Base64
function fileToBase64(filePath) {
  try {
    // Read the file
    const fileBuffer = fs.readFileSync(filePath);
    // Convert to Base64
    const base64String = fileBuffer.toString("base64");
    return base64String;
  } catch (error) {
    console.error("Error reading or encoding file:", error);
    return null;
  }
}

function genMailBody() {
  const base64 = fileToBase64(image);
  const html = `
    <div> 
        <img src="cid:unique-image-id" alt="loco" />

        <p>Verifca tu cuenta haciendo clic en <a href='#'>este</a> enlace.</p>
        <p>Comienza a ligar cuanto antes!</p>


        <p>Atentamente, el equipo de Floiint</p>
    </div>
    `;
  
  return html;
}

module.exports = {
  genMailBody,
};
