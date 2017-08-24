var fs = require('fs');
var path = require('path');
var template = fs.readFileSync(path.resolve('./lib/template.svg'), 'utf8'); 

module.exports = function make (count) {
  return template.replace('{count}', count);
}
