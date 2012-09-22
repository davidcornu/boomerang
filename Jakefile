var path = require('path');
var exec = require('child_process').exec;

desc('Default task');
task('default', function(){
  console.log("See 'jake -T' for available tasks.");
});

desc('Build & watch CoffeeScript files');
task('build', [], function(){
  var srcDir = path.join(__dirname, 'src');
  var outDir = path.join(__dirname, 'lib');
  var coffee = path.join(__dirname, 'node_modules/coffee-script/bin/coffee')
  var cmd    = [coffee, '-o', outDir, '-cw', srcDir].join(' ');

  var child = exec(cmd, function(){ complete(); });
  child.stdout.pipe(process.stdout);
}, true);

desc('Run Mocha test suite');
task('test', [], function(){
  var mocha    = path.join(__dirname, 'node_modules/mocha/bin/mocha')
  var testFile = path.join(__dirname, 'test/test.coffee')
  var cmd      = [mocha, testFile, '-r coffee-script'].join(' ')

  var child = exec(cmd, function(error, stdout, stderr){
    if (stdout) { console.log(stdout); }
    if (stderr) { console.error(stderr); }
    complete();
  });
}, true);