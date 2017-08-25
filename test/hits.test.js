var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var extract = require('../lib/extract_request_data.js');

test(file + 'REDIS add hit', function (t) {
   process.env.REDISCLOUD_URL = 'redis://u:@127.0.0.1:6379';
  var hits = require('../lib/hits');
  var req = {
    'url': '/my/awesome/url',
    headers: {
      'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)'
    },
    connection: {
      remoteAddress: '88.8.88.8'
    }
  }
  var hit = extract(req);
  hits(hit, function (err, count) {
    hits(hit, function (err, count2) {
      // console.log('16 >>> ', err, count);
      t.ok(count === count2 - 1, 
        '✓ URL ' +req.url +' was added at a index: ' + count);
      require('redis-connection')().end(true)
      require('decache')('../lib/hits');
      t.end();
    });
  });
});

test(file+'Filesystem add hit', function (t) {
  delete process.env.REDISCLOUD_URL; // force use of Filesystem
  var hits = require('../lib/hits');
  var req = {
    'url': '/my/awesome/url',
    headers: {
      'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)'
    },
    connection: {
      remoteAddress: '88.8.88.8'
    }
  }
  var hit = extract(req);
  hits(hit, function (err, count) {
    t.ok(count >= 0, '✓ REQ ' +req.url +' was added at a index: ' + count);
    t.end(require('redis-connection')().end(true)); // shutdown redis con
  })
});
