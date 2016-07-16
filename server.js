var http  = require('http');
var hits  = require('./lib/hits');
var port  = process.env.PORT || 8000;
var wreck = require('wreck');
var fs    = require('fs');
var png   = fs.readFileSync('./lib/1x1px.png');

var HEADERS = { // headers see: http://stackoverflow.com/a/2068407/1148249
  "Cache-Control": "no-cache, no-store, must-revalidate", // HTTP 1.1
  "Pragma": "no-cache",                                   // HTTP 1.0
  "Expires": "0",                                         // Proxies
  "Content-Type":"image/svg+xml"                          // default to svg
};

http.createServer(function handler(req, res) {
  var url = req.url;
  var r = req.headers;
  r.ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  r.url = url.replace('.svg', '').replace('.png', '');

  if (url.match(/svg/)) {
    hits.add(r, function(err, count) {
      console.log(r.url, ' >> ', count);
      var newurl = 'https://img.shields.io/badge/hits-' + count +'-brightgreen.svg';
      wreck.get(newurl, function (error, response, raw) {
        res.writeHead(200, Object.assign(HEADERS, {"Location": newurl}));
        res.end(raw);
      });
    });
  }
  else if (url.match(/png/)) {
    hits.add(r, function(err, count) {
      console.log(r.url, ' >> ', count);
      res.writeHead(200, Object.assign(HEADERS, {"Content-Type": "image/png"}));
      res.end(png);
    })
  }
  else if(url === '/favicon.ico') {
    var favicon = 'https://www.google.com/images/google_favicon_128.png';
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
    res.writeHead(200, {"Content-Type": "text/plain"});
    res.end(JSON.stringify(r, null, "  "));
  } // pretty JSON in Browser see: http://stackoverflow.com/a/5523967/1148249
}).listen(port);

console.log('Visit http://localhost:' + port);
