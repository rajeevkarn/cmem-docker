.PHONY: stop docker check-env
default: help;

# git investigation
export GITBRANCH=$(shell git rev-parse --abbrev-ref HEAD)
export PUBLIC_PORT=80
ifneq ($(PORT),)
	export PUBLIC_PORT=$(PORT)
endif

export DESTINATION=$(shell echo ${PWD})
ifneq ($(DEST),)
	export DESTINATION=$(DEST)
endif

export DEPLOY_HOST=docker.local
ifneq ($(DEPLOYHOST),)
	export DEPLOY_HOST=$(DEPLOYHOST)
endif

export DEPLOY_PROTOCOL=http
ifneq ($(DEPLOYPROTOCOL),)
	export DEPLOY_PROTOCOL=$(DEPLOYPROTOCOL)
endif

export DEPLOY_BASE_URL=$(shell echo "${DEPLOY_PROTOCOL}://${DEPLOY_HOST}")
DOCKER_CMD_ADD?=
export CMD=$(shell which docker-compose)${DOCKER_CMD_ADD}
ifeq ($(CMD),)
	export CMD=/usr/local/bin/docker-compose
endif

DOCKER_LOCAL?=$(shell echo ${DOCKER_HOST} | cut -d ':' -f 2 | cut -c3-)
DOCKER_LOCAL_HOST=${DOCKER_LOCAL}
ifeq ('$(shell echo ${DOCKER_LOCAL} | grep -n -E "^([0-9]{1,3}[\.]){3}[0-9]{1,3}$$" > /dev/null; echo $$?)',"1")
DOCKER_LOCAL_HOST=`host ${DOCKER_LOCAL} | grep has\ address | head -n1 | grep -oE "([0-9]{1,3}[\.]){3}[0-9]{1,3}"`
endif

ifneq ($(ECC_HOST),)
	export DOCKER_CERT_PATH=$(HOME)/.config/ssl/docker-eccenca
	export DOCKER_HOST=tcp://${ECC_HOST}.eccenca.com:2375
	export DOCKER_TLS_VERIFY=true
endif

##custom vars
### timeout
export MAX=60

PROJECT_NAME ?= ${DEPLOY_HOST}
export COMPOSE_PROJECT_NAME=$(shell echo "${PROJECT_NAME}" | sed -e 's/[^a-zA-Z0-9]*//g')


# list of all need restore targets, to restore service related data
RESTORE-TARGETS=stardog-restore dataintegration-restore

DATABASE = ""
VERSION = ""
export PERSIST_BACKUPS=true

## start the docker orchestration and import a minimal example dataset
start: stardog-volume-create up
	STATE=2018-04-cmem-data make restore-backup
	@echo "Finished starting orchestration"
	@echo "Use 'make logs' to see logging output of all containers"

## start the docker orchestration without importing data
up: check-env
	${CMD} up -d "dummy_startup_blocker"
	${CMD} logs --tail="all" --follow dummy_startup_blocker

# creates the persistant volume for stardog data
stardog-volume-create:
	docker volume create --name=stardog-data

# deletes the persistant volume for stardog data
stardog-volume-delete:
	docker volume rm stardog-data

## follow the log output of all containers
logs: check-env
	${CMD} logs --tail="all" --follow

## stop the docker orchestration
stop: check-env
	${CMD} stop

## kill the docker orchestration
kill: check-env
	${CMD} kill

## shutdown the docker orchestration and delete all volumes, orphaned containers and networks
down:
	${CMD} down --volumes --remove-orphans

## clean logs, database files and data dumps
clean: check-env kill stop down
	${CMD} rm -v --force
	rm -f ${DESTINATION}/application.log application.log.*
	rm -f ${DESTINATION}/tempdata
	@echo "Cleaning finished. In order to also remove Stardog's stored data, run the stardog-volume-delete target"

## clean logs, database files and data dumps
dist-clean: clean
	rm -f ${DESTINATION}/data/dataintegration/*

## copy all the data from current dir to `${DEST}`
dist-copy:
	mkdir -p ${DESTINATION}
	cp -fauv ${PWD}/* ${DESTINATION}

## pull the images from the docker registry
pull: check-env
	# artifactory is sometimes down, we try it 5 times before we error
	@for i in 1 2 3 4 5; do ${CMD} pull && break || sleep 15; done

# check the devenv if matching the requirements documentated here (https://confluence.brox.de/display/ECCDEVOPS/Docker#Docker-MacOSX)
check-env:
	@conf/scripts/checkDockerEnvironment.sh

## backup complete showcase (parameter STATE=xxx possible)
backup: backup-clean
	@echo "finished backup"

## backup complete showcase from a backup file (define STATE=xxx otherwise the latest stable backup will be restored)
restore:
	@if [ ! -z ${STATE} ]; then \
		make restore-backup; \
	elif [ `make restore-list | grep 'stable' | wc -l` -gt 0 ]; then \
		export STATE=`make restore-list | grep 'stable' | tail -n 1`; \
		make restore-backup ; \
	else \
		make restore-list; \
	echo "please define STATE (filename without .zip, like STATE=2016-12-22-clean)"; fi

# list all available backups within the data/backups folder
restore-list:
	@echo "the following backups are available"
	@cd data/backups && ls *.zip | cut -d "." -f 1

# restore a backup which matches the name STATE.zip within the data/backups folder
#   all other folders within the data/backups folder will be deleted
#   finally call all RESTORE_TARGETS to resotre several services
restore-backup:
	@if [ -z ${STATE} ]; then \
		echo "no backup found"; exit 1 ; \
	elif [ `make restore-list | grep ${STATE} | wc -l` -eq 1 ]; then \
		echo `make restore-list | grep ${STATE} | wc -l`; \
		echo "restore state: ${STATE}"; \
		rm -rf `find ./data/backups -mindepth 1 -maxdepth 1 -type d`; \
		unzip -o data/backups/${STATE}.zip; \
		make $(RESTORE-TARGETS); \
	else \
		echo "please define STATE (filename without .zip, like STATE=2016-12-22-clean) from the restore-list"; \
		make restore-list; fi

## restores the latest backups of the respective databases (DATABASE=database VERSION=version)
stardog-restore:
	@conf/scripts/deleteDatabases.sh $(DATABASE)
	@conf/scripts/restoreDatabases.sh $(DATABASE) $(VERSION)

## restore all files for dataintegration
dataintegration-restore:
	@conf/scripts/restoreDataIntegration.sh

## trigger reload for dataintegration workspace
dataintegration-reload:
	@conf/scripts/reloadDataIntegration.sh

## show this help screen
help:
	@printf "Available targets: for project ${COMPOSE_PROJECT_NAME}\n\n"
	@awk '/^[a-zA-Z\-\_0-9]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			printf "%-25s %s\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)

