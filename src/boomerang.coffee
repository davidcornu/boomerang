_        = require('underscore')
express  = require('express')
http     = require('http')
request  = require('request')
filter   = require('./boomerang/filter').filter

class Boomerang

  proxiedHeaders: ['cache-control', 'user-agent', 'accept', 'accept-language', 'cookie']

  constructor: (@options = {}) ->
    _(@options).extend
      port: 3000
    @app     = express()
    @server  = http.createServer(@app).listen(@options.port)
    @configure()

  configure: ->
    isDevelopment = process.env['NODE_ENV'] != 'production'
    @app.configure =>
      @app.use express.logger('dev') if isDevelopment
      @app.use @app.router
      @app.use express.errorHandler() if isDevelopment

    @app.all(['/blog','/blog/*'], @proxyRequest) # Avoids matching paths that start with 'blog'

  proxyRequest: (req, res) ->
    options =
      uri: 'http://blog.busbud.com' + req.params[0].replace(/\/blog/, '') # params[0] includes the entire request path
      headers: _(req.headers).pick(@proxiedHeaders...)
      method: req.method

    options['body'] = req.body if req.body # Only present for POST/PUT requests

    request options, (error, response, body) ->
      return next(error) if error
      res.statusCode = response.statusCode
      for header, value of response.headers
        res.setHeader(header, value)

      if (/text\/html/i).test(response.headers['content-type'])
        filter(body, (clean) -> res.end(clean))
      else # Don't blow up for rss requests
        res.end(body)

exports.createServer = (options) ->
  return new Boomerang(options)