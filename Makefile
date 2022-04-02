##############################################################################
# Variables

REALM_NAME := demo
REALM_FILE_TO_EXPORT := $(REALM_NAME)-realm-$(shell date +%s).json


##############################################################################
# Targets

.PHONY: build
build:
	$(MAKE) -C apache-oidc-reverse-proxy build

.PHONY: up
up: up-keycloak
	sleep 30
	docker compose up --detach webapp oidc-reverse-proxy


.PHONY: up-keycloak
up-keycloak:
	if [ "$(REALM_FILE_TO_IMPORT)" ]; then \
		echo "up keycloak with realm file to import"; \
		KEYCLOAK_IMPORT="/$(REALM_NAME)-realm.json" docker compose up --no-start keycloak; \
		docker compose cp "$(REALM_FILE_TO_IMPORT)" "keycloak:/$(REALM_NAME)-realm.json"; \
		docker compose start keycloak; \
	else \
		echo "up keycloak without realm file to import"; \
		docker compose up --detach keycloak; \
	fi


.PHONY: down
down:
	@docker compose down


# see
#   https://hub.docker.com/r/jboss/keycloak/
#   https://www.keycloak.org/docs/16.1/server_admin/#assembly-exporting-importing_server_administration_guide
.PHONY: export-realm
export-realm:
	docker compose exec keycloak /opt/jboss/keycloak/bin/standalone.sh \
		-Djboss.socket.binding.port-offset=100 \
		-Dkeycloak.migration.action=export \
		-Dkeycloak.migration.provider=singleFile \
		-Dkeycloak.migration.realmName=$(REALM_NAME) \
		-Dkeycloak.migration.usersExportStrategy=REALM_FILE \
		-Dkeycloak.migration.file=/tmp/$(REALM_FILE_TO_EXPORT)

	docker compose cp keycloak:/tmp/$(REALM_FILE_TO_EXPORT) $(REALM_FILE_TO_EXPORT)
