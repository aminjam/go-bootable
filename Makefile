GOTOOLS = github.com/mitchellh/gox \
	  golang.org/x/tools/cmd/stringer \
	  github.com/FiloSottile/gvt \
	  github.com/onsi/ginkgo/ginkgo \
	  github.com/onsi/gomega \
	  github.com/axw/gocov/gocov \
	  gopkg.in/matm/v1/gocov-html \
	  golang.org/x/tools/cmd/vet
VETARGS?=-asmdecl -atomic -bool -buildtags -copylocks -methods \
	 -nilfunc -printf -rangeloops -shift -structtags -unsafeptr
BINARY_NAME=$(shell basename ${PWD})

all: format test dist

build:
	@bash -c "'$(CURDIR)/scripts/build.bash' $(BINARY_NAME) dev"

cov:
	gocov test ./... | gocov-html > /tmp/coverage.html
	open /tmp/coverage.html

dist: generate
	@bash -c "'$(CURDIR)/scripts/build.bash' $(BINARY_NAME)"

deps:
	@echo "--> Installing build dependencies"
	@go get -v $(GOTOOLS)
	@gvt rebuild

format: deps
	@echo "--> Running go fmt"
	@go fmt $(PACKAGES)

generate: deps
	find . -type f -name '.DS_Store' -delete
	go generate ./...

test: deps
	@echo "--> Running Tests"
	@$(MAKE) vet
	@ginkgo -r

updatedeps: deps
	@echo "--> Installing build dependencies"
	@gvt update --all
vet:
	@echo "--> Running go tool vet $(VETARGS) ."
	@go tool vet $(VETARGS) . ; if [ $$? -eq 1 ]; then \
		echo ""; \
		echo "Vet found suspicious constructs. Please check the reported constructs"; \
		echo "and fix them if necessary before submitting the code for reviewal."; \
		fi

.PHONY: all build cov dist deps format generate test updatedeps vet

