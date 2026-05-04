NAME	 := pexpo
TARGET	 := bin/$(NAME)
VERSION  := 1.41
DIST_DIRS := find * -type d -exec

SRCS	:= $(shell find . -type f -name '*.go')
LDFLAGS := -ldflags="-s -w -X \"main.version=$(VERSION)\""

$(TARGET): $(SRCS)
	mkdir -p bin
	go build -mod=vendor $(LDFLAGS) -o bin/$(NAME)

.PHONY: install
install:
	go install -mod=vendor $(LDFLAGS)

.PHONY: wash
wash:
	rm -rf bin/*
	rm -rf dist/*

.PHONY: clean
clean:
	rm -rf bin/*
	rm -rf dist/*

.PHONY: cross-build
cross-build:
	for os in darwin linux windows; do \
		for arch in amd64 386; do \
			mkdir -p dist/$(NAME)-$$os-$$arch; \
			GOOS=$$os GOARCH=$$arch go build -mod=vendor $(LDFLAGS) -o dist/$(NAME)-$$os-$$arch/$(NAME); \
		done; \
	done

.PHONY: dist
dist:
	cd dist && \
	$(DIST_DIRS) cp ../LICENSE {} \; && \
	$(DIST_DIRS) cp ../README.md {} \; && \
	$(DIST_DIRS) cp ../ping-list.txt {} \; && \
	$(DIST_DIRS) cp ../curl-list.txt {} \; && \
	$(DIST_DIRS) tar -zcf $(NAME)-$(VERSION)-{}.tar.gz {} \; && \
	$(DIST_DIRS) zip -r $(NAME)-$(VERSION)-{}.zip {} \; && \
	cd ..