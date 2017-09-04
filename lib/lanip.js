/**
 * If you want to now the IP Address on the Local Network you're in luck!
 * see/credit: http://stackoverflow.com/questions/10750303
 */
var os = require('os');
var interfaces = os.networkInterfaces();
var ip = [];
for (var k in interfaces) {
  for (var k2 in interfaces[k]) {
    var address = interfaces[k][k2];
    if (address.family === 'IPv4' && !address.internal) {
      ip.push(address.address);
    }
  }
}
module.exports = ip[0];
