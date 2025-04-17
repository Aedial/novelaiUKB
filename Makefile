COMMAND = pandoc
FILTERS = $(foreach filter,$(wildcard filters/*.lua),--lua-filter $(filter))
CSS = $(foreach css,$(wildcard css/*.css),--metadata css=$(css))
ARGS = --from gfm --to html5+smart --standalone $(FILTERS) $(CSS) --toc --template template
BUILD_DIR = build

SRC_DIR_EN = docs
SRC_DIR_JP = docs_jp

EN_FILES = $(patsubst $(SRC_DIR_EN)/%.md,$(BUILD_DIR)/en/%.html,$(wildcard $(SRC_DIR_EN)/*.md))
JP_FILES = $(patsubst $(SRC_DIR_JP)/%.md,$(BUILD_DIR)/jp/%.html,$(wildcard $(SRC_DIR_JP)/*.md))

all: $(EN_FILES) $(JP_FILES) Makefile

# Redirect $(1) to $(2)
define redirect
	echo '<!DOCTYPE html><html><head><meta http-equiv="refresh" content="0; url=$(2)"></head></html>' > $(1)
endef

# Build the English version and redirect / to /en/
$(BUILD_DIR)/en/%.html: $(SRC_DIR_EN)/%.md | build_dir
	$(eval FILENAME := $(patsubst $(SRC_DIR_EN)/%.md,%,$<))

	$(COMMAND) $(ARGS) \
	--metadata title="$(subst -, ,$(FILENAME))" \
	--metadata date=$(shell git log -n 1 --pretty=format:%ct -- "$<") \
	"$<" --output "$@"

	$(call redirect,$(BUILD_DIR)/$(FILENAME).html,en/$(FILENAME).html)
	@echo ""


# Build the Japanese version
$(BUILD_DIR)/jp/%.html: $(SRC_DIR_JP)/%.md | build_dir
	$(eval FILENAME := $(patsubst $(SRC_DIR_EN)/%.md,%,$<))

	$(COMMAND) $(ARGS) \
	--metadata title="$(subst -, ,$(FILENAME))" \
	--metadata date=$(shell git log -n 1 --pretty=format:%ct -- "$<") \
	"$<" --output "$@"
	@echo ""

build_dir:
	@mkdir -p $(BUILD_DIR)
	@mkdir -p $(BUILD_DIR)/en
	@mkdir -p $(BUILD_DIR)/jp

clean:
	@rm -rf $(BUILD_DIR)
