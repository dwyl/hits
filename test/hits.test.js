var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var hits = require('../lib/hits');
var extract = require('../lib/extract_request_data.js');

test(file+'Add a hit to the list for that url', function (t) {
  var req = {
    'url': '/my/awesome/url',
    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
    'ip': '8.8.8.8',
    'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
  }
  var hit = extract(req);
  hits(hit, function (err, count) {
    // console.log('16 >>> ', err, count);
    t.ok(count >= 0, '✓ URL ' +req.url +' was added at a index: ' + count);
    t.end();
  })
});

test(file+'Add a hit without language', function (t) {
  var req = {
    'url': '/my/awesome/url',
    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
    'ip': '8.8.8.8'
  }
  var hit = extract(req);
  hits(hit, function (err, count) {
    // console.log('30 >>> ', err, count);
    t.ok(count >= 0, '✓ REQ ' +req.url +' was added at a index: ' + count);
    t.end(require('redis-connection')().end(true)); // shutdown redis con
  })
});
