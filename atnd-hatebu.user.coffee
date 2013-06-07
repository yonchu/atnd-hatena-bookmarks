###
// ==UserScript==
// @name           ATND Hatena Bookmarks
// @author         Yonchu
// @homepage       http://yonchu.hatenablog.com/
// @namespace      http://yonchu.hatenablog.com/
// @description    Show Hatena Bookmarks of articles in ATND
// @license        MIT License (http://opensource.org/licenses/MIT)
// @version        1.0.0
// @include        http://atnd.org/events/*
// @released       2013-06-07
// @updated        2013-06-07
// @compatible     Greasemonkey
// ==/UserScript==
// Version History:
//   1.0.0 - 2013/06/07 Release
###


# Ignore iframe.
try
  if top isnt self
    throw 0
catch error
  return

# Add CSS style.
addStyle = (css) ->
  if GM_addStyle?
    GM_addStyle(css)
    return
  style = document.createElement 'style'
  style.setAttribute 'type', 'text/css'
  style.setAttribute 'media', 'screen'
  style.appendChild (document.createTextNode css)
  head = document.getElementsByTagName('head')[0]
  head.appendChild style

# Create hatena bookmark img tag.
createHatebu = do ->
  hatebuUrl = 'http://b.hatena.ne.jp/entry/image/'
  img_cache = document.createElement 'img'
  img_cache.className = 'hatebu'
  return (url) ->
    img = img_cache.cloneNode()
    img.setAttribute 'src', hatebuUrl + url
    return img


## Main

# CSS.
css = '.hatebu{padding-bottom: 2px !important; margin-left: 5px !important;}'
addStyle css

# Hatena Bookmarks.
trTags = document.querySelectorAll '#post-body table tr'
for tr in trTags
  anchor = null
  for td in tr.children
    child = td.firstChild
    unless child
      continue
    tagName = child.tagName
    unless tagName and tagName is 'a' or tagName is 'A'
      continue
    anchor = child
    break
  unless anchor
    # console.info "Empty item:", tr
    continue
  url = anchor.href
  unless url
    # console.error "URL not found:", tr
    continue
  img = createHatebu url
  td.appendChild img
