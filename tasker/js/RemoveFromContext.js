// For testing
// let par1 = 'car';
// let par2 = 'all' || '';
// let context = 'home,work,car,silent,home'.split(',').filter(c => c.length > 0);

const par1 = local('par1');
const par2 = local('par2') || '';
let context = global('Modes_Contexts').split(',').filter(c => c.length > 0);

let index = context.indexOf(par1);
if (index > -1) {
  if (par2.toLowerCase() === 'all') { // remove all occurances
    while (index > -1) {
      context.splice(index, 1);
      index = context.indexOf(par1);
    }
    setGlobal('Modes_Contexts', context.join(','));
  } else { // remove first occurance
    context.splice(index, 1);
    setGlobal('Modes_Contexts', context.join(','));
  }
}

// For testing
console.dir(context);

// Old code
// let context = global('Modes_Contexts').split(',').filter(c => c.length > 0);
// let index = context.indexOf(local('par1'));
// if (index > -1) {
//   context.splice(index, 1);
//   setGlobal('Modes_Contexts', context.join(','));
// }
