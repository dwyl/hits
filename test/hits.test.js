var dir     = __dirname.split('/')[__dirname.split('/').length-1];
var file    = dir + __filename.replace(__dirname, '') + " > ";
var test    = require('tape');
var hits     = require('../lib/hits');
var decache = require('decache');

test(file+'Add a hit to the list for that url', function(t){
  var req = {
    'url': '/my/awesome/url',
    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
    'ip': '8.8.8.8',
    'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
  }
  hits.add(req, function(err, data) {
    t.ok(data >= 0, '✓ REQ ' +req.url +' was added at a index: ' + data)
    hits.redisClient.end();
    t.end();
  })
});
