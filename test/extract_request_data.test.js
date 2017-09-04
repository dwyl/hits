var dir  = __dirname.split('/')[__dirname.split('/').length-1];
var file = dir + __filename.replace(__dirname, '') + " > ";
var test = require('tape');
var extract = require('../lib/extract_request_data.js');

test(file + 'Extract "Hit" data from HTTP Request', function(t){
  var req = {
    'url': '/my/awesome/url',
    headers: {
      'accept-language': 'en-US,en;q=0.8,pt;q=0.6,es;',
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)'
    },
    connection: {
      remoteAddress: '88.88.88.88'
    }
  }
  var hit = extract(req);
  t.ok(hit.indexOf('/my/awesome/url|Mozilla/5.0') > -1, 
  '✓ HTTP request data extracted: ' + hit)
  t.ok(hit.indexOf('EN-US') > -1, 
  '✓ extracted language: ' + hit.split('|')[4])
  t.end();
});

test(file + 'fewer headers are set on request object', function(t){
  var req = {
    'url': '/my/awesome/url',
    headers: {
      'accept-language': 'en-GB',
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
      'x-forwarded-for': '88.88.88.88'
    }
  }
  var hit = extract(req);
  t.ok(hit.indexOf('/my/awesome/url|Mozilla/5.0') > -1, 
  '✓ Reduced request data extracted: ' + hit)
  t.ok(hit.indexOf('EN-GB') > -1, 
  '✓ extracted language: ' + hit.split('|')[4])
  t.end();
});

test(file + 'no language defined', function(t){
  var req = {
    'url': '/my/awesome/url',
    headers: {
      'user-agent': 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)',
      'x-forwarded-for': '88.88.88.88'
    }
  }
  var hit = extract(req);
  t.ok(hit.split('|')[4] === '', 
  '✓ no language defined')
  t.end();
});
