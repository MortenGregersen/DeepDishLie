#!/usr/bin/env python3

import sys
from pathlib import Path

from PIL import Image, ImageOps


input_dir = Path(sys.argv[1] if len(sys.argv) > 1 else "./downloaded-speakers")
output_dir = Path(sys.argv[2] if len(sys.argv) > 2 else "./DeepDishCore/Assets.xcassets/Speakers")

output_dir.mkdir(parents=True, exist_ok=True)


def contents_json(filename: str) -> str:
    return (
        "{\n"
        '  "images" : [\n'
        "    {\n"
        f'      "filename" : "{filename}",\n'
        '      "idiom" : "universal"\n'
        "    }\n"
        "  ],\n"
        '  "info" : {\n'
        '    "author" : "xcode",\n'
        '    "version" : 1\n'
        "  }\n"
        "}\n"
    )

for source_path in sorted(path for path in input_dir.iterdir() if path.is_file()):
    asset_name = source_path.stem
    imageset_path = output_dir / f"{asset_name}.imageset"
    image_path = imageset_path / f"{asset_name}.jpg"
    contents_path = imageset_path / "Contents.json"
    existing_contents = contents_path.read_text() if contents_path.exists() else None

    if imageset_path.exists():
        for path in imageset_path.iterdir():
            if path.name == "Contents.json":
                continue
            path.unlink()
    else:
        imageset_path.mkdir(parents=True)

    image = ImageOps.exif_transpose(Image.open(source_path)).convert("RGB")
    width, height = image.size
    crop_size = min(width, height)
    left = (width - crop_size) // 2
    top = (height - crop_size) // 2
    image = image.crop((left, top, left + crop_size, top + crop_size))
    image = image.resize((300, 300), Image.Resampling.LANCZOS)
    image.save(image_path, format="JPEG", quality=85)

    expected_filename = f'"filename" : "{asset_name}.jpg"'
    alternate_filename = f'"filename": "{asset_name}.jpg"'
    if existing_contents and (expected_filename in existing_contents or alternate_filename in existing_contents):
        contents_path.write_text(existing_contents)
    else:
        contents_path.write_text(contents_json(f"{asset_name}.jpg"))

    print(f"Created {imageset_path}")
