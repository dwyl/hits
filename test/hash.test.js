var uniki = require('../lib/hash.js');
var test  = require('tape');


test("Create hash for url: 1234", function(t) {
  var hash = uniki(1234);
  t.equal(hash.length, 12, "Worked as expected " + hash);
  console.log(hash)
  t.equal(hash, '1ARVn2Auq2WA', "Hash is consistent. 1234 >> 1ARVn2Auq2WA")
  t.end();
});

test("Full Length Hash", function(t) {
  var hash = uniki("RandomGobbledygook", 100);
  t.true(hash.length === 78, "✓ Full Length is " + hash.length + ' chars');
  t.end();
});

test("Browser Agent String Hash", function(t) {
  var user_agent_string = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_5)|84.91.136.21|EN-US';
  var hash = uniki(user_agent_string, 10);
  t.true(hash === '8HKg3NB5Cf', "Browser Data Hash: " + hash);
  t.end();
});

test("Consistenty check against 100 sample hashes", function(t) {
  var fixture = require('./hash_fixtures.json');
  Object.keys(fixture).forEach(function(k) {
    var expected = fixture[k];
    var actual = uniki(k, 10);
    t.true(expected === actual, 
      '✓ hash(' + k + ') >> expected: ' + expected + ' === actual: ' + actual);
  })
  t.end();
});
