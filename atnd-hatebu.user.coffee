###
// ==UserScript==
// @name           ATND Hatena Bookmarks
// @author         Yonchu
// @homepage       http://yonchu.hatenablog.com/
// @namespace      http://yonchu.hatenablog.com/
// @description    Show Hatena Bookmarks of articles in ATND
// @license        MIT License (http://opensource.org/licenses/MIT)
// @version        1.1.0
// @include        http://atnd.org/events/*
// @released       2013-06-07
// @updated        2013-06-15
// @compatible     Greasemonkey
// ==/UserScript==
// Version History:
//   1.0.0 - 2013/06/07 Release
//   1.0.1 - 2013/06/07 はてブ数取得を新APIに変更
//   1.1.0 - 2013/06/15 ランキング表示
###


# Ignore iframe.
try
  if top isnt self
    throw 0
catch error
  return

## Const values.

MAX_RANK = 10

## Common functions.

# Add CSS style.
addStyle = (css) ->
  if GM_addStyle?
    GM_addStyle css
    return
  style = document.createElement 'style'
  style.setAttribute 'type', 'text/css'
  style.setAttribute 'media', 'screen'
  style.appendChild (document.createTextNode css)
  head = document.getElementsByTagName('head')[0]
  head.appendChild style
  return

createXhr = do ->
  activeXids = [
    'MSXML2.XMLHTTP.3.0'
    'MSXML2.XMLHTTP'
    'Microsoft.XMLHTTP'
  ]
  activeXid = null
  unless XMLHttpRequest?
    # IE7以前
    for ax in activeXids
      try
        new ActiveXObject ax
        activeXid = ax
        break
  return ->
    if activeXid
      xhr = new ActiveXObject ax
    else
      xhr = new XMLHttpRequest
    return xhr

# XMLHttpRequest.
httpRequest = (url, callback) ->
  if GM_xmlhttpRequest?
    GM_xmlhttpRequest
      method: 'GET'
      url: url
      onload: (response) ->
        callback response.responseText
        return
    return
  xhr = createXhr()
  xhr.onreadystatechange = ->
    if xhr.readyState isnt 4
      return false
    if xhr.status isnt 200
      alert "Error, status code: #{xhr.status}"
      return false
    callback xhr.responseText
    return
  xhr.open 'GET', url, true
  xhr.send()
  return

detectRedirectUrl = (url, callback) ->
  unless GM_xmlhttpRequest? and url.match /http:\/\/d.hatena.ne.jp/
    setTimeout(->
      callback url
    , 0)
    return
  GM_xmlhttpRequest
    method: 'GET'
    url: url
    onload: (response) ->
      finalUrl = url
      if navigator.userAgent.match /firefox/i
        if response.finalUrl
          finalUrl = response.finalUrl
      else
        m = response.responseText.match /<link rel="canonical" href="(.*)"\/>/
        if m and m.length >= 2
          finalUrl = m[1]
      callback finalUrl
      return

# textContent for DOM Element.
# With one argument, return the textContent or innerText of the element.
# With two arguments, set the textContent or innerText of element to value.
textContent = (element, value) ->
  # Check if textContent is defined.
  content = element.textContent
  if value?
    if content?
      element.textContent = value
    else
      element.innerText = value
  else
    return content if content?
    return element.innerText

# Shallow copy.
extend = (parent, child) ->
  child = child or {}
  for own key, val of parent
    child[key] = val
  return child

## Main

# CSS.
css = """
.hatebu {
  font-size: 90%;
  color: #F00;
  background-color: #FCC;
  padding: 0px 3px 2px 3px !important;
  font-weight: bold;
  text-decoration: underline;
  margin-left: 8px !important;
}
#hatebu-rank td{
  border: none;
  padding-bottom: 15px;
}
#hatebu-rank td span:nth-of-type(1){
  margin-left: 2px !important;
}
#hatebu-rank td:first-child{
  white-space: nowrap;
  padding: 5px 15px 0px 0px;
  font-size: 150%;
  text-align: right;
}
#hatebu-rank tr:nth-child(1) td:first-child{
  font-size: 250%;
}
#hatebu-rank tr:nth-child(2) td:first-child{
  font-size: 200%;
}
#hatebu-rank tr:nth-child(3) td:first-child{
  font-size: 200%;
}
#hatebu-rank tr:nth-child(1) td:nth-child(2){
  font-size: 150%;
}
#hatebu-rank tr:nth-child(2) td:nth-child(2){
  font-size: 120%;
}
#hatebu-rank tr:nth-child(3) td:nth-child(2){
  font-size: 120%;
}
"""
addStyle css


