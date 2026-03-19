{
	auto_https off
}

${DOMAIN} {
	basicauth {
		${CADDY_USER} ${CADDY_HASH}
	}
	root * /srv/configs
	file_server
}
