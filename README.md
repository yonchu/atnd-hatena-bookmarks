ATND Hatena Bookmarks
---------------------

[Vim Advent Calendar 2012](http://atnd.org/events/33746) に はてなブックマーク数 を表示するための Greasemonkey と Bookmarklet です。

Vim Advent Calendar 以外にも同様のレイアウト使用していれば、他のATNDイベントでも使用することができます。

![screenshot01](https://raw.github.com/yonchu/atnd-hatena-bookmarks/master/img/screenshot01.png)

注意: ランキング表示は、Greasemonkey版でのみ対応しています。

## Installation

### Greasemonkey版

以下のスクリプトをダウンロードし、使用ブラウザに応じてインストールして下さい。

- [ATND Hatena Bookmarks (Greasemonkey版)](https://github.com/yonchu/atnd-hatena-bookmarks/raw/master/atnd-hatebu.user.js)

### ブックマークレット版

以下のリンクをブックマークに追加して下さい。

- <a href='javascript:(function(){var s=document.createElement("script");s.charset="UTF-8";s.src="https://github.com/yonchu/atnd-hatena-bookmarks/raw/master/atnd-hatebu-min.user.js";document.body.appendChild(s)})();' target="_blank">ATND Hatena Bookmarks (ブックマークレット版)</a>

```javascript
javascript:(function(){var s=document.createElement("script");s.charset="UTF-8";s.src="https://github.com/yonchu/atnd-hatena-bookmarks/raw/master/atnd-hatebu-min.user.js";document.body.appendChild(s)})();
```

スクリプトをサーバから読み込まないバージョンを使用したい場合は、以下のリンクをブックマークに追加して下さい。

- <a href='javascript:(function(){var t,e,n,r,a,i,o,d,l,c,u,m,f,h,p,s,y;try{if(top!==self){throw 0}}catch(b){i=b;return}t=function(t){var e,n;if(typeof GM_addStyle!=="undefined"&&GM_addStyle!==null){GM_addStyle(t);return}n=document.createElement("style");n.setAttribute("type","text/css");n.setAttribute("media","screen");n.appendChild(document.createTextNode(t));e=document.getElementsByTagName("head")[0];return e.appendChild(n)};r=function(){var t,e;t="http://b.st-hatena.com/entry/image/";e=document.createElement("img");e.className="hatebu";return function(n){var r;r=e.cloneNode();r.setAttribute("src",t+n);return r}}();a=".hatebu{padding-bottom: 2px !important; margin-left: 5px !important;}";t(a);u=document.querySelectorAll("#post-body table tr");for(f=0,p=u.length;f<p;f++){c=u[f];e=null;y=c.children;for(h=0,s=y.length;h<s;h++){l=y[h];n=l.firstChild;if(!n){continue}d=n.tagName;if(!(d&&d==="a"||d==="A")){continue}e=n;break}if(!e){continue}m=e.href;if(!m){continue}o=r(m);l.appendChild(o)}})();' target="_blank">ATND Hatena Bookmarks (ブックマークレット版 - 非サーバ読み込み))</a>

```javascript
javascript:(function(){var t,e,n,r,a,i,o,d,l,c,u,m,f,h,p,s,y;try{if(top!==self){throw 0}}catch(b){i=b;return}t=function(t){var e,n;if(typeof GM_addStyle!=="undefined"&&GM_addStyle!==null){GM_addStyle(t);return}n=document.createElement("style");n.setAttribute("type","text/css");n.setAttribute("media","screen");n.appendChild(document.createTextNode(t));e=document.getElementsByTagName("head")[0];return e.appendChild(n)};r=function(){var t,e;t="http://b.st-hatena.com/entry/image/";e=document.createElement("img");e.className="hatebu";return function(n){var r;r=e.cloneNode();r.setAttribute("src",t+n);return r}}();a=".hatebu{padding-bottom: 2px !important; margin-left: 5px !important;}";t(a);u=document.querySelectorAll("#post-body table tr");for(f=0,p=u.length;f<p;f++){c=u[f];e=null;y=c.children;for(h=0,s=y.length;h<s;h++){l=y[h];n=l.firstChild;if(!n){continue}d=n.tagName;if(!(d&&d==="a"||d==="A")){continue}e=n;break}if(!e){continue}m=e.href;if(!m){continue}o=r(m);l.appendChild(o)}})();
```

## Usage

詳細は以下のページを参照下さい。

- ブログURL記載予定

## License

ライセンスは、[MITライセンス](http://www.opensource.org/licenses/mit-license.php)に準拠します。
参照元を記載の上、自己責任のもと自由に改変、利用してください。


## Copyright

Copyright (c) 2013 Yonchu.
