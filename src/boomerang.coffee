_        = require('underscore')
express  = require('express')
http     = require('http')
request  = require('request')
stripper = require('./boomerang/stripper')

class Boomerang

  proxiedHeaders: ['cache-control', 'user-agent', 'accept', 'accept-language', 'cookie']

  constructor: (@options = {}) ->
    _(@options).extend
      port: 3000
    @app     = express()
    @server  = http.createServer(@app).listen @options.port, =>
      console.log "Boomerang listening on port #{@options.port}"
    @configure()

  configure: ->
    @app.configure =>
      @app.use express.logger('dev')
      @app.use @app.router

    @app.configure 'development', =>
      @app.use express.errorHandler()

    @app.all(['/blog','/blog/*'], @proxyRequest)

  proxyRequest: (req, res) =>
    options =
      uri: 'http://blog.busbud.com' + req.params[0].replace(/\/blog/, ''),
      method: req.method
      headers: _(req.headers).pick(@proxiedHeaders...)
      body: req.body

    stripper.naiveStrip(request(options), res)

exports.createServer = (options) ->
  return new Boomerang(options)