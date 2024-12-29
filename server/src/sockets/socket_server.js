require("dotenv").config();
const express = require("express");
const logger = require("./log");
const http = require("http");
const { header } = require("express-validator");
const socketHandler = require("./socket_handler");
const app = express();
app.use(express.json());
const port = process.env.SERVER_SOCKET_PORT;
const server = http.createServer(app);

app.post("/chat", (req, res) => {
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
});

app.post("/notif", (req, res) => {
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
  socketHandler.socketInit();
  console.log(`El servidor AUTH está corriendo en el puerto ${port}`);
});
