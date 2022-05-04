const express = require('express');
const app = express();
const port = process.env.PORT || 3000;
const cors = require('cors');
const path = require('path');
const axios = require('axios');
const bodyParser = require('body-parser');
// const socket = require('socket.io');
const WebSocket = require('ws')

let registerData = {
  Username: "tung",
    Password: "tungdeptrai"
}

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.use(cors());
app.use(express.static('public'));


app.post('/register', (req, res) => {   
  console.log("Received header: " + req.header('Content-Type'))
  console.log("Received " + req)
  //  res.json({ username: 'Flavio' })
  registerData = {
    Username: req.body.Username,
    Password: req.body.Password
  }
  console.log(registerData)
  res.status(200).json({status:"ok"})
})

app.post('/mqtt', (req, res) => {   
  console.log("Received header: " + req.header('Content-Type'))
  console.log("Received " + req)
  res.status(200).json({status:"ok"})
})

app.post('/publish', (req, res) => {   
  console.log("Received header: " + req.header('Content-Type'))
  console.log("Received " + req)
  res.status(200).json({status:"ok"})
})

app.post('/wifi', (req, res) => {   
  console.log("Received header: " + req.header('Content-Type'))
  console.log("Received " + req.ssid + req.ssid_password)
  res.status(200).json({status:"ok"})
})


app.post('/login', (req, res) => {   
  console.log("Received header: " + req.header('Cookie'))
  console.log("Received " + req.body.Username)
  
  if (req.body.Username == registerData.Username && req.body.Password == registerData.Password) {
    res.set("Access-Control-Allow-Credentials", true)
    res.cookie('name', req.body.Username)
    res.status(200).json({status:"ok"})
  }
  else res.status(404).json({status:"khong ok"})
  // if ((req.header('Cookie'))) {
  //   if (req.header('Cookie') == 'name=phuongtung0801') {
    
  // }
  // else res.sendStatus(404)
  // } else {
  //   res.send("Not Found Cookie")
  // }
})

app.get('/auth', (req, res) => {   
  console.log("Received header: " + req.header('Cookie'))
  console.log("Received " + req.body)
  // res.send("Response from server")
  // if (req.header('Cookie') == "name=" + registerData.Username) {
  //   res.sendStatus(200)
  // }
  // else res.sendStatus(404)
  if (!(req.header('Cookie') == null)) {
    if (req.header('Cookie') == "name=" + registerData.Username) {
     res.status(200).json({status:"ok"})
  }
  else  res.status(404).json({status:"khong ok"})
  } else {
     res.status(404).json({status:"khong ok"})
  }
})

app.use('*', (req, res) => {
  res.sendFile(path.resolve(__dirname, 'public', 'index.html'));
  console.log("sent index")
});






let server = app.listen(port, () => {
    console.log(`Server is up at port ${port}`);
});

//initialize the WebSocket server instance
const wss = new WebSocket.Server({ server });

wss.on('connection', (ws) => {
    console.log("WebSocket connection made")
    //connection is up, let's add a simple simple event
    ws.on('message', (message) => {

        //log the received message and send it back to the client
        console.log('received: %s', message);
        ws.send(`{"topic": "websocketMSG", "msg": "testing websocket"}`);
    });

    //send immediatly a feedback to the incoming connection    
    ws.send('Hi there, I am a WebSocket server');
});

wss.on('close', () => {
  console.log("WS close now")
})