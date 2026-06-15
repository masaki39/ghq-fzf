.PHONY: run patch minor major _bump

# Strip custom env vars; keep only what fzf/ghq/eza need
# Note: cd after repo selection won't persist (runs in subprocess)
CLEAN_ENV = env -i \
	HOME="$$HOME" \
	PATH="$$PATH" \
	TERM="$$TERM" \
	TMPDIR="$$TMPDIR" \
	LANG="$$LANG" \
	COLORTERM="$$COLORTERM" \
	EDITOR="$$EDITOR"

# Run picker from source in a clean environment
run:
	$(CLEAN_ENV) ./bin/ghq-fzf; true

# Bump version and create a tag (npm-style)
# Then: git push && git push --tags
patch:
	@$(MAKE) -s _bump TYPE=patch

minor:
	@$(MAKE) -s _bump TYPE=minor

major:
	@$(MAKE) -s _bump TYPE=major

_bump:
	@current=$$(git tag -l 'v*' | sort -V | tail -1); \
	current=$${current:-v0.0.0}; \
	current=$${current#v}; \
	maj=$$(echo "$$current" | cut -d. -f1); \
	min=$$(echo "$$current" | cut -d. -f2); \
	pat=$$(echo "$$current" | cut -d. -f3); \
	case "$(TYPE)" in \
	  patch) pat=$$((pat + 1)) ;; \
	  minor) min=$$((min + 1)); pat=0 ;; \
	  major) maj=$$((maj + 1)); min=0; pat=0 ;; \
	esac; \
	next="v$$maj.$$min.$$pat"; \
	git tag "$$next"; \
	echo "$$next"; \
	echo "Next: git push && git push --tags"
