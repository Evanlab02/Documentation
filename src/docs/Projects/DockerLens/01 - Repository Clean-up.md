# Background

- [Branch](https://github.com/Evanlab02/DockerLens/tree/1-repository-clean-up)
- [Issue](https://github.com/Evanlab02/DockerLens/issues/1)
- [PR](https://github.com/Evanlab02/DockerLens/pull/11)
## Description

We should update the repository to be a bit more self-explanatory in structure and also improve developer experience.

### Acceptance Criteria

AC1 - Update the `/server` directory to be the `/app` directory.  
AC2 - Update the `/site` directory to be the `/web` directory.  
AC3 - Update .gitignore to use `**` instead of `/server`  
AC4 - Update compose file to be more conventional.  
AC5 - Update compose file to have watch/dev support.

## Outcome

### Update directories

This is a small updates just to be more verbose about what is actually in which folder. 

`Server` was ambiguous at best, so renamed it to `app` and also moved the `.gitignore` to the app directory, to keep the exclusions specified by it local to that directory.

Also updated the `site` directory to `web` .

### Update compose file

Updated the compose file to match the new directory structure with some small tweaks.

```yaml
services:
  app:
    container_name: lens-app
    build:
      context: app

  web:
    container_name: lens-web
    build:
      context: .
    ports:
      - 80:80
```

This is also meant I had to update the Caddyfile:

```Caddyfile
:80 {
    handle_path /* {
    	reverse_proxy app:80
    }
	
    handle_path /docs/* {
        root * /var/www/html/docs/
        file_server
    }
}
```

#### Develop/Watch mode with compose file

Updated the compose file to use watch to enable on the fly changes when changing code that reflects in the running containers.

```yaml
services:
  app:
    container_name: lens-app
    restart: always
    build:
      context: app
    develop:
      watch:
        - action: sync+restart
          path: ./app/config/custom.conf
          target: /etc/apache2/conf-available/custom.conf
        - action: sync+restart
          path: ./app/public/
          target: /var/www/html/public
        - action: sync+restart
          path: ./app/src/
          target: /var/www/html/src
        - action: rebuild
          path: ./app/composer.json
        - action: rebuild
          path: ./app/Dockerfile

  web:
    container_name: lens-web
    restart: always
    build:
      context: .
    ports:
      - 80:80
    develop:
      watch:
        - action: sync+restart
          path: ./web/Caddyfile
          target: /etc/caddy/Caddyfile
        - action: rebuild
          path: ./docs
```
