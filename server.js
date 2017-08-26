var port  = process.env.PORT || 8000;
var fs    = require('fs'); // so we can open the HTML & JS file
var hits  = require('./lib/hits'); // our storage interface
var make_svg = require('./lib/make_svg.js');
var extract = require('./lib/extract_request_data.js');

var FAVICON = 'http://i.imgur.com/zBEQq4w.png'; // dwyl favicon
var HEAD = require('./lib/headers.json'); // stackoverflow.com/a/2068407/1148249

// plain node.js http server (no fancy framework required!)
var app = require('http').createServer(handler)
var io = require('socket.io')(app);

io.on('connection', function (socket) {
  socket.emit('news', { hello: 'world' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
});

app.listen(port);

function handler (req, res) {
  var url = req.url;
  var hit = extract(req);
  console.log(hit);
  if (url.match(/svg/)) {
    hits(hit, function(err, count) {
      // var 
      io.sockets.emit('hit', { 'hit': hit });
      console.log(url, ' >> ', count);
      res.writeHead(200, HEAD);
      res.end(make_svg(count));
    });
  }
  else if(url === '/favicon.ico') {
    console.log('favicon.ico');
    res.writeHead(301, { "Location": FAVICON });
    res.end();
  }
  else if(url === '/client.js') { // these can be cached in "Prod" ...
    fs.readFile('./lib/client.js', 'utf8', function (err, data) {
      res.writeHead(200, {"Content-Type": "application/javascript"});
      res.end(data);
    });
  }
  else { // echo the record without saving it
    fs.readFile('./lib/index.html', 'utf8', function (err, data) {
      res.writeHead(200, {"Content-Type": "text/html"});
      res.end(data);
    });
  }
}

console.log('Visit ' + require('./lib/lanip') + ':'+ port);
