# AJAX

The core of htmx is a set of attributes that allow you to issue AJAX requests directly from HTML:

| Attribute                                           | Description                                |
| --------------------------------------------------- | ------------------------------------------ |
| [hx-get](https://htmx.org/attributes/hx-get/)       | Issues a `GET` request to the given URL    |
| [hx-post](https://htmx.org/attributes/hx-post/)     | Issues a `POST` request to the given URL   |
| [hx-put](https://htmx.org/attributes/hx-put/)       | Issues a `PUT` request to the given URL    |
| [hx-patch](https://htmx.org/attributes/hx-patch/)   | Issues a `PATCH` request to the given URL  |
| [hx-delete](https://htmx.org/attributes/hx-delete/) | Issues a `DELETE` request to the given URL |

Each of these attributes takes a URL to issue an AJAX request to. The element will issue a request of the specified type to the given URL when the element is [triggered](https://htmx.org/docs/#triggers):

```html
<button hx-put="/messages">
    Put To Messages
</button>
```

This tells the browser:

> When a user clicks on this button, issue a PUT request to the URL /messages and load the response into the button
