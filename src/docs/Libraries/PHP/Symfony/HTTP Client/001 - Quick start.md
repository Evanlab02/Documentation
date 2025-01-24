# Installation

The HttpClient component is a low-level HTTP client with support for both PHP stream wrappers and cURL. It provides utilities to consume APIs and supports synchronous and asynchronous operations. You can install it with:

```bash
composer require symfony/http-client
```

## Basic Usage

Use the `HttpClient` class to make requests. In the Symfony framework, this class is available as the `http_client` service. This service will be **autowired** automatically when type-hinting for `HttpClientInterface`:

```php
<?php

use Symfony\Contracts\HttpClient\HttpClientInterface;

class SymfonyDocs
{
    public function __construct(
        private HttpClientInterface $client,
    ) {
    }

    public function fetchGitHubInformation(): array
    {
        $response = $this->client->request(
            'GET',
            'https://api.github.com/repos/symfony/symfony-docs'
        );

        $statusCode = $response->getStatusCode();
        // $statusCode = 200
        $contentType = $response->getHeaders()['content-type'][0];
        // $contentType = 'application/json'
        $content = $response->getContent();
        // $content = '{"id":521583, "name":"symfony-docs", ...}'
        $content = $response->toArray();
        // $content = ['id' => 521583, 'name' => 'symfony-docs', ...]

        return $content;
    }
}
```
