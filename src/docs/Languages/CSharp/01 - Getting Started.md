# Getting Started with C# 

To get started with C#, I would highly recommend using docker as it is much simpler to setup then C# itself on your local machine unless you are using visual studio on windows.

## Install dependencies for the .NET runtime

```bash
sudo apt update && sudo apt install ca-certificates libc6 libgcc-s1 libicu74 liblttng-ust1 libssl3 libstdc++6 libunwind8 zlib1g
```

## Installing the .NET SDK

``` bash
sudo apt-get update && sudo apt-get install dotnet-sdk-8.0
```

## Starting a simple C# project

Start a simple console application with C#.

```bash
dotnet new console -o Project
```

```bash
dotnet restore # For dependency installation
dotnet run # To run the application (without build)
dotnet build # For building the application
```

## Starting an ASP.NET project

Start API project with C# using the following command:

```bash
dotnet new webapi -o Play
```

### Using docker with an ASP.NET project

```Dockerfile
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

WORKDIR /src

COPY ["Program.cs", "Play.csproj", "appsettings.json", "/src/"]
RUN dotnet restore "./Play.csproj"

ARG BUILD_CONFIGURATION=Release
RUN dotnet build "./Play.csproj" -c $BUILD_CONFIGURATION -o /app/build/
RUN dotnet publish "./Play.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final

WORKDIR /app
EXPOSE 8080

COPY --from=build /app/publish .
ENTRYPOINT [ "dotnet", "Play.dll" ]
```

```yaml
services:
  server:
    build: .
    ports:
      - 8000:8080
```
