#!/usr/bin/env python3

import json
import sys
from pathlib import Path

from PIL import Image, ImageOps


input_dir = Path(sys.argv[1] if len(sys.argv) > 1 else "./downloaded-speakers")
output_dir = Path(sys.argv[2] if len(sys.argv) > 2 else "./DeepDishCore/Assets.xcassets/Speakers")

output_dir.mkdir(parents=True, exist_ok=True)

for source_path in sorted(path for path in input_dir.iterdir() if path.is_file()):
    asset_name = source_path.stem
    imageset_path = output_dir / f"{asset_name}.imageset"
    image_path = imageset_path / f"{asset_name}.jpg"

    if imageset_path.exists():
        for path in imageset_path.iterdir():
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

    (imageset_path / "Contents.json").write_text(
        json.dumps(
            {
                "images": [{"filename": f"{asset_name}.jpg", "idiom": "universal"}],
                "info": {"author": "xcode", "version": 1},
            },
            indent=2,
        )
        + "\n"
    )

    print(f"Created {imageset_path}")
