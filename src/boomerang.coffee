_        = require('underscore')
express  = require('express')
http     = require('http')
request  = require('request')
filter   = require('./boomerang/filter')

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

    @app.all(['/blog','/blog/*'], @proxyRequest) # Avoids matching paths that start with 'blog'

  proxyRequest: (req, res) ->
    options =
      uri: 'http://blog.busbud.com' + req.params[0].replace(/\/blog/, '') # params[0] includes the entire request path
      headers: _(req.headers).pick(@proxiedHeaders...)
      method: req.method

    options['body'] = req.body if req.body # Only present for POST/PUT requests

    filter.dom(request(options), res) # Output of request is piped to the response

exports.createServer = (options) ->
  return new Boomerang(options)