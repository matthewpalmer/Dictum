var fs = require('fs');

function getInputFile(filename) {
  var str = fs.readFileSync(filename, 'utf8');
  return str;
}

function splitNewlines(inputString) {
  var arr = inputString.split('\n');
  for (var i = 0; i < arr.length; i++) {
    arr[i] = arr[i].replace('\r', '');
    arr[i] = arr[i].replace('\n', '');
    arr[i] = '"' + arr[i] + '"';
  }
  arr.pop();
  return arr;
}

function writeOutputFile(filename, output) {
  fs.writeFileSync(filename, output, 'utf8');
}

function go(inputFile, outputFile) {
  var inputStr = getInputFile(inputFile);
  var arrFromIn = splitNewlines(inputStr);
  console.log(arrFromIn);
  arrFromIn = '[' + arrFromIn + ']';
  writeOutputFile(outputFile, arrFromIn);
}

go('web2', 'web2.json');
