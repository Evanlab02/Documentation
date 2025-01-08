import os
import yaml


def create_nav_structure(root_dir, ignored_dirs=[]):
    ignored_dirs = [os.path.abspath(os.path.join(root_dir, d)) for d in ignored_dirs]

    def build_nav_for_directory(dir_path):
        nav = []
        # Get subfolders and files in the current directory
        for item in sorted(os.listdir(dir_path)):
            full_path = os.path.join(dir_path, item)
            print(f"Found item: {full_path}")

            # Skip ignored directories
            if os.path.isdir(full_path) and any(
                os.path.commonpath([full_path, ignore]) == ignore
                for ignore in ignored_dirs
            ):
                print(f"Ignoring: {full_path}")
                continue

            # If item is a directory, recurse into it
            if os.path.isdir(full_path):
                sub_nav = build_nav_for_directory(full_path)
                print(f"Considering as directory: {full_path}")
                if sub_nav:  # Only add if there's content in the directory
                    nav.append({item: sub_nav})
            # If item is a markdown file, add it to the nav
            elif item.endswith(".md") and item != "index.md":
                print(f"Considering as file: {full_path}")
                file_name = os.path.splitext(item)[0]
                relative_path = os.path.relpath(full_path, root_dir).replace("\\", "/")
                nav.append({file_name: relative_path})
        return nav

    nav = build_nav_for_directory(root_dir)

    return nav


def generate_mkdocs_yml(nav, output_file="mkdocs.yml"):
    mkdocs_data = {
        "site_name": "My Docs",
        "plugins": ["search"],
        "markdown_extensions": [
            {
                "pymdownx.highlight": {
                    "anchor_linenums": True,
                    "line_spans": "__span",
                    "pygments_lang_class": True,
                }
            },
            "pymdownx.inlinehilite",
            "pymdownx.snippets",
            "pymdownx.superfences",
            "admonition",
            "pymdownx.details",
            "pymdownx.superfences",
        ],
        "theme": {
            "name": "material",
            "features": [
                "content.code.copy",
                "navigation.tabs",
                "navigation.tabs.sticky",
                "navigation.prune",
                "navigation.path",
                "navigation.top",
            ],
            "palette": [
                {
                    "scheme": "default",
                    "primary": "red",
                    "accent": "red",
                    "toggle": {
                        "icon": "material/brightness-7",
                        "name": "Switch to dark mode",
                    },
                },
                {
                    "scheme": "slate",
                    "primary": "red",
                    "accent": "red",
                    "toggle": {
                        "icon": "material/brightness-4",
                        "name": "Switch to light mode",
                    },
                },
            ],
        },
        "nav": [{"Home": "index.md"}] + nav,
    }

    with open(output_file, "w") as file:
        yaml.dump(mkdocs_data, file, default_flow_style=False, sort_keys=False)
    print("Created mkdocs config.")


if __name__ == "__main__":
    source_dir = os.path.abspath("./docs")
    nav = create_nav_structure(source_dir)
    generate_mkdocs_yml(nav)
