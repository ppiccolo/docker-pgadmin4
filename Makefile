
NAME = ppiccolo/pgadmin4
VERSION = 1.2

.PHONY: all build run tag_latest release

all: build

build:
	docker build -t $(NAME):$(VERSION) .

run:
	docker run --rm -it -p 5999:5999 -v `pwd`/.pgadmin4:/data $(NAME):$(VERSION)

tag_latest:
	docker tag $(NAME):$(VERSION) $(NAME):latest

release: tag_latest
	@if ! docker images $(NAME) | awk '{ print $$2 }' | grep -q -F $(VERSION); then echo "$(NAME) version $(VERSION) is not yet built. Please run 'make build'"; false; fi
	@if ! head -n 1 Changelog.md | grep -q 'release date'; then echo 'Please note the release date in Changelog.md.' && false; fi
	docker push $(NAME)
	@echo "*** Don't forget to create a tag. git tag rel-$(VERSION) && git push origin rel-$(VERSION)"