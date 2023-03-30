// Node required
// https://github.com/nieldlr/hanzi
// API finicky; check output closely

const fs = require('fs'); 
let hanzi = require("hanzi"); // npm install hanzi
hanzi.start();

function define(stringPut) 
{
  let array = Array.from(stringPut);

  for (i in array) {
    let long = hanzi.definitionLookup(array[i]);
    let string = array[i].toString();

    if (long === undefined) 
    {
      stringer = '[{"traditional":"' + string + '","simplified":"ERROR","pinyin":"ERROR","definition":"ERROR"}]';
      fs.appendFileSync('definitions.json', stringer);
      continue;
    }
    else {
      let ba = JSON.stringify(long);
      fs.appendFileSync('definitions.json', ba);
    }

  }
}


function getRadicals(stringPut)
{
  let decomposition = hanzi.decomposeMany('');
  const jsonString = JSON.stringify(decomposition);
  
  fs.writeFile('radicals.json', jsonString, (err) => {
    if (err) {
      console.error(err);
    } else {
      console.log('Datasavedtodata.json');
    }
  });
}


let stringPut = "";
// define(stringPut);
// getRadicals(stringPut);
