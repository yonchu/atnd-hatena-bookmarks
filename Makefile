.PHONY: clean

COFFEE=coffee
UGLIFYJS=uglifyjs
BOOKMARKLET=./bookmarklet.sh

all: atnd-hatebu.user.js atnd-hatebu-min.bookmarklet.js


atnd-hatebu.user.js: atnd-hatebu.user.coffee
	$(COFFEE) -c $^


atnd-hatebu-min.bookmarklet.js: atnd-hatebu-min.user.min.js
	$(BOOKMARKLET) $^ $@
	rm -f $^

atnd-hatebu-min.user.min.js: atnd-hatebu-min.user.js
	$(UGLIFYJS) -m -o $@ $^

atnd-hatebu-min.user.js: atnd-hatebu-min.user.coffee
	$(COFFEE) -c $^


clean:
	rm -f *.js
