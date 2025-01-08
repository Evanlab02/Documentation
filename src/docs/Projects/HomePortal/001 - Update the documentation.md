# Background

- [Issue](https://github.com/Evanlab02/HomePortal/issues/13)
- [Branch](https://github.com/Evanlab02/HomePortal/tree/13-update-the-documentation)
- [PR](https://github.com/Evanlab02/HomePortal/pull/14)
## Description

Currently we do not document two important things:

- The admin app will only be accessible on the primary host.
- The home portal is not intended to be run in production environments.

We should update the documentation to reflect this.
### Acceptance Criteria

- AC1 - Document that the admin app is only available on the primary host.
- AC2 - Document that the home portal is not intended for production environments.
- AC3 - Use the new styling for the documentation.
- BONUS - Remove all the different release types we are creating as it is redundant.
## Outcome

### Admin app is only available on the primary host

A recent new addition to functionality allows for multiple hosts (up to 3 hosts). An unintentional side effect was that the admin page was only available on the primary host, but after reviewing this. This seems like a good thing. I will be leaving it as is, but added some documentation to make users aware of this.

You will be able to see the updates on the documentation [here](https://evanlab-gme8r.ondigitalocean.app/guides/).
### Documenting that home portal is not intended for production environments

Home portal is a hobby project, and is only maintained by myself. Therefore it is highly recommended that users do not use this within a production environment.
I have created a disclaimer on the home page of the documentation that indicates that this project is not meant for production environments.

You will be able to see the updates on the documentation [here](https://evanlab-gme8r.ondigitalocean.app/).

### Updating the theme to mkdocs-material

To align with the other documentation sites I have available, I have decided to update the theme for the documentation to `mkdocs-material`.
This has also become quite standard within the python community for documentation.
#### Added mkdocs-material to the Pipfile

```Pipfile
[[source]]
url = "https://pypi.org/simple"
verify_ssl = true
name = "pypi"

[packages]
mkdocs = "==1.6.1"
mkdocs-material = "==9.5.41"

[dev-packages]

[requires]
python_version = "3.12"
```

#### mkdocs-material configuration

```yaml
plugins:
  - search
markdown_extensions:
  - pymdownx.highlight:
      anchor_linenums: true
      line_spans: __span
      pygments_lang_class: true
  - "pymdownx.inlinehilite"
  - "pymdownx.snippets"
  - "pymdownx.superfences"
  - "admonition"
  - "pymdownx.details"
  - "pymdownx.superfences"
theme:
  name: material
  features:
    - content.code.copy
  palette: 
    - scheme: default
      toggle:
        icon: material/brightness-7 
        name: Switch to dark mode
    - scheme: slate
      toggle:
        icon: material/brightness-4
        name: Switch to light mode
```


### Remove redundant release jobs

Currently we are creating a release image for all the different parts of the app changes and then one final release that combines all of the changes together. This is not necessary as it would all be the same images in the end. Now we are just releasing one image for all these changes.
### Other fixes

- Updated the host of the URLs for the documentation on the index/home page. This is due to the fact that I moved all my documentation to one host for all my projects and this was an artifact from before where I had a dedicated host/site for the Home Portal documentation. You will be able to see the updates on the documentation [here](https://evanlab-gme8r.ondigitalocean.app/).
