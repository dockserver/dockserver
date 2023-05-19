# Dropbox Configuration

## **Preface**
### In this guide, you will create 2 rclone files; one for Mount, one for Uploader. Please note, this guide only shows how to create an encrypted drive with Dropbox.

## **Before you begin**
### Please backup the entire `/opt/appdata/system` directory and ensure you are running the latest versions of Mount and Uploader.

## **Create rclone configs**
1. Download [rclone](https://rclone.org/downloads/)

1. Create 2 Apps according to [this](https://rclone.org/dropbox/#get-your-own-dropbox-app-id) guide (Mount, Uploader) and note each app key/secret. You will need it for rclone.

1. Run `rclone.exe config`

1. Create Remote (DB)

    - New remote> `n`
    - name> `DB`
    - Storage (Dropbox)> `13`
    - client_id> App Key from step 2
    - client_secret> App secret from step 2
    - Edit advanced config?> `n`
    - Use web browser to automatically authenticate rclone with remote?> `y`
    - Log in with your DB account and allow app
   
   Repeat for all 2 apps, copying away your rclone.conf after each run.

1. Create Remote (DBC)

    - New remote> `n`
    - Name> `DBC`
    - Storage (Crypt)> `14`
    - remote> `DB:/<directory_name>`
    - filename_encryption> `1`
    - directory_name_encryption> `1`
    - Generate random password> `g`
    - Bits> `128` (Note the password and never lose it)
    - Use this password?> `y`
    - Password or pass phrase for salt> `g`
    - Bits> `128` (Note the password and never lose it)
    - Use this password?> `y`
    - Edit advanced config?> `n`
    - Keep this "DBC" Remote?> `y`
   
   **Note** - In `remote = DB:/<directory_name>`, change `<directory_name>` to whatever you'd like.

1. Add the following to the crypt [DBC] section in `%AppData%\rclone\rclone.conf`
   ```
   directory_name_encryption = true
   filename_encryption = standard
   filename_encoding = base32768
   ```

    **IMPORTANT**: `filename_encoding` must be this value: `base32768`
1. Copy the [DBC] section to the other rclone.conf file. You should end up with 2 files that look similar to this:
   ```
   [DB]
   type = dropbox
   token = {"access_token":"<redacted>","token_type":"bearer","refresh_token":"<redacted>","expiry":"2023-04-03T20:22:38.8845967+02:00"}
   client_id = <redacted>
   client_secret = <redacted>
   
   [DBC]
   type = crypt
   directory_name_encryption = true
   password = <redacted>
   password2 = <redacted>
   remote = DB:/<directory_name>
   filename_encryption = standard
   filename_encoding = base32768
   ```

1. Copy the Mount rclone.conf file to:

    - `/opt/appdata/system/rclone/rclone.conf`
    - `/opt/appdata/system/mount/rclone/rclone.conf`

1. Copy the contents of Uploader rclone.conf to `/opt/appdata/system/servicekeys/rclonegdsa.conf`, deleting everything that is currently there. This should be the only file/folder in this directory.

1. Redeploy Mount and Uploader

1. Update `DB_NAME` value in `/opt/appdata/system/uploader/uploader.env` with the name you chose during step 5. Example: `DB_NAME=<directory_name>`

1. Restart Uploader

1. Finally, assuming everything looks to be working, run the following two commands:

    - `cd /root && touch dbc.anchor`
    - `rclone copy -v "/root/dbc.anchor" "DBC:/.anchors" --config="/opt/appdata/system/rclone/rclone.conf" --stats=1s --checkers=4 --dropbox-chunk-size=128M --use-mmap --tpslimit=10 --transfers=6`

## **Autoscan**

1. If using autoscan, you will need to update `/opt/appdata/autoscan/config.yml` to include the following:

   ```
   anchors:
     - /mnt/unionfs/.anchors/dbc.anchor
   ```

2. Restart autoscan. `docker restart autoscan`
