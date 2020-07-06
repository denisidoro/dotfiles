function main() {
    // For testing
    // let par1 = 'home';
    // let par2 = undefined || '';
    // let context = 'home,work,car,silent,home'.split(',').filter(c => c.length > 0);

    const par1 = local('par1');
    const par2 = local('par2');
    var context = global('Modes_Contexts').split(',').filter(c => c.length > 0);

    // For testing
    console.dir(par1+";"+par2+";"+context);

    if (par1) {
      switch (par2) {
        case ('if-not-exists'): {
          if (context.indexOf(par1) === -1) appendToContext(par1);
          break;
        }
        case (par2.match(/^max-count=\d+$/) || {}).input: {
          let maxCount = parseInt(par2.toLowerCase().replace('max-count=', ''));
          if (maxCount) {
            let currentCount = context.filter((c) => { return c === par1; }).length;
            if (currentCount < maxCount) appendToContext(par1);
          }
          break;
        }
        default: { appendToContext(par1); }
      }
    }

    function appendToContext(c) {
      context.push(c);
      setGlobal('Modes_Contexts', context.join(','));
    }

    // For testing
    console.dir(context);

    // Old code
    // let context = global('Modes_Contexts').split(',').filter(c => c.length > 0);
    // context.push(local('par1'));
    // setGlobal('Modes_Contexts', context.join(','));
}
