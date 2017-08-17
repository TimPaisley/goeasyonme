$(function () {

  // messages

  var socket = io();
  $('form').submit(function(){
    socket.emit('chat message', $('#m').val());
    $('#m').val('');
    return false;
  });

  socket.on('chat message', function(msg){
    addMessage(msg);
  });

  socket.on('user connected', function(msg) {
    $('#messages').append($('<li>').text("someone has connected"));
  });

  socket.on('user disconnected', function(msg) {
    $('#messages').append($('<li>').text("someone has disconnected"));
  });

  function addMessage(msg) {
    var messages = document.getElementById("messages");
    var isScrolledToBottom = messages.scrollHeight - messages.clientHeight <= messages.scrollTop + 1;

    $('#messages').append($('<li>').text(msg));

    if(isScrolledToBottom)
      messages.scrollTop = messages.scrollHeight - messages.clientHeight;
  }
});
