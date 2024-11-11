Projects/GitTogether:
	@echo "--- [DOCUMENTATION] Installing GitTogether... ---"
	@git clone git@github.com:Evanlab02/GitTogether.git Projects/GitTogether
	@echo "--- [DOCUMENTATION] Installed GitTogether.    ---"

Projects/DockerLens:
	@echo "--- [DOCUMENTATION] Installing DockerLens... ---"
	@git clone git@github.com:Evanlab02/DockerLens.git Projects/DockerLens
	@echo "--- [DOCUMENTATION] Installed DockerLens.    ---"

Projects/ShoppingListApp:
	@echo "--- [DOCUMENTATION] Installing ShoppingListApp... ---"
	@git clone git@github.com:Evanlab02/ShoppingListApp.git Projects/ShoppingListApp
	@echo "--- [DOCUMENTATION] Installed ShoppingListApp.    ---"

Projects/HomePortal:
	@echo "--- [DOCUMENTATION] Installing HomePortal... ---"
	@git clone git@github.com:Evanlab02/HomePortal.git Projects/HomePortal
	@echo "--- [DOCUMENTATION] Installed HomePortal.    ---"

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
install: Projects/GitTogether Projects/DockerLens Projects/ShoppingListApp Projects/HomePortal Projects/My-Docs
	@echo "[DOCUMENTATION] Installed all projects."

.PHONY: update
update:
	@echo "--- [DOCUMENTATION] Updating all projects...    ---"
	@echo "--- [DOCUMENTATION] Updating GitTogether...     ---"
	@cd Projects/GitTogether && git pull
	@echo "--- [DOCUMENTATION] Updating DockerLens...      ---"
	@cd Projects/DockerLens && git pull
	@echo "--- [DOCUMENTATION] Updating ShoppingListApp... ---"
	@cd Projects/ShoppingListApp && git pull
	@echo "--- [DOCUMENTATION] Updating HomePortal...      ---"
	@cd Projects/HomePortal && git pull
	@echo "--- [DOCUMENTATION] Updating My-Docs...         ---"
	@cd Projects/My-Docs && git pull
	@echo "--- [DOCUMENTATION] Updated all projects.       ---"

.PHONY: build-gt
build-gt:
	@echo "--- [GitTogether] Setting up for build... ---"
	@cd Projects/GitTogether/docs && pipenv install --dev
	@echo "--- [GitTogether] Building...             ---"
	@cd Projects/GitTogether/docs && pipenv run mkdocs build
	@echo "--- [GitTogether] Copying...              ---"
	@mv Projects/GitTogether/docs/site web/gt
	@echo "--- [GitTogether] Done.                   ---"

.PHONY: build-dl
build-dl:
	@echo "--- [DockerLens] Setting up for build... ---"
	@cd Projects/DockerLens/docs && pipenv install --dev
	@echo "--- [DockerLens] Building...             ---"
	@cd Projects/DockerLens/docs && pipenv run mkdocs build
	@echo "--- [DockerLens] Copying...              ---"
	@mv Projects/DockerLens/docs/site web/dl
	@echo "--- [DockerLens] Done.                   ---"

.PHONY: build-shopping
build-shopping:
	@echo "--- [ShoppingListApp] Setting up for build... ---"
	@cd Projects/ShoppingListApp/docs && pipenv install --dev
	@echo "--- [ShoppingListApp] Building...             ---"
	@cd Projects/ShoppingListApp/docs && pipenv run mkdocs build
	@echo "--- [ShoppingListApp] Copying...              ---"
	@mv Projects/ShoppingListApp/docs/site web/shopping
	@echo "--- [ShoppingListApp] Done.                   ---"

.PHONY: build-hp
build-hp:
	@echo "--- [HomePortal] Setting up for build... ---"
	@cd Projects/HomePortal/docs && pipenv install --dev
	@echo "--- [HomePortal] Building...             ---"
	@cd Projects/HomePortal/docs && pipenv run mkdocs build
	@echo "--- [HomePortal] Copying...              ---"
	@mv Projects/HomePortal/docs/site web/hp
	@echo "--- [HomePortal] Done.                   ---"

.PHONY: build-my-docs
build-my-docs:
	@echo "--- [My-Docs] Setting up for build... ---"
	@cd Projects/My-Docs && pipenv install --dev
	@echo "--- [My-Docs] Building...             ---"
	@cd Projects/My-Docs && pipenv run make build
	@echo "--- [My-Docs] Copying...              ---"
	@mv Projects/My-Docs/site web/my-docs
	@echo "--- [My-Docs] Done.                   ---"
