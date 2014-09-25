coffee_files := $(wildcard js/*.coffee)
js_files     := $(coffee_files:%.coffee=%.js)

js: $(js_files)

%.js: %.coffee
	coffee -c $<
