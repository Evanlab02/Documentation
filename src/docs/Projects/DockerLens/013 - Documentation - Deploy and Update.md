# Background

- [Issue](https://github.com/Evanlab02/DockerLens/issues/17)
- [PR](https://github.com/Evanlab02/DockerLens/pull/18)

## Description

We should apply some changes to the DockerLens documentation.

Refer to [Evanlab02/mkdocs-template](https://github.com/Evanlab02/mkdocs-template?rgh-link-date=2025-01-08T13%3A01%3A24Z) for changes to the mkdocs configuration. From this same repository grab the deployment workflows for the documentation to gh-pages.

Finally move these docs to use uv instead of pipenv.

### Acceptance Criteria

AC1 - Update mkdocs.yaml  
AC2 - Migrate to uv  
AC3 - Create actions/workflows  
AC3.1 - Build check workflow  
AC3.2 - Deployment workflow
