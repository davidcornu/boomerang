var path = require('path');

desc('Default task');
task('default', function(){
  console.log("See 'jake -T' for available tasks.");
});

desc('Build & watch CoffeeScript files');
task('build', [], function(){
  var exec = require('child_process').exec;

  var srcDir = path.join(__dirname, 'src');
  var outDir = path.join(__dirname, 'lib');
  var cmd    = ['coffee -o', outDir, '-cw', srcDir].join(' ');

  var child = exec(cmd, function(){ complete(); });
  child.stdout.pipe(process.stdout);
}, true);