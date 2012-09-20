_       = require('underscore')
express = require('express')
http    = require('http')

class Boomerang

  constructor: (@options = {}) ->
    _(@options).extend
      port: 3000
    @app     = express()
    @server  = http.createServer(app).listen @options.port, ->
      console.log "Boomerang listening on port #{@options.port}"
    @configure()

  configure: ->
    @app.configure ->
      @app.use express.logger('dev')
      @app.use app.router

    @app.configure 'development', ->
      app.use express.errorHandler()

exports.createServer = (options) ->
  return new Boomerang(options)