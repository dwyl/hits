var http = require('http');
var fs   = require('fs');
var path = require('path');
require('env2')('config.env');
var hits = require('./lib/hits');
var count = 12;

// console.log(img);
var port = process.env.PORT || 8000;
http.createServer(function handler(req, res) {
  var url = req.url;
  var agent = req.headers.user-agent
  var r = req.headers;
  r.ip = req.headers['x-forwarded-for'] || req.connection.remoteAddress;
  r.url = url.replace('.svg', '');

  if (url.match(/svg/)) {
    hits.add(r, function(err, data){
      count = data;
      var newurl = "https://img.shields.io/badge/hits-" + count +"-brightgreen.svg"
      res.writeHead(307, {"Location": newurl });
      res.end();
    })

  }
  else if(url === '/favicon.ico') {
    var fav = 'https://www.google.com/images/google_favicon_128.png'
    res.writeHead(301, {"Location": fav });
    res.end();
  }
  else {
    console.log(" - - - - - - - - - - record:", r);
    res.writeHead(200, {"Content-Type": "text/plain"});
    res.end(JSON.stringify(r, null, "  ")); // see next line
  } // For pretty JSON in Browser see: http://stackoverflow.com/a/5523967/1148249
}).listen(port);

console.log('Visit http://localhost:' + port);
