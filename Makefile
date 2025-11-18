MODULES = aai-common schema-service resources traversal graphadmin logging-service
NEW_VERSION = 0.0.1-TEST-SNAPSHOT
LOG_FILE = log.txt

.PHONY: all build clean log

all: build

build:
	@echo "=== Building AAI Modules ==="
	@for f in $(MODULES); do \
		echo ""; \
		echo ">>> Building module: $$f"; \
		( cd $$f && \
		  mvn versions:set -DnewVersion=$(NEW_VERSION) && \
		  mvn -DskipTests clean install -Daai.schema.version=$(NEW_VERSION) ); \
	done | tee $(LOG_FILE) 2>&1
	@echo "=== Build Completed ==="

log:
	@echo "=== Build Result Summary ==="
	@grep -e "SUCCESS" -e "FAILURE" $(LOG_FILE)

clean:
	@echo "Cleaning all module targets..."
	@for f in $(MODULES); do \
		( cd $$f && mvn clean ); \
	done
