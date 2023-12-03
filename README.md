# SYNC-GPHOTOS

Helper scripts to sync Google photos, albums to local file system by using [gphotos-sync](https://github.com/gilesknap/gphotos-sync).

## Quickstart

### Step 1: Initial folder structure

```sh
./create_folder.sh myphoto
Folder 'myphoto' created successfully.
Note: put client_secret.json to myphoto/config/

or

./create_folder.sh
Enter the folder name: myphoto
Folder 'myphoto' created successfully.
Note: put client_secret.json to myphoto/config/

cd myphoto/
```

After folders created, you need to put `client_secret.json` to `${folder}/config/client_secret.json`. The credential file can be obtained from Google credentials. ([reference](https://gilesknap.github.io/gphotos-sync/main/tutorials/oauth2.html))

And, you need to do initial login by browser to get the token file `.gphotos.token`. If you are running on NAS, you can login on your computer and copy it to remote server. ([reference](https://gilesknap.github.io/gphotos-sync/main/tutorials/installation.html#headless-gphotos-sync-servers))

```sh
# myphoto/
docker run -it --rm \
    -p 8080:8080 \
    --name gphotos-sync-myphoto \
    -v ${PWD}/db:/storage \
    -v ${PWD}/config:/config \
    gilesknap/gphotos-sync:latest \
    --skip-files \
    --skip-albums \
    --skip-index /storage
```

### Step 2: Sync photos/albums from Google Photos

You can modify the arguments in `sync.sh` if you need to customize the syncing job.

You can add the syncing job to scheduler to keep syncing with Google Photos.

```sh
# myphoto/
./sync.sh
12-03 07:05:08 WARNING  gphotos-sync 3.1.3 2023-12-03 07:05:08.638703
 2-03 07:05:15 WARNING  Indexing Google Photos Files ...
12-03 07:05:19 WARNING  indexed 388 items ..
 2-03 07:05:19 WARNING  Downloading Photos ...
12-03 07:06:41 WARNING  Downloaded 388 Items, Failed 0, Already Downloaded 0
12-03 07:06:41 WARNING  Indexing Shared (titled) Albums ...
12-03 07:06:43 WARNING  Indexed 1 Shared (titled) Albums
12-03 07:06:43 WARNING  Indexing Albums ...
12-03 07:07:04 WARNING  Indexed 4 Albums
 2-03 07:07:04 WARNING  Downloading Photos ...
12-03 07:07:07 WARNING  Downloaded 399 Items, Failed 0, Already Downloaded 388
12-03 07:07:07 WARNING  Creating album folder links to media ...
12-03 07:07:07 WARNING  Created 42 new album folder links
12-03 07:07:08 WARNING  Done.
```

### Step 3: Link downloaded photos, albums to Synology Photos

The link will be removed after reboot. You can trigger the link job by scheduler when the server is rebooted.

```sh
# need root permission
sudo ./create_link.sh /volume1/homes/user1/Photos
Mount directory successfully. /volume1/homes/user1/Photos/albums/me -> /volume1/homes/user1/sync-gphotos/myphoto/gphotos/albums/me
Mount directory successfully. /volume1/homes/lifamily/Photos/PhotoLibrary -> /volume1/homes/lifamily/sync-gphotos/myphoto/gphotos/PhotoLibrary
```

## Reference

- https://gilesknap.github.io/gphotos-sync/main/tutorials/installation.html
- https://bullyrooks.com/index.php/2021/02/02/backing-up-google-photos-to-your-synology-nas/