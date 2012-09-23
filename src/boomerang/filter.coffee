jsdom = require('jsdom')

exports.filter = (html, callback) ->
  # Prevent any additional resources from being loaded for both speed and
  # security reasons.
  jsdom.defaultDocumentFeatures =
    FetchExternalResources: false
    ProcessExternalResources: false
    QuerySelector: false

  jsdom.env html, (errors, window) ->
    localLinkRxp  = /https?:\/\/blog.busbud.com/i

    for element in window.document.getElementsByTagName('*')
      switch element.tagName
        when 'STYLE', 'SCRIPT', 'IFRAME'
          element.parentNode.removeChild(element)
        when 'LINK'
          if (/stylesheet/i).test(element.getAttribute('rel'))
            element.parentNode.removeChild(element)
        when 'A'
          href = element.getAttribute('href')
          if localLinkRxp.test(href)
            element.setAttribute('href', href.replace(localLinkRxp, '/blog'))
          if href.indexOf('/') == 0
            element.setAttribute('href', '/blog' + href)

      element.removeAttribute('style') if element.getAttribute('style')

    callback(window.document.documentElement.innerHTML)