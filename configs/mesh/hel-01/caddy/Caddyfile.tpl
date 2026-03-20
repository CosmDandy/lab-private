{
	email ${ACME_EMAIL}
}

${SERVER_ADDRESS} {
	handle_path /avatars/* {
		root * /srv/avatars
		file_server
	}

	handle /admin/* {
		basicauth {
			${CADDY_USER} ${CADDY_HASH}
		}
		reverse_proxy headplane:3000
	}

	handle /health/* {
		basicauth {
			${CADDY_USER} ${CADDY_HASH}
		}
		reverse_proxy headscale:9090
	}

	handle {
		reverse_proxy headscale:8080 {
			flush_interval -1
		}
	}
}
