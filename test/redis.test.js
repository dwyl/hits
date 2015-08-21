require('env2')('config.env');
var test   = require('tape');
var redis  = require("redis");
var client = redis.createClient();

test("The value for key 'Hello' should be 'World' ", function(t) {
  client.set("Hello", "World", redis.print);
  client.get("Hello", function(err, reply) {
     // reply is null when the key is missing
     console.log('Hello ' + reply);
     t.equal(reply, 'World', 'value for key Hello is World (as expected).');
     client.end();
     t.end();
  });
});
