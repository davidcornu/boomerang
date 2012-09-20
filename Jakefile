var sys  = require('sys');

desc("Watch CoffeeScript files");
task("build", [], function(){
  var exec = require('child_process').exec;
  var cmd  = "coffee -cw "
  exec("", function(err, stdout, stderr){ sys.puts(stdout); });
});