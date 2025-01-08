Projects/My-Docs:
	@echo "--- [DOCUMENTATION] Installing My-Docs... ---"
	@git clone git@github.com:Evanlab02/My-Docs.git Projects/My-Docs
	@echo "--- [DOCUMENTATION] Installed My-Docs.    ---"

.PHONY: uninstall
uninstall:
	@echo "--- [DOCUMENTATION] Uninstalling all projects... ---"
	@rm -rf Projects/*
	@echo "--- [DOCUMENTATION] Uninstalled all projects.  ---"

.PHONY: install
install: Projects/My-Docs
	@echo "--- [DOCUMENTATION] Installed all projects."

.PHONY: update
update: install
	@echo "--- [DOCUMENTATION] Updating all projects...    ---"
	@echo "--- [DOCUMENTATION] Updating My-Docs...         ---"
	@cd Projects/My-Docs && git pull
	@echo "--- [DOCUMENTATION] Updated all projects.       ---"

.PHONY: build
build:
	@echo "--- [DOCUMENTATION] Cleaning previous build...                      ---"
	@rm -rf src/docs
	@rm -rf src/Makefile
	@rm -rf src/prep.py
	@rm -rf src/md.py
	@rm -rf src/pyproject.toml
	@rm -rf src/uv.lock
	@rm -rf src/requirements.txt
	@rm -rf src/mkdocs.yaml
	@rm -rf src/site
	@echo "--- [DOCUMENTATION] Copying files...                                ---"
	@cd Projects/My-Docs && make pre-build
	@cp -r Projects/My-Docs/docs src/docs
	@cp -r Projects/My-Docs/prep.py src/prep.py
	@cp -r Projects/My-Docs/md.py src/md.py
	@cp -r Projects/My-Docs/pyproject.toml src/pyproject.toml
	@cp -r Projects/My-Docs/uv.lock src/uv.lock
	@cp -r Projects/My-Docs/requirements.txt src/requirements.txt
	@echo "--- [DOCUMENTATION] Installing dependencies...                      ---"
	@cd src && uv sync
	@echo "--- [DOCUMENTATION] Creating mkdocs config...                       ---"
	@cd src && uv run python prep.py
	@echo "--- [DOCUMENTATION] Converting obsidian notes to markdown format... ---"
	@cd src && uv run python md.py
	@echo "--- [DOCUMENTATION] Done.                                           ---"
