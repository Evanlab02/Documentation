import os
import re
from pathlib import Path


def convert_obsidian_to_markdown(text, alt_text="", relative_path_to_assets=""):
    # Regular expression to match Obsidian image links
    obsidian_pattern = r"!\[\[([^\]]+)\]\]"

    # Function to replace each match
    def replacement(match):
        image_name = match.group(1)
        # Prepend the relative path to the image in the Assets folder
        return f"![{alt_text}]({relative_path_to_assets}/Assets/{image_name})"

    # Substitute using the pattern
    converted_text = re.sub(obsidian_pattern, replacement, text)

    return converted_text


def process_markdown_file(file_path, root_directory, alt_text=""):
    # Calculate the relative path from the markdown file to the root directory
    relative_path_to_assets = os.path.relpath(
        root_directory, os.path.dirname(file_path)
    )

    # Read the content of the markdown file
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Convert Obsidian links to traditional Markdown links
    converted_content = convert_obsidian_to_markdown(
        content, alt_text, relative_path_to_assets
    )

    # Write the changes back to the file
    with open(file_path, "w", encoding="utf-8") as file:
        file.write(converted_content)


def process_directory(directory, alt_text=""):
    # The root directory where the Assets folder resides
    root_directory = Path(directory).resolve()

    # Recursively find all markdown files
    md_files = Path(directory).rglob("*.md")

    for md_file in md_files:
        print(f"Processing file: {md_file}")
        process_markdown_file(md_file, root_directory, alt_text)


# Example usage
if __name__ == "__main__":
    # Set the directory you want to process
    target_directory = os.path.abspath("./docs")  # Update with the actual path
    process_directory(target_directory, alt_text="An image")
