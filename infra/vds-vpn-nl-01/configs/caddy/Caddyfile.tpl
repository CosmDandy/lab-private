{
	auto_https off
}

${CONFIG_DOMAIN} {
	basicauth {
		${CADDY_CONFIG_USER} ${CADDY_CONFIG_HASH}
	}
	root * /srv/configs
	file_server
}
