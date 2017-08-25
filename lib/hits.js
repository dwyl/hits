/**
 * add - adds an entry into the List for a given url
 * @param {Object} hit - the hit we just received
 * @param {Function} callback - call this once redis responds
 */
module.exports = function add (hit, callback) {
  // if(process.env.REDISCLOUD_URL) {
    return require('./db_redis.js')(hit, callback);
  // }
  // var parts = hit.split('|');
  // var agent = uniki(parts[2],7);
  // redisClient.hset('agents', agent, parts[2]);
  // parts[2] = agent; // replace long-form user-agent with shorter hash
  // redisClient.rpush(parts[1], parts.join('|'),  function (err, data) {
  //   callback(err, data)
  // });
}
