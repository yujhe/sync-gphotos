
import concurrent.futures
import os
import shlex
import subprocess
from functools import partial

ALUMNS_PATH = './gphotos/albums'


def add_tag(photo_path: str, tag: str) -> None:
    exiftool_cmd = f'exiftool -keywords -charset iptc=UTF8 "{photo_path}"'
    grep_cmd = f'grep -q "\\b{tag}\\b"'

    exiftool_rs = subprocess.run(shlex.split(exiftool_cmd), stdout=subprocess.PIPE, text=True, check=True)
    grep_rs = subprocess.run(shlex.split(grep_cmd), input=exiftool_rs.stdout, stdout=subprocess.PIPE, text=True)

    # Check if the keyword exists in the output
    # if tag.lower() in result.stdout.lower():
    if grep_rs.returncode != 0:
        exiftool_cmd = f'exiftool -keywords+="{tag}" -charset iptc=UTF8 -overwrite_original "{photo_path}"'
        exiftool_rs = subprocess.run(shlex.split(exiftool_cmd), capture_output=True, text=True, check=True)
        if exiftool_rs.returncode == 0:
            print(f"Keyword '{tag}' added to '{photo_path}.")
        else:
            print(f"Error: Keyword '{tag}' can not add to '{photo_path}.")
    else:
        print(f"Keyword '{tag}' already exist on '{photo_path}', skip it.")


for album in os.listdir(ALUMNS_PATH):
    album_path = os.path.join(ALUMNS_PATH, album)

    if not os.path.isdir(album_path):
        continue

    photos = [os.path.realpath(os.path.join(album_path, photo)) for photo in os.listdir(album_path)]
    # create a partially-applied version of the add_tag function
    partial_add_tag = partial(add_tag, tag=album)

    # number of worker threads (adjust as needed)
    num_threads = 100
    with concurrent.futures.ThreadPoolExecutor(max_workers=num_threads) as executor:
        executor.map(partial_add_tag, photos)
