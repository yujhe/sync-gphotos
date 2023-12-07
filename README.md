# SYNC-GPHOTOS

Helper scripts to sync Google photos, albums to local file system by using [gphotos-sync](https://github.com/gilesknap/gphotos-sync).

## Quickstart

### Requirement

Docker installation is required.
To execute docker by non-root user, follow the steps to setup permission.

```sh
# reate the group "docker" from the ui or cli
sudo synogroup --add docker
# make it the group of the docker.sock
sudo chown root:docker /var/run/docker.sock
# assign the user to the docker group in the ui or cli
sudo synogroup --member docker {username}
# login into ssh as {username} and try
```


### Step 1: Initial folder structure

```sh
./create_folder.sh dev
Folder 'dev' created successfully.
Note: put client_secret.json to dev/config/
```

After folders created, you need to put `client_secret.json` to `${folder}/config/client_secret.json`. The credential file can be obtained from Google credentials. ([reference](https://gilesknap.github.io/gphotos-sync/main/tutorials/oauth2.html))

And, you need to do initial login by browser to get the token file `.gphotos.token`. If you are running on NAS, you can login on your computer and copy it to `${folder}/db/.gphotos.token` on remote server. ([reference](https://gilesknap.github.io/gphotos-sync/main/tutorials/installation.html#headless-gphotos-sync-servers))

```sh
# dev/
docker run -it --rm \
    -p 8080:8080 \
    --name gphotos-sync-dev \
    -v ${PWD}/db:/storage \
    -v ${PWD}/config:/config \
    gilesknap/gphotos-sync:latest \
    --skip-files \
    --skip-albums \
    --skip-index \
    /storage
```

### Step 2: Sync photos/albums from Google Photos

You can modify `sync_args` in `scripts/sync.sh` to customize the syncing job.
If you want to keep syncing with Google Photos, please add `scripts/sync.sh` to scheduler.

```sh
# dev/
./scripts/sync.sh
====== [START] DOWNLOAD PHOTOS =====
12-06 14:46:56 WARNING  gphotos-sync 3.1.3 2023-12-06 14:46:56.267066
 2-06 14:46:56 WARNING  Indexing Google Photos Files ...
12-06 14:47:06 WARNING  indexed 12 items ..
 2-06 14:47:06 WARNING  Downloading Photos ...
12-06 14:47:10 WARNING  Downloaded 12 Items, Failed 0, Already Downloaded 0
12-06 14:47:10 WARNING  Indexing Shared (titled) Albums ...
12-06 14:47:10 WARNING  Indexed 0 Shared (titled) Albums
12-06 14:47:10 WARNING  Indexing Albums ...
12-06 14:47:13 WARNING  Indexed 1 Albums
12-06 14:47:13 WARNING  Downloading Photos ...
12-06 14:47:13 WARNING  Downloaded 12 Items, Failed 0, Already Downloaded 12
12-06 14:47:13 WARNING  Creating album folder links to media ...
12-06 14:47:13 WARNING  Created 4 new album folder links
12-06 14:47:13 WARNING  Done.
====== [END] DOWNLOAD PHOTOS =====
```

### Step 3: Link downloaded photos to Synology Photos space

The link will be removed after reboot. You can trigger the link job by scheduler when the server is rebooted.

```sh
# need root permission
sudo ./create_link.sh /volume1/homes/user1/Photos
Mount directory successfully. /volume1/homes/user1/Photos/PhotoLibrary -> /volume1/homes/user1/sync-gphotos/myphoto/gphotos/PhotoLibrary
```

## Reference

- https://gilesknap.github.io/gphotos-sync/main/tutorials/installation.html
- https://bullyrooks.com/index.php/2021/02/02/backing-up-google-photos-to-your-synology-nas/