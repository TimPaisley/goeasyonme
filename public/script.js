$(function () {

  var Board = {
    var PLAYERS = {
      WHITE : { name: "white", code: "W" },
      BLACK : { name: "black", code: "B" }
    }

    init: function (size) {
      this.size = size;
      this.moves = [];
      this.activePlayer = PLAYERS.WHITE;
    }

    attemptMove: function (x, y) {
      if (validateMove(x, y)) {
        placeStone(x, y, this.activePlayer);
        switchPlayers();
      }
    }

    switchPlayers: function () {
      if (activePlayer == PLAYERS.WHITE) { this.activePlayer = PLAYERS.BLACK }
      else { this.activePlayer = PLAYERS.WHITE }
    }

    validateMove: function (x, y) {
      for (var i = 0; i < this.moves.length; i++) {
        if (moves[i].row == y && moves[i].col == x) {
          return false;
        }
      }

      return true;
    }

    placeStone: function (x, y, player) {
      var table = $("#board-table");
      var stone = $("<div>").addClass("stone").addClass(colour);

      stone.css('top', 6.25 + ((y-2) * 12.5) + "%");
      stone.css('left', 6.25 + ((x-2) * 12.5) + "%");

      table.append(stone);

      this.move.push({
        row: y,
        col: x,
        player: player
      })
    }
  }

  $("#board-table").click(function(e) {
    var parentOffset = $(this).offset();
    var relX = e.pageX - parentOffset.left;
    var relY = e.pageY - parentOffset.top;

    var col = Math.round((relX - 17)/280 * 8 + 1);
    var row = Math.round((relY - 17)/280 * 8 + 1);

    var colour = "black";

    createStone(col, row, colour);
    socket.emit('place stone', col, row, colour);
  });

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

  socket.on('place stone', function(col, row, colour) {
    rowLetter = String.fromCharCode(64 + row);
    player = colour.charAt(0).toUpperCase() + colour.slice(1);

    addMessage(player + " has placed a stone at " + rowLetter + col);
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
