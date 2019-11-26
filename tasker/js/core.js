/* 
Core JS helpers

Usage after sourcing:
   randomLine("mytext\nwith\nmultiple\nlines") 
*/

function randomLine(text) {
  const lines = text.split('\n');
  return lines[Math.floor(Math.random() * lines.length)];
}

function keyvals(m) {
  var arr = []
  Object.keys(m)
    .forEach(k => arr.push([k, m[k]]))
  return arr
}

function parseArgs(m, defaults = null) {
  keyvals({...m, ...defaults})
    .map(([k, v]) => setLocal(k, v))
}
