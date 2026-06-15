.PHONY: run release

# Strip custom env vars; keep only what fzf/ghq/eza need
CLEAN_ENV = env -i \
	HOME="$$HOME" \
	PATH="$$PATH" \
	TERM="$$TERM" \
	TMPDIR="$$TMPDIR" \
	LANG="$$LANG" \
	COLORTERM="$$COLORTERM"

# Run picker from source in a clean environment
run:
	$(CLEAN_ENV) ./bin/ghq-fzf; true

# Tag and push a release (asks for manual verification first)
# Usage: make release VERSION=x.x.x
release:
	@if [ -z "$(VERSION)" ]; then echo "Usage: make release VERSION=x.x.x"; exit 1; fi
	@echo "=== Verify: running picker in clean environment — exit when done ==="
	@$(CLEAN_ENV) ./bin/ghq-fzf; true
	@printf "Proceed with v$(VERSION) release? [y/N]: " && read ans && { [ "$$ans" = y ] || [ "$$ans" = Y ]; }
	git tag v$(VERSION)
	git push origin main v$(VERSION)
	@echo "=== v$(VERSION) pushed — CI will create the release and update the tap ==="
