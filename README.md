# go-bootable
This is a placeholder for a base go project with opinionated Makefile.

### Tools
* github.com/mitchellh/gox
* golang.org/x/tools/cmd/stringer
* github.com/FiloSottile/gvt
* github.com/onsi/ginkgo/ginkgo
* github.com/onsi/gomega
* github.com/axw/gocov/gocov
* gopkg.in/matm/v1/gocov-html
* golang.org/x/tools/cmd/vet

### Adding a new package
* `gvt fetch <PACKAGE>`: Use gvt fetch in place of `go get` with the same format

### Run
* `make (all)`
* `make build`: Dev Build
* `make cov`: Test coverage Report
* `make dist`: Build all binaries for all combinatinos of (amd64 arm 386) Arch and (darwin freebsd linux windows) OS
* `make deps`: Use `gvt` to manage dependencies
* `make updatedeps`: Update all dependencies
* `make test`: Use ginkgo for tests
* `make vet`: Run go vet tool for suspicious constructs
