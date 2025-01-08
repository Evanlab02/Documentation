# Quick Start

To create a caddy container we can use to explore caddy, we can use the following compose file:

```yaml
services:
  caddy:
    image: caddy:2.8.4-alpine
    container_name: caddy-container
    ports:
      - "80:80"
    networks:
      - caddy-network

networks:
  caddy-network:
    driver: bridge
```

To start the containers, we can run the following command:

```bash
docker compose up -d
```

To access the caddy CLI, we can run the following command:

```bash
docker exec -it postgres-container caddy --help
```