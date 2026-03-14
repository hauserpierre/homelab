import os
import subprocess
import re

ROOT_DIR = "/media/DATA/immich-backups"

# 🔒 SAFETY SWITCH
DRY_RUN = True   # Set to False to apply changes

IMAGE_EXTENSIONS = (".jpg", ".jpeg", ".png", ".heic", ".tif", ".tiff")
YEAR_MONTH_REGEX = re.compile(r"(\d{4})-(\d{2})$")

DEFAULT_DAY = "15"
DEFAULT_TIME = "12:00:00"

# Filename date patterns
FILENAME_PATTERNS = [
    re.compile(r".*(\d{4})(\d{2})(\d{2}).*"),        # YYYYMMDD
    re.compile(r".*(\d{4})-(\d{2})-(\d{2}).*"),      # YYYY-MM-DD
]

def get_exif_date(path):
    try:
        result = subprocess.check_output(
            ["exiftool", "-DateTimeOriginal", "-s3", path],
            stderr=subprocess.DEVNULL
        ).decode().strip()
        return result if result else None
    except subprocess.CalledProcessError:
        return None

def get_date_from_filename(filename):
    for pattern in FILENAME_PATTERNS:
        match = pattern.match(filename)
        if match:
            year, month, day = match.groups()
            return year, month, day
    return None

def set_exif_date(path, new_date):
    if DRY_RUN:
        return

    subprocess.run(
        [
            "exiftool",
            "-overwrite_original",
            f"-DateTimeOriginal={new_date}",
            f"-CreateDate={new_date}",
            f"-ModifyDate={new_date}",
            path
        ],
        stdout=subprocess.DEVNULL,
        stderr=subprocess.DEVNULL
    )

def main():
    print("=== Immich Date Fix Script ===")
    print(f"Root folder : {ROOT_DIR}")
    print(f"Dry run     : {DRY_RUN}")
    print("==============================\n")

    for root, _, files in os.walk(ROOT_DIR):
        folder_name = os.path.basename(root)
        match = YEAR_MONTH_REGEX.match(folder_name)

        # Only process YYYY-MM folders
        if not match:
            continue

        folder_year, folder_month = match.groups()

        for file in files:
            if not file.lower().endswith(IMAGE_EXTENSIONS):
                continue

            path = os.path.join(root, file)
            exif_date = get_exif_date(path)

            # Case 1: EXIF date exists
            if exif_date:
                exif_year, exif_month, exif_day = exif_date[:10].split(":")
                time_part = exif_date[11:]

                if exif_year == folder_year and exif_month == folder_month:
                    continue

                new_date = f"{folder_year}:{folder_month}:{exif_day} {time_part}"

                label = "EXIF"

            # Case 2: No EXIF → filename date
            else:
                filename_date = get_date_from_filename(file)

                if filename_date:
                    _, _, day = filename_date
                    new_date = f"{folder_year}:{folder_month}:{day} {DEFAULT_TIME}"
                    label = "FILENAME"
                else:
                    new_date = f"{folder_year}:{folder_month}:{DEFAULT_DAY} {DEFAULT_TIME}"
                    label = "FALLBACK"

            if DRY_RUN:
                print(f"[DRY-RUN][{label}] {path}")
                if exif_date:
                    print(f"          {exif_date} → {new_date}")
                else:
                    print(f"          → {new_date}")
            else:
                set_exif_date(path, new_date)
                print(f"[SET][{label}] {path}")
                print(f"      → {new_date}")

if __name__ == "__main__":
    main()
