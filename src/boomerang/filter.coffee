# sax = require('sax')

rxpStrip = (text) ->
  text
    .replace(/<script[^>]*>[\S\s]*?<\/script>/g, '')
    .replace(/<style[^>]*>[\S\s]*?<\/style>/g, '')
    .replace(/<link(rel\s?=['"]\s?stylesheet\s?['"]|[^>])*\/>/g, '')
    .replace(/style\s?=\s?("[^"]*"|'[^']*')/g, '')

exports.naive = (input, output) ->
  write  = output.write
  end    = output.end
  buffer = ''

  output.write = (buf) ->
    buffer += buf.toString()

  output.end = (buf) ->
    buffer += buf.toString() if buf
    end.call(output, rxpStrip(buffer))

  input.pipe(output)

# exports.filter = (input, output) ->

#   buffer = ""
#   position = 0

#   parser = sax.parser(false)

#   input.on 'data', (buf) ->
#     content = buf.toString()
#     buffer += content
#     parser.write(content)

#   input.on 'end', ->
#     parser.end()

#   parser.onend = ->
#     output.write(buffer)
#     output.end()