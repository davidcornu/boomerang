# Boomerang

A layer-7 proxy for the [Busbud](http://busbud.com) [blog](http://blog.busbud.com) which

- Serves content from `http://blog.busbud.com` from any host under the `/blog` path,
rewriting any absolute and relative links to point to the new location.
- Removes the following elements:
    - `<style>`
    - `<link rel='stylesheet'>`
    - `<script>`
    - `<iframe>`
    - Inline `style` attributes

is backed by

- [Express](http://expressjs.com/) for convenience
- [jsdom](https://github.com/tmpvar/jsdom) for parsing and filtering
- [Request](https://github.com/mikeal/request) for networking

and is hosted at http://busbud-boomerang.herokuapp.com/blog for demo purposes.

## Usage

Command-line

```
$ npm install "git+ssh://git@github.com/davidcornu/boomerang.git#master"
$ PORT=3000 boomerang
```

From node

```
var boomerang = require('boomerang');
var options = { port: 3000 };
boomerang.createServer(options); # returns an instance of Boomerang
```

## Development

Setup

```
$ npm install -g jake
$ npm install
```

Boomerang uses [Jake](https://github.com/mde/jake) to simplify regular tasks.
Note that although Jake is included in `package.json` for version reference,
it is much more convenient to install it globally.

- `$ jake build` builds [CoffeeScript](http://coffeescript.org/) files from the
`/src` directory into the `/lib` directory.
- `$ jake test` runs the [Mocha](http://visionmedia.github.com/mocha/) test suite.