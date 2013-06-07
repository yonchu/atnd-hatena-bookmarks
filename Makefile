.PHONY: clean

COFFEE=coffee
UGLIFYJS=uglifyjs
BOOKMARKLET=./bookmarklet.sh

all: atnd-hatebu.user.js atnd-hatebu.min.js atnd-hatebu.bookmarklet.js

atnd-hatebu.user.js: atnd-hatebu.user.coffee
	$(COFFEE) -c atnd-hatebu.user.coffee

atnd-hatebu.min.js: atnd-hatebu.user.js
	$(UGLIFYJS) -m -o $@ $^

atnd-hatebu.bookmarklet.js: atnd-hatebu.min.js
	$(BOOKMARKLET) $^ $@
	rm -f $^

clean:
	rm -f *.js