## Hatena Bookmarks.

# Create hatena bookmark img tag.
createHatebuImage = do ->
  hatebuUrl = 'http://b.st-hatena.com/entry/image/'
  img_cache = document.createElement 'img'
  img_cache.className = 'hatebu'
  return (url) ->
    img = img_cache.cloneNode()
    img.setAttribute 'src', hatebuUrl + url
    return img

# Create hatena bookmark text tag.
createHatebuText = do ->
  span_cache = document.createElement 'span'
  span_cache.className = 'hatebu'
  return (count) ->
    span = span_cache.cloneNode()
    textContent span, "#{count} users"
    return span

# Show hatena bookmark count with image tag.
showHatebuImage = (url, parent) ->
  hatebu = createHatebuImage url
  parent.appendChild hatebu

# Show hatena bookmark count with text.

remainCount = 0
articles = []

showHatebuText = (parent, param) ->
  remainCount += 1
  detectRedirectUrl param.url, (finalUrl) ->
    reqUrl = 'http://api.b.st-hatena.com/entry.count?url=' + encodeURIComponent finalUrl
    httpRequest reqUrl, (response) ->
      article = extend param
      if response
        hatebu = parseInt response, 10
        unless isNaN hatebu
          elem = createHatebuText hatebu
          parent.appendChild elem
          article.hatebuTag = elem.cloneNode true
          article.hatebu = hatebu
          articles.push article
      remainCount -= 1
      if remainCount <= 0
        showRanking articles

# Show hatena bookmark ranking.
showRanking = (articles) ->
  if location.href isnt 'http://atnd.org/events/33746'
    return
  unless GM_xmlhttpRequest?
    return
  articles.sort (a, b) ->
    return -1 if a.hatebu > b.hatebu
    return 1 if a.hatebu < b.hatebu
    return 0
  table = document.createElement 'table'
  table.id = 'hatebu-rank'
  tbody = document.createElement 'tbody'
  rank = 1
  for article in articles
    if rank > MAX_RANK
      break
    tr = document.createElement 'tr'
    td = document.createElement 'td'
    textContent td, rank + '位'
    tr.appendChild td
    td = document.createElement 'td'
    nameTag = document.createElement 'span'
    textContent nameTag, article.name
    td.appendChild article.atag
    td.appendChild nameTag
    td.appendChild article.hatebuTag
    tr.appendChild td
    rank += 1
    tbody.appendChild tr
  table.appendChild tbody
  h2 = document.createElement 'h2'
  textContent h2, 'はてなブックマークランキング'
  pos = document.querySelectorAll('#post-body > h2')[3]
  pos.parentNode.insertBefore h2, pos
  pos.parentNode.insertBefore table, pos
  articles = null

findAnchorTag = (elem) ->
  child = elem.firstChild
  unless child
    return null
  tagName = child.tagName
  unless tagName and tagName is 'a' or tagName is 'A'
    return null
  return child

showHatenaBoookmarks = ->
  trTags = document.querySelectorAll '#post-body table tr'
  for tr in trTags
    anchor = null
    tdNum = 0
    for td in tr.children
      tagName = td.tagName
      unless tagName and (tagName is 'td' or tagName is 'TD')
        continue
      tdNum += 1
      if tdNum is 1
        ndays = parseInt (textContent td), 10
      if tdNum is 3
        name = textContent td
      if tdNum is 4
        anchor = findAnchorTag td
        if anchor?.href
          url = anchor.href
          title = textContent anchor
          pram =
            ndays: ndays
            name: name
            title: title
            url: url
            atag: anchor.cloneNode true
          showHatebuText td, pram

showHatenaBoookmarks()
