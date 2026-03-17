{
	email ${ACME_EMAIL}
}

${VPN_DOMAIN} {
	basicauth {
		${CADDY_VPN_USER} ${CADDY_VPN_HASH}
	}
	root * /srv/singbox
	file_server
}

${MESH_DOMAIN} {
	handle_path /avatars/* {
		root * /srv/avatars
		file_server
	}

	handle /admin/* {
		basicauth {
			${CADDY_MESH_USER} ${CADDY_MESH_HASH}
		}
		reverse_proxy localhost:3000
	}

	handle /health/* {
		basicauth {
			${CADDY_MESH_USER} ${CADDY_MESH_HASH}
		}
		reverse_proxy localhost:9090
	}

	handle {
		reverse_proxy localhost:8080 {
			flush_interval -1
		}
	}
}
