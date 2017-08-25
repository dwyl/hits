var port  = process.env.PORT || 8000;
var http  = require('http'); // plain http server (no fancy framework required)
var fs    = require('fs'); // so we can open the file
var png   = fs.readFileSync('./lib/1x1px.png'); // "tracking pixel" 
var hits  = require('./lib/hits'); // our storage interface
var favicon = 'http://i.imgur.com/zBEQq4w.png'; // dwyl favicon
var make_svg = require('./lib/make_svg.js');
var extract = require('./lib/extract_request_data.js');
var HEAD = require('./lib/headers.json'); // stackoverflow.com/a/2068407/1148249

var app = http.createServer(function handler(req, res) {
  
  var url = req.url;

  if (url.match(/svg/)) {
    var hit = extract(req);
    hits(hit, function(err, count) {
      console.log(url, ' >> ', count);
      res.writeHead(200, HEAD);
      res.end(make_svg(count));
    });
  }
  // else if (url.match(/png/)) { // see: https://github.com/dwyl/hits/issues/4
  //   hits.add(r, function(err, count) {
  //     console.log(r.url, ' >> ', count);
  //     res.writeHead(200, Object.assign(HEAD, {"Content-Type": "image/png"}));
  //     res.end(png);
  //   });
  // }
  else if(url === '/favicon.ico') {
    res.writeHead(301, { "Location": favicon });
    res.end();
  }
  else if(url === '/stats') {
    fs.readFile('./lib/index.html', 'utf8', function (err, data) {
      res.writeHead(200, {"Content-Type": "text/html"});
      res.end(data);
    });
  }
  else if(url === '/client.js') {
    fs.readFile('./lib/client.js', 'utf8', function (err, data) {
      res.writeHead(200, {"Content-Type": "application/javascript"});
      res.end(data);
    });
  }
  else if(url === '/style.css') {
    fs.readFile('./lib/style.css', 'utf8', function (err, data) {
      res.writeHead(200, {"Content-Type": "text/css"});
      res.end(data);
    });
  }
  else { // echo the record without saving it
    console.log(" - - - - - - - - - - record:", r);
    res.writeHead(200, {"Content-Type": "application/json"});
    res.end(JSON.stringify(r, null, "  "));
  } // pretty JSON in Browser see: http://stackoverflow.com/a/5523967/1148249
}).listen(port);

var io = require('socket.io')(app);

io.on('connection', function (socket) {
  console.log(' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
  console.log(socket.client.conn);
  console.log(' - - - - - - - - - - - - - - - - - - - - - - - - - - - - - ');
  socket.emit('news', { msg: 'welcome to stats-ville!' });
  socket.on('my other event', function (data) {
    console.log(data);
  });
});

console.log('Visit http://localhost:' + port);
