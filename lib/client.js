// connect to websocket server
$( document ).ready(function() {
  console.log('Ready!', window.location.host);
  var socket = io(window.location.host);
  socket.on('news', function (data) {
    console.log(data);
    socket.emit('my other event', { my: 'data' });
  });
});
