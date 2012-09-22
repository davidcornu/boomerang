jsdom = require('jsdom')

# Proxy the output stream so that it can be completely buffered before being parsed.
proxy = (input, output, filter) ->
  outWrite = output.write
  outEnd   = output.end
  buffer   = ''

  output.write = (buf) ->
    buffer += buf.toString()

  output.end = (buf) ->
    buffer += buf.toString() if buf
    filter buffer, (cleanHtml) ->
      outEnd.call(output, cleanHtml)

  input.pipe(output)

# A basic implentation using regular expressions
rxpStrip = (html, callback) ->
  cleanHtml = html
    .replace(/<script[^>]*>[\S\s]*?<\/script>/g, '')                  # <script> tags
    .replace(/<style[^>]*>[\S\s]*?<\/style>/g, '')                    # <style> tags
    .replace(/<link(rel\s?=['"]\s?stylesheet\s?['"]|[^>])*\/>/g, '')  # stylesheets
    .replace(/style\s?=\s?("[^"]*"|'[^']*')/g, '')                    # inline styles
  callback(cleanHtml) if typof(callback) == 'function'

exports.naive = (input, output) ->
  proxy(input, output, rxpStrip)

# A much better implementation using JSDom
domFilter = (html, callback) ->
  # Prevent any additional resources from being loaded for both speed and
  # security reasons.
  jsdom.defaultDocumentFeatures =
    FetchExternalResources: false
    ProcessExternalResources: false
    QuerySelector: false

  jsdom.env html, (errors, window) ->
    # Remove style blocks
    for intruder in window.document.getElementsByTagName('style')
      intruder.parentNode.removeChild(intruder)

    # Remove script blocks
    for intruder in window.document.getElementsByTagName('script')
      intruder.parentNode.removeChild(intruder)

    # Remove stylesheet links
    for intruder in window.document.getElementsByTagName('link')
      if intruder.getAttribute('rel') == 'stylesheet'
        intruder.parentNode.removeChild(intruder)

    if typeof(callback) == 'function'
      callback(window.document.documentElement.innerHTML)

exports.dom = (input, output) ->
  proxy(input, output, domFilter)

