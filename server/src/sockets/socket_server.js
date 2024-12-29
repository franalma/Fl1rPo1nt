require("dotenv").config();
const express = require("express");
const logger = require("../logger/log");
const http = require("http");
const { header } = require("express-validator");
const socketHandler = require("./socket_handler");
const app = express();
app.use(express.json());
const port = process.env.SERVER_SOCKET_PORT;
const server = http.createServer(app);

app.post("/chat", (req, res) => {
  logger.info("on chat message");
  try {
    const messageType = req.body.message_type;
    const receiverId = req.body.receiver_id;
    const senderId = req.body.sender_id;
    const message = req.body.message;
    const matchId = req.body.match_id;
    const isMessageSent = socketHandler.sendChatMessage(
      messageType,
      receiverId,
      senderId,
      message,
      matchId
    );
    res.status(200).json({
      status: 200,
      sent: isMessageSent
    });
  } catch (error) {
    logger.info(error);
    res.status(500).json({
      status: 500,
      sent: false
    });
  }




});

app.post("/notif", (req, res) => {
  logger.info("on notification message");
  const messageType = req.body.message_type;
  const contactId = req.body.contact_id;
  const scanned = req.body.scanned;
  const input = req.body.input;
  const matchId = req.body.match_id;

  const isMessageSent = socketHandler.sendMessageToUser(
    "new_contact_request",
    contactId,
    scanned,
    input
  );
});


server.listen(port, () => {
  socketHandler.socketInit(server);
  console.log(`El servidor AUTH está corriendo en el puerto ${port}`);
});
