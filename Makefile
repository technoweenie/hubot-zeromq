test:
	@find test -name '*_test.coffee' | xargs -n 1 -t coffee

VERSION = $(shell coffee npm-version.coffee)
publish:
	git commit --allow-empty -a -m "release $(VERSION)"
	git tag v$(VERSION)
	git push origin master
	git push origin v$(VERSION)
	npm publish

.PHONY: all

