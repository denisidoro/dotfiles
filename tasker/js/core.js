/* 
Core JS helpers

Usage after sourcing:
   randomLine("mytext\nwith\nmultiple\nlines") 
   paserArgs({foo: 42}, {bar: 43}) 
*/

function randomLine(text) {
  const lines = text.split('\n');
  return lines[Math.floor(Math.random() * lines.length)];
}

function keyvals(m) {
  return Object.keys(m)
    .map(k => [k, m[k]])
}

function parseArgs(m, defaults = null) {
  keyvals({...m, ...defaults})
    .forEach(([k, v]) => {
      setLocal(k.toString(), v.toString())
    })
}
