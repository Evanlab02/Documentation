# Getting Started with NestJS

Please make sure that [Node.js](https://nodejs.org) (version >= 16) is installed on your operating system.

## Setup

Setting up a new project is quite simple with the [Nest CLI](https://docs.nestjs.com/cli/overview). With [npm](https://www.npmjs.com/) installed, you can create a new Nest project with the following commands in your OS terminal:

```bash
npm i -g @nestjs/cli
nest new project-name
```

## Running the application

Once the installation process is complete, you can run the following command at your OS command prompt to start the application listening for inbound HTTP requests:

```bash
$ npm run start
```

This command starts the app with the HTTP server listening on the port defined in the `src/main.ts` file. Once the application is running, open your browser and navigate to `http://localhost:3000/`. You should see the `Hello World!` message.

To watch for changes in your files, you can run the following command to start the application:

```bash

$ npm run start:dev
```

This command will watch your files, automatically recompiling and reloading the server.
