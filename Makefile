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

# make jstart  - starts jenkins (this sets the required environment var JENKINS_AGENT_SSH_PUBKEY)
jstart: sshkeys
	JENKINS_AGENT_SSH_PUBKEY="$(shell cat shared-mnt/jenkins-agent-ssh.pub)" \
	docker-compose up -d

# make jstop  - stops jenkins while keeping the configuration unchanged
jstop:
	JENKINS_AGENT_SSH_PUBKEY=not_needed_for_stop \
	docker-compose down

# make jstop-clean  - stops jenkins and delete all the configurations
jstop-clean:
	JENKINS_AGENT_SSH_PUBKEY=not_needed_for_stop \
	docker-compose down --volumes

# make jrestart-server  - restarts jenkins server (force via docker)
jrestart-server:
	JENKINS_AGENT_SSH_PUBKEY=not_needed_for_server \
	docker-compose restart jenkins-server

# make sshkeys  - creates ssh keys to be use in ssh agent configuration
sshkeys: shared-mnt/jenkins-agent-ssh
	@:

shared-mnt/jenkins-agent-ssh shared-mnt/jenkins-agent-ssh.pub &:
	ssh-keygen -f shared-mnt/jenkins-agent-ssh -q -N ""

