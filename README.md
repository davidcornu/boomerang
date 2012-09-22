# Boomerang

A layer-7 proxy for the [Busbud](http://busbud.com) [blog](http://blog.busbud.com) which:

- Serves content from `http://blog.busbud.com` from any host under the `/blog` path
- Removes `<style>` blocks
- Removes `<link rel='stylesheet'>` blocks
- Removes `<script>` blocks

and is backed by

- [Express](http://expressjs.com/) for convenience
- [jsdom](https://github.com/tmpvar/jsdom) for parsing and filtering
- [Request](https://github.com/mikeal/request) for networking

## Usage

Command-line

```
$ npm install git@github.com:davidcornu/boomerang.git
$ PORT=3000 boomerang
```

From node

```
var boomerang = require('boomerang');
var options = { port: 3000 };
boomerang.createServer(options); # returns an instance of Boomerang
```