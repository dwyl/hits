var url = require('url');

function getConnection (connection) {
  if (connection === 'prod') {
    var redisURL = url.parse(process.env.REDISCLOUD_URL);
    return {
      port: redisURL.port,
      host: redisURL.hostname,
      auth: redisURL.auth.split(":")[1]
    }
  }
  else {
    return {
      port: 6379,
      host: '127.0.0.1',
      auth: null
    }
  }
}

module.exports = getConnection;
