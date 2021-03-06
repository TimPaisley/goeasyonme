var express = require('express');
var app = express();
var http = require('http').Server(app);
var io = require('socket.io')(http);

app.use(express.static(__dirname + '/public'));

app.get('/', function(req, res){
  res.sendFile(__dirname + '/index.html');
});

io.on('connection', function(socket){
  socket.on('chat message', function(msg){
    io.emit('chat message', msg);
  });

  socket.on('place stone', function(row, col, colour) {
    io.emit('place stone', row, col, colour);
  });
});

http.listen(process.env.PORT || 5000, function(){
  console.log('listening on *:3000');
});
