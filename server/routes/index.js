var GithubApi = require("github");
var github = new GithubApi({version: "3.0.0"});
github.authenticate({
  type: "oauth",
  token: "5d51d6c008713b6f03999d8f542d1f12e4de1b09"
})


var sys = require('sys');
var exec = require('child_process').exec;

function format(result) {
  lines = result.trim().split('\n');
  results = {}
  for (var index=1; index < lines.length; index++) {
    key = lines[index].split(':')[0];
    value = lines[index].split(':')[1]
    results[key] = value;
  }
  return results;
}


exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

exports.profile = function(req, res) {
  userId = req.query.userId.trim();
  exec('ninja profile ' + userId, function(error, stdout, stderr){
    results = format(stdout);
    res.render('profile', { results : results });
  })
}

exports.search = function(req, res) {
  keyword = req.query.keyword;
  exec('ninja search ' + keyword, function(error, stdout, stderr){
    results = format(stdout);
    res.render('search', { results : results });
  })
}

exports.build = function(req, res) {
  buildName = req.query.buildName;
  res.render('build', { buildName : buildName });
}
