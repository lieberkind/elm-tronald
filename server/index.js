const express = require("express");
var request = require("request");
var fs = require("fs");
const _ = require("lodash");
const app = express();

app.use(function(req, res, next) {
  res.header("Access-Control-Allow-Origin", "*");
  res.header(
    "Access-Control-Allow-Headers",
    "Origin, X-Requested-With, Content-Type, Accept"
  );
  next();
});

// process.env.PORT lets the port be set by Heroku
var port = process.env.PORT || 3001;

app.get("/search/quote", function(req, res) {
  var query = req.query.query;
  var newurl = "https://api.tronalddump.io/search/quote?query=" + query;
  request(newurl).pipe(res);
});

app.get("/hundewissen", function(req, res) {
  var input = fs
    .readFileSync("hundewissen.txt")
    .toString()
    .split("\n");

  res.setHeader("Content-Type", "application/json");
  res.send(JSON.stringify({ facts: [_.sample(input)] }));
});

app.listen(port, () => {
  console.log("Listening on: " + port);
});
