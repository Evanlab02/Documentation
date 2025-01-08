# Getting started with Redis using CSharp

Before we can use Redis, we need to spin up a instance of it. 

We can do this using docker and docker compose.

## Setting up project

To start a basic project, you can do the following:

```bash
dotnet new console -o play-csharp-redis
```

Once your project is created, install the Redis dependency/packages:

```bash
cd play-csharp-redis
dotnet add package StackExchange.Redis
```

## Compose Stack

You can create a `compose.yaml` file that looks like the below to setup Redis:

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

You can start the compose stack with the following command: `docker compose up -d`.

## Code

```csharp
// Program.cs
using StackExchange.Redis;

ConnectionMultiplexer cache = ConnectionMultiplexer.Connect("localhost");
IDatabase cacheDB = cache.GetDatabase();
cacheDB.StringSet("Test", "Value", TimeSpan.FromSeconds(3));

bool exists = cacheDB.KeyExists("Test");
Console.WriteLine(exists);

Thread.Sleep(5000);

exists = cacheDB.KeyExists("Test");
Console.WriteLine(exists);
```

This little script will create a key value pair with an expiry time of 3 seconds and check if it exists right after creation, and then check again after 5 seconds to see if it still exists, which it shouldn't.

The output will look like the following:

```bash
True
False
```

You can run the code with `dotnet run`.
