# Quick Start

To create a redis container we can use to explore redis, we can use the following compose file:

```yaml
services:
  redis:
    image: redis:7.4.1-alpine3.20
    container_name: redis-container
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    networks:
      - redis-network

volumes:
  redis-data:
    external: false

networks:
  redis-network:
    driver: bridge
```

To start up the container:

```bash
docker compose up -d
```

## Using the redis CLI

```bash
docker exec -it redis-container redis-cli
```

## An alternative

If you would like to use an alternative to redis that is less restrictive with its license, use the below to setup valkey, a fork of redis.

```yaml
services:
  valkey:
    image: valkey/valkey:8.0.1-alpine3.20
    container_name: valkey-container
    ports:
      - "6379:6379"
    volumes:
      - valkey-data:/data
    networks:
      - valkey-network

volumes:
  valkey-data:
    external: false

networks:
  valkey-network:
    driver: bridge
```

```bash
docker compose up -d
docker exec -it valkey-container valkey-cli
```
