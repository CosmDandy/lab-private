{
	email ${ACME_EMAIL}
}

${SERVER_ADDRESS} {
	basic_auth {
		${CADDY_USER} ${CADDY_HASH}
	}
	root * /srv/configs
	file_server
}
