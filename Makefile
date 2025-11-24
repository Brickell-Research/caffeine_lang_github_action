# Caffeine Language GitHub Action - Local Testing

.PHONY: test
test:
	docker build -t caffeine-lang-action .
	docker run --rm caffeine-lang-action
