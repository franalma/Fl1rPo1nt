require("dotenv").config();
const logger = require("../logger/log");
const nodemailer = require("nodemailer");
const fs = require("fs");
// const image = "/Users/fran/Desktop/Projects/Personal/Fl1rPo1nt/Fl1rPo1nt/server/src/imgs/floiint_mail_logo.png";
const validationUrl = process.env.REGISTRATION_VALIDATION_URL;
const AWS = require('aws-sdk');
const bucketName = 'flooint-bucket';

const buckets = {
  floiint: {
    name: "flooint-bucket",
    internal: {
      path: "internal"
    }
  }
};

buckets.floiint.internal.logo_mail = buckets.floiint.internal + "/floiint_mail_logo.png";

const s3 = new AWS.S3({
  region: 'eu-west-3', // Your bucket's region
  accessKeyId: '',
  secretAccessKey: ''
});

async function getPresignedUrl(bucketName, key, expiresInSeconds = 3600) {
  const params = {
    Bucket: bucketName,
    Key: key,
    Expires: expiresInSeconds, // URL expiration time in seconds
  };

  try {
    const url = s3.getSignedUrl('getObject', params);
    console.log('Pre-signed URL:', url);
    return url;
  } catch (error) {
    console.error('Error generating pre-signed URL:', error);
    throw error;
  }
};

async function fileToBase64(bucketName, filePath) {

  try {
    logger.info("Starts fileToBase64: " + filePath);
    // Read the file
    const fileBuffer = await s3.getObject({ Bucket: bucketName, Key: filePath }).promise();
    logger.info("afterreading");
    // const fileBuffer = fs.readFileSync(filePath);
    // Convert to Base64
    const base64String = fileBuffer.toString("base64");
    return base64String;
  } catch (error) {
    console.error("Error reading or encoding file:", error);
    return null;
  }
}

async function genMailBody(token, userId) {
  logger.info("Starts genMailBody");
  // const imagePath = "internal/floiint_mail_logo.png"  
  // const base64 = await fileToBase64(imagePath);
  const link = `${validationUrl}/${token}/${userId}`
  logger.info("genMailBody link:" + link);
  const html = `
    <div> 
        <img src="cid:unique-image-id" alt="loco" />

        <p>Verifca tu cuenta haciendo clic en <a href='${link}'>este</a> enlace.</p>
        <p>Comienza a ligar cuanto antes!</p>


        <p>Atentamente, el equipo de Floiint</p>
    </div>
    `;

  return html;
}



async function genHtmlAccountVerified() {
  logger.info("Starts genHtmlAccountVerified");
  const base64 = fileToBase64(buckets.floiint.name, buckets.floiint.internal.logo_mail);
  const image64 = `data:image/png;base64,${base64}`;

  return `
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Floiint</title>
          <style>
          
            .logo {
              width: 100px;
              height: auto;
              margin-bottom: 20px;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 0;
              display: flex;
              justify-content: center;
              align-items: center;
              height: 100vh;
              background-color: #f4f4f9;
            }
            .container {
              text-align: center;
              background: #fff;
              padding: 20px 30px;
              border-radius: 8px;
              box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            h1 {
              color: #4CAF50;
              margin-bottom: 20px;
            }
            p {
              color: #555;
            }
            a {
              text-decoration: none;
              color: #fff;
              background: #4CAF50;
              padding: 10px 20px;
              border-radius: 5px;
              font-weight: bold;
              margin-top: 15px;
              display: inline-block;
            }
            a:hover {
              background: #45a049;
            }
          </style>
        </head>
        <body>
          <div class="container">
          <img src="${image64}" alt="Logo" class="logo">
            <h1>¡Se ha verificado tu cuenta!</h1>
            <p>Ahora ya puedes disfrutar de Floiint.</p>            
          </div>
        </body>
      </html>
    `;
}



async function gentAccountNotVerified() {
  logger.info("Starts gentAccountNotVerified");  
  const base64 = fileToBase64(buckets.floiint.name, buckets.floiint.internal.logo_mail);
  const image64 = `data:image/png;base64,${base64}`;

  return `
      <!DOCTYPE html>
      <html lang="en">
        <head>
          <meta charset="UTF-8">
          <meta name="viewport" content="width=device-width, initial-scale=1.0">
          <title>Floiint</title>
          <style>
          
            .logo {
              width: 100px;
              height: auto;
              margin-bottom: 20px;
            }
            body {
              font-family: Arial, sans-serif;
              margin: 0;
              padding: 0;
              display: flex;
              justify-content: center;
              align-items: center;
              height: 100vh;
              background-color: #f4f4f9;
            }
            .container {
              text-align: center;
              background: #fff;
              padding: 20px 30px;
              border-radius: 8px;
              box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            }
            h1 {
              color: #eb0527;
              margin-bottom: 20px;
            }
            p {
              color: #555;
            }
            a {
              text-decoration: none;
              color: #fff;
              background: #eb0527;
              padding: 10px 20px;
              border-radius: 5px;
              font-weight: bold;
              margin-top: 15px;
              display: inline-block;
            }
            a:hover {
              background: #45a049;
            }
          </style>
        </head>
        <body>
          <div class="container">
          <img src="${image64}" alt="Logo" class="logo">
            <h1>¡No ha sido posible verificar tu cuenta, el enlace de verificación ha caducado!</h1>
            <p>Lo sentimos, inténtalo de nuevo.</p>            
          </div>
        </body>
      </html>
    `;
}




async function sendMailToUser(eMail, token, userId) {
  const transporter = nodemailer.createTransport({
    host: "mail.privateemail.com",
    port: 465, // Use 465 for SSL or 587 for TLS
    secure: true, // Set to true for port 465, false for 587
    auth: {
      user: "noreplay@floiint.com", // Your Namecheap Private Email address
      pass: "Fra8025$", // Your email account password
    },
  });

  const mailOptions = {
    from: "noreplay@floiint.com", // Sender address
    to: eMail, // List of recipients
    subject: "Bienvenid@ a Floiint", // Subject line
    //   text: "Hello, this is a test email sent using Nodemailer and Namecheap Private Email.", // Plain text body
    html: await genMailBody(token, userId),
    attachments: [
      {
        filename: "Logo-Floiint", // Image file name
        path: await getPresignedUrl(buckets.floiint.name, buckets.floiint.internal.logo_mail), // Local path to the image
        cid: "unique-image-id", // Content ID (used in the HTML as `src="cid:unique-image-id"`)
      },
    ],
  };

  const response = await transporter.sendMail(mailOptions);


}





module.exports = {
  genMailBody,
  sendMailToUser,
  genHtmlAccountVerified,
  gentAccountNotVerified
};
