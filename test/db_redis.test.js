var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var db = require('../lib/db_redis.js');
var extract = require('../lib/extract_request_data.js');

test(file+'Add a hit to the list for that url', function (t) {
  var req = {
    'url': '/my/awesome/url',
    'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
    'ip': '8.8.8.8',
    'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
  }
  var hit = extract(req);
  db(hit, function (err, count) {
    t.ok(count >= 0, '✓ URL ' +req.url +' has: ' + count)
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
  db(hit, function (err, count1) {
    t.ok(count1 >= 0, '✓ URl ' +req.url +' was added at a index: ' + count1)
    db(hit, function (err, count2) {
      t.ok(count2 > count1, '✓ URL ' +req.url +' count is: ' + count2);
      t.end(); // shutdown redis con  
    });  
  });
});
