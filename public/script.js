$(function () {

  createStone(3, 4, "white");
  createStone(5, 7, "black");
  createStone(1, 1, "black");

  function createStone(x, y, colour) {
    var table = $("#board-table");
    var stone = $("<div>").addClass("stone").addClass(colour);

    stone.css('top', 6.25 + ((y-2) * 12.5) + "%");
    stone.css('left', 6.25 + ((x-2) * 12.5) + "%");

    table.append(stone);
  }

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
