var uniki = require('../lib/hash.js');
var test  = require('tape');


test("Create hash for url: 1234", function(t) {
  var str = uniki(1234);
  t.equal(str.length, 8, "Worked as expected "+str);
  t.equal(str, '1ARVn2Au', "uniki is consistent. 1234 >> 1ARVn")
  t.end();
});

test("Full Length Hash", function(t) {
  var hash = uniki("RandomGobbledygook", 100);
  t.true(hash.length === 78, "Full Length is " + hash.length + ' chars');
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
  // var hash = 'H3ll0W0rld!';
  // var obj = {};
  // // var fixture = require('./hash_fixture.json');
  // for(var i=0; i < 101; i++){
  //   obj[hash] = uniki(hash, 10); 
  //   hash = uniki(hash);
  // }
  // console.log(JSON.stringify(obj, null, 2))
  // var hash = uniki("RandomGobbledygook", 100);
  // t.true(hash.length === 78, "Full Length is " + hash.length + ' chars');
  t.end();
});
