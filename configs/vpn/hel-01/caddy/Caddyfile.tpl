{
	email ${ACME_EMAIL}
}

${SERVER_ADDRESS} {
	basicauth {
		${CADDY_USER} ${CADDY_HASH}
	}
	root * /srv/configs
	file_server
}
