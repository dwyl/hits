var root = document.getElementById("hits");

// $( document ).ready(function() {
  console.log('Ready!', window.location.host);
  var socket = io(window.location.host);
  socket.on('news', function (data) {
    console.log(data);
    socket.emit('hello', { msg: 'Hi!' });
  });
  
  socket.on('hit', function (data) {
    // $('#hits').prepend('<div>' + data.hit + '</div>')
    var previous = root.childNodes[0];
    root.insertBefore(div(Date.now(), data.hit), previous);
  });
// });

// borrowed from: https://git.io/v536m
function div(divid, text) {
  var div = document.createElement('div');
  div.id = divid;
  div.className = divid;
  if(text !== undefined) { // if text is passed in render it in a "Text Node"
    var txt = document.createTextNode(text);
    div.appendChild(txt);
  }
  return div;
}
