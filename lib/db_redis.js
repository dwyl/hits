var redisClient = require('redis-connection')();
var hash = require('./hash.js');
/**
 * add - adds an entry into the List for a given url
 * @param {String} url - the url for the hit
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function redis_save_hit (hit, callback) {
  var parts = hit.split('|');
  var agent = hash(parts[2], 7);
  redisClient.hset('agents', agent, parts[2]);
  parts[2] = agent; // save space in db replacing user-agent with shorter hash
  redisClient.rpush(parts[1], parts.join('|'),  function (err, data) {
    callback(err, data)
  });
}
