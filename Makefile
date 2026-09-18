SCHEME := FantasticalExtension
ARCH := $(shell uname -m)

.DEFAULT_GOAL := build
.PHONY: build release test install install-restart package logs clean

build:
	@./scripts/tuna-extension build --scheme $(SCHEME)

release:
	@./scripts/tuna-extension build --scheme $(SCHEME) --release

test:
	@xcodebuild test -project $(SCHEME)/$(SCHEME).xcodeproj -scheme $(SCHEME) -configuration Debug \
	  -destination "platform=macOS,arch=$(ARCH)" -derivedDataPath ./build/dd/tests CODE_SIGNING_ALLOWED=NO

install:
	@./scripts/tuna-extension install --scheme $(SCHEME)

install-restart:
	@./scripts/tuna-extension install --scheme $(SCHEME) --restart

package:
	@EXTENSIONS_STORE_SIGNING_PRIVATE_KEY_OP= ./scripts/ext-package.sh $(SCHEME) "generic/platform=macOS" "$(CURDIR)/build/dd"

logs:
	@./scripts/tuna-extension logs --last 20m

clean:
	$(RM) -r ./build ./dist
