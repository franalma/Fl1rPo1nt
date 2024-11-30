require("dotenv").config();
const express = require("express");
const logger = require("./logger/log");
const http = require("http");
const dbHandler = require("./database/database_handler");
const { body, validationResult } = require('express-validator');
const authHandler = require("./auth/auth_handler");
const { DB_INSTANCES } = require("./database/databases");
const mailHandler = require("./mail/mail_handler");



const app = express();
app.use(express.json());
const port = process.env.SERVER_PORT_AUTH;
const server = http.createServer(app);

const validatitionRules = {
  REGISTER_USER_RULES: [
    body('input.name').notEmpty().withMessage("Name cant be empty"),
    body('input.surname').optional(),
    body('input.phone').isMobilePhone().withMessage("Phone number is mandatory"),
    body('input.email').notEmpty().isEmail().withMessage("eMail cant be empty"),
    body('input.password')
      .isLength({ min: 8 }).withMessage('La contraseña debe tener al menos 8 caracteres')
      .matches(/[A-Z]/).withMessage('La contraseña debe contener al menos una letra mayúscula')
      .matches(/[a-z]/).withMessage('La contraseña debe contener al menos una letra minúscula')
      .matches(/\d/).withMessage('La contraseña debe contener al menos un número')
      .matches(/[@$!%*?&]/).withMessage('La contraseña debe contener al menos un carácter especial (@, $, !, %, *, ?, &)'),
    body("input.zip_code").isNumeric().withMessage("Zip code must be a number"),
  ]
}

function requestDoValidation(req) {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return { errors: errors.array() };
  }
  return null;
}

function requestRegistrationValidation(req, res, next) {
  logger.info("custom requestRegistrationValidation");
  try {
    const validationSet = validatitionRules.REGISTER_USER_RULES;
    Promise.all(validationSet.map(validation => validation.run(req)))
      .then(() => next())
      .catch(next);
  } catch (error) {
    logger.info(error);
    res.status(500).json({ message: "Error processing the request" });
  }
}

function requestLoginValidation(req, res, next) {
  logger.info("custom requestLoginValidation");
  try {
    switch (action) {
      case hostActions.PUT_USER: {
        validationSet = validationRules.NEW_USER_VALIDATION_RULES;
        break;
      }
      case hostActions.DO_LOGIN: {

        break;
      }
    }
    Promise.all(validationSet.map(validation => validation.run(req)))
      .then(() => next())
      .catch(next);
  } catch (error) {
    logger.info(error);
    res.status(500).json({ message: "Error processing the request" });
  }


}


// async function processAuthRequest(action, req, res) {
//   logger.info("starts processAuthRequest");
//   let result = {};
//   try {

//     logger.info(action);
//     switch (action) {
//       case HOST_AUTH_ACTIONS.REGISTER: {
//         result = await userHandler.registerUser(req.body.input);
//         break;
//       }
//       case HOST_AUTH_ACTIONS.REGISTER: {
//         result = await userHandler.doLogin(req.body.input);
//         break;
//       }
//       // case hostActions.TOKEN_LOGIN: {
//       //   break;
//       // }
//     }



//   } catch (error) {
//     logger.info("processAuthRequest:" + error);
//   } finally {
//     if (result && result.status) {
//       res.status(result.status).json(result);
//     } else {
//       res.status(500).json({ message: "Error processing the request" });
//     }
//   }
// }

async function sendResult(req, res, result) {
  logger.info("Starts processResult");
  try {
    res.status(result.status).json(result);
  } catch (error) {
    logger.info(error);
    res.status(500).json(error);
  }
}

app.post("/register", requestRegistrationValidation, (req, res) => {
  try {
    const result = requestDoValidation(req);
    if (result) {
      res.status(400).json(result);
    } else {
      authHandler.doRegisterUser(req.body.input).then((result) => {
        sendResult(req, res, result)
      });
      // userHandler.registerUser();
      // processAuthRequest(req, res);
    }

  } catch (error) {
    logger.info(error);
    res.status(500).json({ message: "Error processing the request" });
  }
});

app.get("/register/validation/:token/:id", (req, res) => {
  const  token = req.params.token;
  const  id = req.params.id;
  logger.info("Validation token: "+token);
  logger.info("Validation id: "+id);
  authHandler.activateAccount(token, id).then((result)=>{
    if (result){
      mailHandler.genHtmlAccountVerified().then((html) => {    
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(html);
      });
    }
  });

});


server.listen(port, () => {
  dbHandler.connectToDatabase(DB_INSTANCES.DB_AUTH).then((result) => {
    if (result == null) {
      throw "Db connection error";
    } else {
      console.log(`El servidor está corriendo en el puerto ${port}`);
    }
  });

});
