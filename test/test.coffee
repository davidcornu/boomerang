path      = require('path')
assert    = require('assert')
request   = require('request')
jsdom     = require('jsdom')

basePath  = path.resolve(__dirname, '../')
boomerang = require(path.join(basePath, 'lib/boomerang'))
port      = process.env['PORT'] || 3000
address   = "http://localhost:#{port}"

describe 'Boomerang', ->

  vars = {} # Force CoffeeScript variable declaration

  before (done) ->
    @timeout(5000)
    process.env['NODE_ENV'] = 'production'
    boomerang.createServer(port: port)

    request address + '/blog', (error, response, body) ->
      vars.query =
        response: response
        body: body
      done()

  it 'should return content from blog.busbud.com', ->
    assert(vars.query.body.indexOf('Busbud') >= 0)

  it 'should pass on response headers', ->
    assert(vars.query.response.headers['x-pingback'].length > 0)

  it 'should pass on correct response codes', (done) ->
    request address + '/blog/thisshouldreturn404', (error, response, body) ->
      assert(response.statusCode == 404)
      done()

  it 'should only serve content under /blog', (done) ->
    request address, (error, response, body) ->
      assert(response.statusCode == 404)
      done()

  it 'should reject malformed urls starting with /blog', (done) ->
    request address + '/blogathon', (error, response, body) ->
      assert(response.statusCode == 404)
      done()

  describe 'filter', ->
    before (done) ->
      # Speed things up a little
      jsdom.defaultDocumentFeatures =
        FetchExternalResources: false
        ProcessExternalResources: false
        QuerySelector: false

      jsdom.env vars.query.body, (errors, window) ->
        vars.jsdom =
          errors: errors
          window: window
        done()

    it 'should remove style blocks', ->
      doc = vars.jsdom.window.document
      assert(doc.getElementsByTagName('style').length == 0)

    it 'should remove script references', ->
      doc = vars.jsdom.window.document
      assert(doc.getElementsByTagName('script').length == 0)

    it 'should remove stylesheet references', ->
      doc = vars.jsdom.window.document
      intruderCount = 0
      for intruder in doc.getElementsByTagName('link')
        if intruder.getAttribute('rel') == 'stylesheet'
          intruderCount += 1
      assert(intruderCount == 0)