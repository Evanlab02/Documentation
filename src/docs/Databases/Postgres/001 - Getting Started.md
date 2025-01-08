# Quick Start

To create a postgres container we can use to explore postgres, we can use the following compose file:

```yaml
services:
  postgres:
    image: postgres:17.2-alpine3.21
    container_name: postgres-container
    ports:
      - "5432:5432"
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: postgres
      POSTGRES_DB: my-db
    volumes:
      - postgres-data:/var/lib/postgresql/data
    networks:
      - postgres-network

volumes:
  postgres-data:
    external: false

networks:
  postgres-network:
    driver: bridge
```

To start the containers, we can run the following command:

```bash
docker compose up -d
```

To access the postgres CLI, we can run the following command:

```bash
docker exec -it postgres-container psql -U postgres
```
