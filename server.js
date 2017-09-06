var port  = process.env.PORT || 8000;
var fs    = require('fs'); // so we can open the HTML & JS file
var hits  = require('./lib/db_filesystem.js'); // our storage interface
var make_svg = require('./lib/make_svg.js');
var extract = require('./lib/extract_request_data.js');
var format = require('./lib/format_hit.js')

var FAVICON = 'http://i.imgur.com/zBEQq4w.png'; // dwyl favicon
var HEAD = require('./lib/headers.json'); // stackoverflow.com/a/2068407/1148249

// plain node.js http server (no fancy framework required!)
var app = require('http').createServer(handler)
var io = require('socket.io')(app);

io.on('connection', function (socket) {
  socket.emit('news', { hello: 'world (test message)' });
  socket.on('hello', function (data) {
    console.log(data);
  });
});

function handler (req, res) {
  var url = req.url;      // alias req.url to reduce typing in matching below
  var hit = extract(req); // extract just the data we want from the HTTP request

  if (url.match(/svg/)) {      // only return a badge if SVG requested
    hits(hit, function(err, count) {
      io.sockets.emit('hit', { 'hit': format(hit, count) }); // broadcast
      // console.log(url, ' >> ', count); // log in dev
      res.writeHead(200, HEAD);        // status code and SVG headers
      res.end(make_svg(count));        // serve the SVG with count
    });
  }
  else if(url === '/favicon.ico') {
    res.writeHead(301, { "Location": FAVICON }); // redirect to @dwyl Favicon
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

app.listen(port);
console.log('Visit ' + require('./lib/lanip') + ':'+ port);
