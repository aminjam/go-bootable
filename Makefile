GOTOOLS = github.com/mitchellh/gox \
	  golang.org/x/tools/cmd/stringer \
	  github.com/FiloSottile/gvt \
	  github.com/axw/gocov/gocov \
	  gopkg.in/matm/v1/gocov-html \
	  golang.org/x/tools/cmd/vet
VETARGS?=-asmdecl -atomic -bool -buildtags -copylocks -methods \
	 -nilfunc -printf -rangeloops -shift -structtags -unsafeptr

PACKAGES=$(shell go list ./... | grep -v vendor | sort | uniq)

BINARY_NAME=$(shell basename ${PWD})
MAIN_PACKAGE="."

all: format test deps build-dist

build: generate
	@$(CURDIR)/scripts/build.bash $(BINARY_NAME) $(MAIN_PACKAGE) dev

build-dist: generate
	@$(CURDIR)/scripts/build.bash $(BINARY_NAME) $(MAIN_PACKAGE)

cov:
	@echo "--> Running test coverage"
	@gocov test ./... | gocov-html > /tmp/coverage.html
	@open /tmp/coverage.html

clean:
	@find . -type f -name '.DS_Store' -delete

deps: orphan-deps
	@echo "--> Rebuilding dependencies"
	@go get -v $(GOTOOLS)
	@gvt rebuild

format:
	@echo "--> Running go fmt"
	@go fmt $(PACKAGES)

generate:
	@echo "--> Running generate"
	@go generate ./...

test:
	@echo "--> Running Tests"
	$(MAKE) vet
	@go test $(PACKAGES)

orphan-deps:
	@echo "--> Checking orphan dependencies"
	@$(CURDIR)/scripts/deps.bash orphan

update-deps: deps
	@echo "--> Updating dependencies"
	@gvt update --all

vet:
	@echo "--> Rnning go lint"
	@test -z "$$(golint ./... | tee /dev/stderr)"
	@echo "--> Running go tool vet $(VETARGS) ./..."
	@go tool vet $(VETARGS) . ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for reviewal."; \
		fi

.PHONY: all build build-dist cov deps format generate test orphan-deps update-deps vet

