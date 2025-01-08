# Background

- [Issue](https://github.com/Evanlab02/WoWScout/issues/1)
- [Branch](https://github.com/Evanlab02/WoWScout/tree/1-create-api-login-flow)
- [PR](https://github.com/Evanlab02/WoWScout/pull/13)

## Description

Before we can access the Blizzard APIs for WoW data, we need to create a login flow using OAuth to get a JWT to access them. This will enable the API to query on behalf of the user for the data.

This requires 3 steps:
- Hit the APIs dedicated login endpoint, that will redirect.
- The redirect should lead to the blizzard oauth service.
- Once logged in, we should be redirected to the service, to be able to retrieve the JWT on behalf of the user using the code.

We will need to cache the results of the JWT.

For caching options there are:
- Redis
- Memcached

We will also need to return a cookie to the user for the session ID that belongs to them.

**It is important we do not store the JWT in the cookies as we would be allowing attackers to grab blizzard JWTs, causing harm. So instead we use a session ID that allows you to do only things with our API, which all are non-destructive actions and since this is a hobby project, will not be publicly available regardless, so the harm should be for the most part avoided.**
## Acceptance Criteria

- Create `/api/v1/auth/login` endpoint.
	- Which redirects users to blizzard and creates the tokens in the cache.
- Create `/api/v1/auth/status` endpoint.
	- Which indicates whether the user does still have access or not. Will be used to determine if we need to recreate the token.
- Update documentation with local development guide.
