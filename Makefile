SHELL := bash

ROOT_DIR := $(shell cd -- "$( dirname -- "$0" )" &> /dev/null && pwd)
ENV_DIR := $(ROOT_DIR)/.environment
MINICONDA_SCRIPT := $(ENV_DIR)/Miniconda.sh
INSTALL_PATH := $(ENV_DIR)/miniconda
MINICONDA_BIN := $(INSTALL_PATH)/bin
CONDA_COMMAND := $(MINICONDA_BIN)/conda
PIP_COMMAND := $(MINICONDA_BIN)/pip

ifeq ($(shell uname), Darwin)
	DL_LINK := "https://repo.anaconda.com/miniconda/Miniconda3-latest-MacOSX-x86_64.sh"
else
	ifeq ($(bash uname), Linux)
		DL_LINK := "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh"
	else
		@echo "Sorry, only Linux and MacOS are currently supported"
	endif
endif

.PHONY: all setup_env activate_miniconda uninstall restart_bash

all: setup_env
	@echo "==> For changes to take effect, close and re-open your current shell. <=="

setup_env: activate_miniconda
	@echo "4. Installing dependencies <<"
	$(PIP_COMMAND) install --upgrade pip
	$(PIP_COMMAND) install -r requirements.txt

activate_miniconda: $(CONDA_COMMAND)
	@echo "3. Miniconda activation <<"
	$(CONDA_COMMAND) init --all;
	make restart_bash

$(CONDA_COMMAND): $(MINICONDA_SCRIPT)
	@echo "2. Running miniconda script <<"
	sh $(MINICONDA_SCRIPT) -b -p $(INSTALL_PATH)

$(MINICONDA_SCRIPT):
	@echo "0. For Apple processor you need to run 'softwareupdate --install-rosetta'"
	@echo "1. Loading miniconda script <<"
	mkdir -p $(ENV_DIR)
	curl -Lo $(MINICONDA_SCRIPT) $(DL_LINK)

uninstall:
	rm -rf $(MINICONDA_SCRIPT)
	rm -rf $(INSTALL_PATH)
	
	@echo "==> For changes to take effect, close and re-open your current shell. <=="

restart_bash:
	@if [ -f /etc/bashrc ]; then source /etc/bashrc; fi
	@if [ -f ~/.bashrc ]; then source ~/.bashrc; fi