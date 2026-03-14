import os
import shutil

# -----------------------------
# SETTINGS
# -----------------------------

# File containing the list of image paths
LIST_FILE = "asset20260108.txt"

# Root folder where all your images are stored
IMAGES_ROOT = "$HOME/Downloads/whatsapp"

# Destination folder where you want to copy the matches
DEST_FOLDER = "$HOME/Downloads/dest"

# -----------------------------
# SCRIPT
# -----------------------------

# Make sure destination folder exists
os.makedirs(DEST_FOLDER, exist_ok=True)

# Build an index of all files inside IMAGES_ROOT
print("Scanning image library...")

file_index = {}

for root, dirs, files in os.walk(IMAGES_ROOT):
    for f in files:
        file_index[f] = os.path.join(root, f)

print(f"Indexed {len(file_index)} files.\n")

# Read the list file and copy matching images
with open(LIST_FILE, "r") as f:
    lines = f.readlines()

copied = 0
missing = 0

for line in lines:
    line = line.strip()
    if not line:
        continue

    # Extract filename only
    filename = os.path.basename(line)

    # Look up filename in the index
    if filename in file_index:
        source_path = file_index[filename]
        dest_path = os.path.join(DEST_FOLDER, filename)

        shutil.copy2(source_path, dest_path)
        print(f"✅ Copied: {filename}")
        copied += 1
    else:
        print(f"❌ Missing: {filename}")
        missing += 1

print("\nDone!")
print(f"Copied: {copied}")
print(f"Missing: {missing}")
