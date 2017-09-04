var redisClient = require('redis-connection')();
var hash = require('./hash.js');
/**
 * add - adds an entry into the List for a given url
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function redis_save_hit (hit, callback) {
  var h = hit.split('|'); // See README.md#How secton for sample data
  var url = h[1];
  
  // save unique hash of browser data to avoid duplication
  var unique_browser_string = [ h[2], h[3], h[4] ].join('|');
  var hashed_agent = hash(unique_browser_string, 10);
  redisClient.hset('agents', hashed_agent, unique_browser_string);
  
  // save hit data with hashed browser data:
  var entry = h[0] + '|' + hashed_agent;
  redisClient.rpush(url, entry,  function (err, data) {
    callback(err, data)
  });
}
