![Image of DockServer](/img/container_images/docker-dockserver.png)

<p align="left">
    <a href="https://discord.gg/FYSvu83caM">
        <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
    </a>
        <a href="https://github.com/dockserver/dockserver/releases">
        <img src="https://img.shields.io/github/downloads/dockserver/dockserver/total?label=Total%20Downloads&logo=github" alt="Total Releases Downloaded from GitHub">
    </a>
    <a href="https://github.com/dockserver/dockserver/releases/latest">
        <img src="https://img.shields.io/github/v/release/dockserver/dockserver?include_prereleases&label=Latest%20Release&logo=github" alt="Latest Official Release on GitHub">
    </a>
    <a href="https://github.com/dockserver/dockserver/blob/master/LICENSE">
        <img src="https://img.shields.io/github/license/dockserver/dockserver?label=License&logo=gnu" alt="GNU General Public License">
    </a>
</p>


# How to Configure Dropbox for Mount Docker

This guide provides step-by-step instructions on how to configure Dropbox with Rclone for use with Dockserver.

## Step 1: Installing Rclone

You can install rclone by running one of the following commands:

```bash
sudo apt install rclone
```
or 
```
curl https://rclone.org/install.sh | sudo bash
```
## Step 2: Creating your Dropbox App

To retrieve information for rclone, you'll need to create your own Dropbox App.

Here's how to do it:

1. Log into the [Dropbox App console](https://www.dropbox.com/developers/apps/create) with your Dropbox Account.

2. Choose the type of access you want to use: Full Dropbox or App Folder.

3. Name your App. The app name is global, so you **can't** use 'rclone' for example.

4. Click the button "Create App".

5. Switch to the Permissions tab. Enable the following permissions: `account_info.read`, `files.metadata.write`, `files.content.write`, `files.content.read`, `sharing.write`. The `files.metadata.read` and `sharing.read` checkboxes will be marked too. Click Submit.

6. Switch to the Settings tab. Fill OAuth2 - Redirect URIs as `http://localhost:53682/`.

7. Find the App key and App secret values on the Settings tab. Use these values in rclone config to add a new remote or edit an existing remote. The App key setting corresponds to client_id in rclone config, and the App secret corresponds to client_secret.

## Step 3: Creating a New Remote in Rclone

Enter rclone configuration:

```
rclone config
```

1. Choose to create a new remote:

```
n) New remote
d) Delete remote
q) Quit config
e/n/d/q> n
```

2. Name the remote and choose Dropbox:

## Mandatory Naming Convention

When setting up your configurations, it's crucial to use the specific names 'DB' and 'DBC' for your Dropbox and Crypt remotes, respectively. The Dockserver mount relies on these precise names to function correctly. Deviating from this naming convention may result in the mount not operating as intended. Please make sure to follow these instructions carefully.


```
name> DB
```

3. You will then be prompted to enter the type of storage to configure. Scroll through the list until you find Dropbox, then enter the corresponding number or type "Dropbox":

```
Storage> Dropbox
```

4. You will then be asked for your Dropbox App Key (client_id) and App Secret (client_secret). Enter these accordingly:

```
Dropbox App Key - leave blank normally.
app_key> [Your Dropbox App Key]
Dropbox App Secret - leave blank normally.
app_secret> [Your Dropbox App Secret]
```

5.Complete the remaining steps as instructed by rclone. Generally, you will have to authorize rclone to access your Dropbox account.

6.After configuring the Dropbox remote, you can now create a Crypt remote. This will encrypt your files on Dropbox:

```
name> DBC
```
```
Storage> crypt
Remote to encrypt/decrypt.
Normally should contain a ':' and a path, eg "myremote:path/to/dir",
"myremote:bucket" or maybe "myremote:" (not recommended).
```
```
remote> DB:/encrypt
```

7. the Press Enter for the defaults options for `filename_encryption` and `directory_name_encryption`

8. chose  'Yes, type in my own password'
```
Option password.
Password or pass phrase for encryption.
Choose an alternative below.
y) Yes, type in my own password
g) Generate random password
y/g> y
```

8.When prompted for a password, enter a secure password. This will be used to encrypt your files:

```
Enter password to protect config. Optional but recommended.
Should be at least 16 characters. Can be left blank.
password> [Your password]

```

9. Enter a second password. This is used as a salt for the encryption:

```
Enter the salt value. Optional, but recommended.
Should be at least 16 characters. Can be left blank.
password2> [Your password]

```
10. Confirm that your settings are correct:
```
y) Yes this is OK
e) Edit this remote
d) Delete this remote
y/e/d> y
```

## Locating and Modifying the Configuration File

To locate your rclone configuration file, use the following command:

```bash
rclone config file
```
This will output the location of your configuration file, which will look something like this:
```bash
Configuration file is stored at:
/Users/Your-Username/.config/rclone/rclone.conf
```

Open this file to view your current configuration. It is not recommended to use the nano command to copy the configuration as it may occasionally omit parts of the file. Instead, it's suggested to use the cat command to view and copy the content, though several methods could be applicable based on your preference.

Here's an example of what your configuration file might look like:

```
[DB]
type = dropbox
client_id = XXXXXXXXXXXXX
client_secret = XXXXXXXXXXX
token = {"access_token":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","token_type":"bearer","refresh_token":"XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX","expiry":"2023-00-01T00:00:00.00000-02:00"}

[DBC]
type = crypt
remote = DB:/encrypt
password = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
password2 = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
filename_encoding = base32768

```

Remember to add the line `filename_encoding = base32768` to your configuration.



## Adding Configurations to Dockserver

After setting up the Dropbox and Crypt remotes (DB and DBC), you need to add these configurations to the Dockserver rclone configuration file located at `/opt/appdata/system/rclone/rclone.conf`.

To add your new configurations, open the file with your preferred text editor and add the sections for your DB and DBC remotes.

It's important to note that these changes will only affect the mount at this stage. wifi for uploads will be added in the near future.



Remember, configuration files contain sensitive information, so always handle them with care and avoid sharing the content unnecessarily.



## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
