MAKEFLAGS += --warn-undefined-variables
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := all
.DELETE_ON_ERROR:
.SUFFIXES:

all : help ;

PHONY_TGTS := help
PHONY_TGTS += jstart jstop jstop-clean jrestart
.PHONY: $(PHONY_TGTS)

help:
	@echo "**** Help ****"
	@grep -E "(^# make|^#\s+-)" Makefile

# make jstart  - starts jenkins
jstart:
	docker-compose up -d

# make jstop  - stops jenkins while keeping the configuration unchanged
jstop:
	docker-compose down

# make jstop-clean  - stops jenkins and delete all the configurations
jstop-clean:
	docker-compose down --volumes

# make jrestart  - restarts jenkins server (force via docker)
jrestart:
	docker-compose restart jenkins-server

# make sshkeys  - creates ssh keys to be use in ssh agent configuration
sshkeys: shared-mnt/jenkins-agent-ssh
	@:

shared-mnt/jenkins-agent-ssh shared-mnt/jenkins-agent-ssh.pub &:
	ssh-keygen -f shared-mnt/jenkins-agent-ssh -q -N ""

