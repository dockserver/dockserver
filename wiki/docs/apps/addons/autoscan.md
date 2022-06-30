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

## Autoscan

Autoscan replaces the default Plex and Emby behaviour for picking up file changes on the file system.
Autoscan integrates with Sonarr, Radarr, Lidarr and Google Drive to fetch changes in near real-time without relying on the file system.

Wait, what happened to [Plex Autoscan](https://github.com/l3uddz/plex_autoscan)?
Well, Autoscan is a rewrite of the original Plex Autoscan written in the Go language.
In addition, this rewrite introduces a more modular approach and should be easy to extend in the future.

## Introduction

Autoscan is split into three distinct modules:

- Triggers
- Processor
- Targets

Let's take a look at the journey of the path `/tv/Westworld/Season 1/s01e01.mkv` coming from Sonarr.

1. Sonarr's path is translated to a path local to Autoscan. \
   `/mnt/unionfs/Media/TV/Westworld/Season 1/s01e01.mkv`
2. The path is accessed by Autoscan to check whether it exists and adds it to the datastore.
3. Autoscan's path is translated to a path local to Plex. \
   `/data/TV/Season 1/s01e01.mkv`

This should be all that's needed to get you going. Good luck!

### Triggers

Triggers are the 'input' of Autoscan.
They translate incoming data into a common data format called the Scan.

Autoscan supports two kinds of triggers:

- Daemon processes.
  These triggers run in the background and fetch resources based on a cron schedule or in real-time. \
  _Bugs may still exist._

- Webhooks.
  These triggers expose HTTP handlers which can be added to the trigger's software.

Each trigger consists of at least:

- A unique identifier: think of Drive IDs and HTTP routes. \
  _Webhooks use /triggers/ + their name to uniquely identify themselves._

- Trigger-wide priority: higher priorities are processed sooner. \
  _Defaults to 0._

- RegExp-based rewriting rules: translate a path given by the trigger to a path on the local file system. \
  _If the paths are identical between the trigger and the local file system, then the `rewrite` field should be ignored._

#### Daemons

Daemons run in the background and continuously fetch new changes based on a [cron expression](https://crontab.guru).

The following daemons are currently provided by Autoscan:

- Google Drive (Bernard)
- Inotify

#### Webhooks

Webhooks, also known as HTTPTriggers internally, process HTTP requests on their exposed endpoints.
They should be tailor-made for the software they plan to support.

Each instance of a webhook exposes a route which is added to Autoscan's main router.

If one wants to configure a HTTPTrigger with multiple distinct configurations, then these configurations MUST provide a field called `Name` which uniquely identifies the trigger.
The name field is then used to create the route: `/triggers/:name`.

The following webhooks are currently provided by Autoscan:

- Sonarr
- Radarr
- Lidarr

#### Manual Webhook

Autoscan also supports a `manual` webhook for custom scripts or for software which is not supported by Autoscan directly. The manual endpoint is available at `/triggers/manual`.

The manual endpoint accepts one or multiple directory paths as input and should be given one or multiple `dir` query parameters. Just like the other webhooks, the manual webhook is protected with basic authentication if the `auth` option is set in the config file of the user.

URL template: `POST /triggers/manual?dir=$path1&dir=$path2`

The following curl command sends a request to Autoscan to scan the directories `/test/one` and `/test/two`:

```bash
curl --request POST \
  --url 'http://localhost:3030/triggers/manual?dir=%2Ftest%2Fone&dir=%2Ftest%2Ftwo' \
  --header 'Authorization: Basic aGVsbG8gdGhlcmU6Z2VuZXJhbCBrZW5vYmk='
```

**Note: You can visit `/triggers/manual` within a browser to manually submit requests**

#### Configuration

A snippet of the `config.yml` file showcasing what is possible.
You can mix and match exactly the way you like:

```yaml
# Optionally, protect your webhooks with authentication
authentication:
  username: hello there
  password: general kenobi

# port for Autoscan webhooks to listen on
port: 3030

triggers:
  # The manual trigger is always enabled, the config only adjusts its priority and the rewrite rules.
  manual:
    priority: 5
    rewrite:
      - from: ^/Media/
        to: /mnt/unionfs/Media/

  bernard:
    - account: service-account.json
      cron: "*/5 * * * *" # every five minutes (the "" are important)
      priority: 0
      drives:
        - id: Shared Drive 1
        - id: Shared Drive 2

      # rewrite drive to the local filesystem
      rewrite:
        - from: ^/Media/
          to: /mnt/unionfs/Media/

      # filter with regular expressions
      include:
        - ^/mnt/unionfs/Media/
      exclude:
        - '\.srt$'

  inotify:
    - priority: 0

      # filter with regular expressions
      include:
        - ^/mnt/unionfs/Media/
      exclude:
        - '\.(srt|pdf)$'

      # rewrite inotify path to unified filesystem
      rewrite:
        - from: ^/mnt/local/Media/
          to: /mnt/unionfs/Media/

      # local filesystem paths to monitor
      paths:
        - path: /mnt/local/Media

  sonarr:
    - name: sonarr-docker # /triggers/sonarr-docker
      priority: 2

      # Rewrite the path from within the container
      # to your local filesystem.
      rewrite:
        - from: /tv/
          to: /mnt/unionfs/Media/TV/

  radarr:
    - name: radarr # /triggers/radarr
      priority: 2
    - name: radarr4k # /triggers/radarr4k
      priority: 5
  lidarr:
    - name: lidarr # /triggers/lidarr
      priority: 1
```

#### Connecting the -arrs

To add your webhook to Sonarr, Radarr or Lidarr, do:

1. Open the `settings` page in Sonarr/Radarr/Lidarr
2. Select the tab `connect`
3. Click on the big plus sign
4. Select `webhook`
5. Use `Autoscan` as name (or whatever you prefer)
6. Select `On Import` and `On Upgrade`
7. Set the URL to Autoscan's URL and add `/triggers/:name` where name is the name set in the trigger's config.
8. Optional: set username and password.

##### Experimental support for more events

Autoscan also supports the following events in the latest versions of Radarr and Sonarr:

- `Rename`
- `On Movie Delete` and `On Series Delete`
- `On Movie File Delete` and `On Episode File Delete`

We are not 100% sure whether these three events cover all the possible file system interactions.
So for now, please do keep using Bernard or the Inotify trigger to fetch all scans.

### Processor

Triggers pass the Scans they receive to the processor.
The processor then saves the Scans to its datastore.

_The processor uses SQLite as its datastore, feel free to hack around!_

In a separate process, the processor selects Scans from the datastore.
It will always group files belonging to the same folder together and it waits until all the files in that folder are older than the `minimum-age`, which defaults to 10 minutes.

When all files are older than the minimum age, then the processor will call all the configured targets in parallel to request a folder scan.

#### Anchor files

To prevent the processor from calling targets when a remote mount is offline, you can define a list of so called `anchor files`.
These anchor files do not have any special properties and often have no content.
However, they can be used to check whether a file exists on the file system.
If the file does not exist and you have not made any changes to the file, then it is certain that the remote mount must be offline or the software is having problems.

When an anchor file is unavailable, the processor will halt its operations until the file is back online.

We suggest you to use different anchor file names if you merge multiple remote mounts together with a tool such as [UnionFS](https://unionfs.filesystems.org) or [MergerFS](https://github.com/trapexit/mergerfs).
Each remote mount MUST have its own anchor file and its own name for that anchor file.
In addition, make sure to define the 'merged' path to the file and not the remote mount path.
This helps check whether the union-software is working correctly as well.

#### Minimum age

Autoscan does not check whether scan requests received by triggers exist on the file system.
Therefore, to make sure a file exists before it reaches the targets, you should set a minimum age.
The minimum age delays the scan from being send to the targets after it has been added to the queue by a trigger.
The default minimum age is set at 10 minutes to prevent common synchronisation issues.

#### Customising the processor

The processor allows you to set the minimum age of a Scan.
In addition, you can also define a list of anchor files.

A snippet of the `config.yml` file:

```yaml
# override the minimum age to 30 minutes:
minimum-age: 30m

# override the delay between processed scans:
# defaults to 5 seconds
scan-delay: 15s

# override the interval scan stats are displayed:
# defaults to 1 hour / 0s to disable
scan-stats: 1m

# set multiple anchor files
anchors:
  - /mnt/unionfs/drive1.anchor
  - /mnt/unionfs/drive2.anchor
```

The `minimum-age`, `scan-delay` and `scan-stats` fields should be given a string in the following format:

- `1s` if the min-age should be set at 1 second.
- `5m` if the min-age should be set at 5 minutes.
- `1m30s` if the min-age should be set at 1 minute and 30 seconds.
- `1h` if the min-age should be set at 1 hour.

_Please do not forget the `s`, `m` or `h` suffix, otherwise the time unit defaults to nanoseconds._

Scan stats will print the following information at a configured interval:

- Scans processed
- Scans remaining

### Targets

While collecting Scans is fun and all, they need to have a final destination.
Targets are these final destinations and are given Scans from the processor, one batch at a time.

Autoscan currently supports the following targets:

- Plex
- Emby
- Jellyfin
- Autoscan

#### Plex

Autoscan replaces Plex's default behaviour of updating the Plex library automatically.
Therefore, it is advised to turn off Plex's `Update my library automatically` feature.

You can setup one or multiple Plex targets in the config:

```yaml
targets:
  plex:
    - url: https://plex.domain.tld # URL of your Plex server
      token: XXXX # Plex API Token
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /data/ # path accessible by the Plex docker container (if applicable)
```

There are a couple of things to take note of in the config:

- URL. The URL can link to the docker container directly, the localhost or a reverse proxy sitting in front of Plex.
- Token. We need a Plex API Token to make requests on your behalf. [This article](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/) should help you out.
- Rewrite. If Plex is not running on the host OS, but in a Docker container (or Autoscan is running in a Docker container), then you need to rewrite paths accordingly. Check out our [rewriting section](#rewriting-paths) for more info.

#### Emby

While Emby provides much better behaviour out of the box than Plex, it still might be useful to use Autoscan for even better performance.

You can setup one or multiple Emby targets in the config:

```yaml
targets:
  emby:
    - url: https://emby.domain.tld # URL of your Emby server
      token: XXXX # Emby API Token
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /data/ # path accessible by the Emby docker container (if applicable)
```

- URL. The URL can link to the docker container directly, the localhost or a reverse proxy sitting in front of Emby.
- Token. We need an Emby API Token to make requests on your behalf. [This article](https://github.com/MediaBrowser/Emby/wiki/Api-Key-Authentication) should help you out. \
  _It's a bit out of date, but I'm sure you will manage!_
- Rewrite. If Emby is not running on the host OS, but in a Docker container (or Autoscan is running in a Docker container), then you need to rewrite paths accordingly. Check out our [rewriting section](#rewriting-paths) for more info.

#### Jellyfin

While Jellyfin provides much better behaviour out of the box than Plex, it still might be useful to use Autoscan for even better performance.

You can setup one or multiple Jellyfin targets in the config:

```yaml
targets:
  jellyfin:
    - url: https://jellyfin.domain.tld # URL of your Jellyfin server
      token: XXXX # Jellyfin API Token
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /data/ # path accessible by the Jellyfin docker container (if applicable)
```

- URL. The URL can link to the docker container directly, the localhost or a reverse proxy sitting in front of Jellyfin.
- Token. We need a Jellyfin API Token to make requests on your behalf. [This article](https://github.com/MediaBrowser/Emby/wiki/Api-Key-Authentication) should help you out. \
  _It's a bit out of date, but I'm sure you will manage!_
- Rewrite. If Jellyfin is not running on the host OS, but in a Docker container (or Autoscan is running in a Docker container), then you need to rewrite paths accordingly. Check out our [rewriting section](#rewriting-paths) for more info.

#### Autoscan

You can also send scan requests to other instances of autoscan!

```yaml
targets:
  autoscan:
    - url: https://autoscan.domain.tld # URL of Autoscan
      username: XXXX # Username for remote autoscan instance
      password: XXXX # Password for remote autoscan instance
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /mnt/nfs/Media/ # path accessible by the remote autoscan instance (if applicable)
```

### Full config file

With the examples given in the [triggers](#triggers), [processor](#processor) and [targets](#targets) sections, here is what your full config file _could_ look like:

```yaml
# <- processor ->

# override the minimum age to 30 minutes:
minimum-age: 30m

# set multiple anchor files
anchors:
  - /mnt/unionfs/drive1.anchor
  - /mnt/unionfs/drive2.anchor

# <- triggers ->

# Optionally, protect your webhooks with authentication
authentication:
  username: hello there
  password: general kenobi

# port for Autoscan webhooks to listen on
port: 3030

triggers:
  sonarr:
    - name: sonarr-docker # /triggers/sonarr-docker
      priority: 2

      # Rewrite the path from within the container
      # to your local filesystem.
      rewrite:
        - from: /tv/
          to: /mnt/unionfs/Media/TV/

  radarr:
    - name: radarr # /triggers/radarr
      priority: 2
    - name: radarr4k # /triggers/radarr4k
      priority: 5
  lidarr:
    - name: lidarr # /triggers/lidarr
      priority: 1

# <- targets ->

targets:
  plex:
    - url: https://plex.domain.tld # URL of your Plex server
      token: XXXX # Plex API Token
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /data/ # path accessible by the Plex docker container (if applicable)

  emby:
    - url: https://emby.domain.tld # URL of your Emby server
      token: XXXX # Emby API Token
      rewrite:
        - from: /mnt/unionfs/Media/ # local file system
          to: /data/ # path accessible by the Emby docker container (if applicable)
```

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our <a href="https://discord.gg/FYSvu83caM">
  <img src="https://discord.com/api/guilds/830478558995415100/widget.png?label=Discord%20Server&logo=discord" alt="Join DockServer on Discord">
  </a> for Support
