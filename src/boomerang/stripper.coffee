naiveFilter = (text) ->
  text
    .replace(/<script[^>]*>[\S\s]*?<\/script>/g, '')
    .replace(/<style[^>]*>[\S\s]*?<\/style>/g, '')
    .replace(/<link(rel\s?=['"]\s?stylesheet\s?['"]|[^>])*\/>/g, '')
    .replace(/style\s?=\s?("[^"]*"|'[^']*')/g, '')

exports.naiveStrip = (input, output) ->
  buffer = ""

  input.on 'data', (buf) ->
    buffer += buf.toString()

  input.on 'end', ->
    output.write(naiveFilter(buffer))
    output.end()

# exports.strip = (input, output) ->
