// connect to websocket server
$( document ).ready(function() {
  console.log('Ready!', window.location.host);
  var socket = io(window.location.host);
  socket.on('news', function (data) {
    console.log(data);
    socket.emit('my other event', { my: 'data' });
  });
  
  socket.on('hit', function (data) {
    console.log(data.hit);
    var h = data.hit.split('|');
    var hit = [h[0], h[1]].join(' ');
    $('#hits').prepend('<div>' + hit + '</div>')
  });
});


function format_date (timestamp) {
  var date = new Date(timestamp);
// Hours part from the timestamp
var hours = date.getHours();
// Minutes part from the timestamp
var minutes = "0" + date.getMinutes();
// Seconds part from the timestamp
var seconds = "0" + date.getSeconds();

// Will display time in 10:30:23 format
var formattedTime = hours + ':' + minutes.substr(-2) + ':' + seconds.substr(-2);
}
