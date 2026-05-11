"""
Import phone photos into public/private/japan/photos/.

Why this script exists: phones write photos sideways in pixel data and rely on
the EXIF Orientation tag (value 6 = rotate 90 CW to display). A prior import
pipeline stripped the EXIF tag without baking the rotation into the pixels,
which left ~400 photos physically sideways in the repo. This script applies
the EXIF orientation BEFORE stripping it, so output files render upright in
every viewer regardless of EXIF support.

Usage:
    python scripts/import_japan_photos.py --source <dir> [--dry-run]
    python scripts/import_japan_photos.py --source <dir> --max-edge 1400 --quality 82
"""

import argparse
import os
import sys

from PIL import Image, ImageOps


REPO_DEST = os.path.join("public", "private", "japan", "photos")


def import_photo(src_path: str, dst_path: str, max_edge: int, quality: int) -> int:
    """Process one photo: apply EXIF orientation, resize, strip EXIF, write JPEG.

    Returns the output file size in bytes.
    """
    with Image.open(src_path) as im:
        # Bake EXIF orientation into pixels. Output has no orientation tag.
        upright = ImageOps.exif_transpose(im)

        w, h = upright.size
        if max(w, h) > max_edge:
            if w >= h:
                new_size = (max_edge, round(h * max_edge / w))
            else:
                new_size = (round(w * max_edge / h), max_edge)
            upright = upright.resize(new_size, Image.Resampling.LANCZOS)

        if upright.mode != "RGB":
            upright = upright.convert("RGB")

        upright.save(dst_path, "JPEG", quality=quality, optimize=True)

    return os.path.getsize(dst_path)


def main() -> int:
    parser = argparse.ArgumentParser(description="Import Japan photos with EXIF-aware rotation.")
    parser.add_argument("--source", required=True, help="Directory of original photos")
    parser.add_argument("--dest", default=REPO_DEST, help=f"Destination dir (default: {REPO_DEST})")
    parser.add_argument("--max-edge", type=int, default=1400, help="Max edge in pixels (default 1400)")
    parser.add_argument("--quality", type=int, default=82, help="JPEG quality (default 82)")
    parser.add_argument("--overwrite", action="store_true", help="Re-process files even if dest exists")
    parser.add_argument("--dry-run", action="store_true", help="Report what would happen, write nothing")
    args = parser.parse_args()

    if not os.path.isdir(args.source):
        print(f"Source not found: {args.source}", file=sys.stderr)
        return 1
    os.makedirs(args.dest, exist_ok=True)

    src_files = sorted(f for f in os.listdir(args.source) if f.lower().endswith((".jpg", ".jpeg")))
    if not src_files:
        print("No JPEGs in source.", file=sys.stderr)
        return 1

    written = 0
    skipped_exists = 0
    errors = []
    total_bytes = 0

    for fn in src_files:
        src = os.path.join(args.source, fn)
        dst = os.path.join(args.dest, fn)

        if os.path.exists(dst) and not args.overwrite:
            skipped_exists += 1
            continue

        if args.dry_run:
            written += 1
            continue

        try:
            total_bytes += import_photo(src, dst, args.max_edge, args.quality)
            written += 1
        except Exception as e:
            errors.append((fn, str(e)))

    verb = "Would write" if args.dry_run else "Wrote"
    print(f"{verb}: {written}")
    print(f"Skipped (already in dest): {skipped_exists}")
    if not args.dry_run:
        print(f"Output size: {total_bytes/1024/1024:.1f} MB")
    if errors:
        print(f"Errors: {len(errors)}")
        for e in errors[:10]:
            print(f"  {e[0]}: {e[1]}")
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main())
