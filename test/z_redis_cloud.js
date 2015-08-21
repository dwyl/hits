require('env2')('config.env');
var test    = require('tape');
var decache = require('decache');
var redis   = require('redis');

var dir     = __dirname.split('/')[__dirname.split('/').length-1];
var file    = dir + __filename.replace(__dirname, '') + " -> ";

test(file + " Confirm RedisCloud is accessible GET/SET", function(t) {

  var rc  = require('../lib/redis_config.js')('prod');
  // console.log('Redis config: ', rc);
  var redisClient = redis.createClient(rc.port, rc.host, {no_ready_check: true});
  redisClient.auth(rc.auth);

  redisClient.set('redis', 'working', redisClient.print);
  // console.log("✓ Redis Client connected to: " + redisClient.address);
  t.ok(redisClient.address !== '127.0.0.1:6379', "✓ Redis Client connected to: " + redisClient.address)
  redisClient.get('redis', function (err, reply) {
    t.equal(reply.toString(), 'working', '✓ RedisCLOUD is ' + reply.toString());
    redisClient.end();   // ensure redis con closed! - \\
    t.equal(redisClient.connected, false, "✓ Connection to RedisCloud Closed");
    t.end();
  });
});
