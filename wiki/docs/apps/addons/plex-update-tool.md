<br />
![Image of DockServer](/img/logo.png)

[![Website: https://dockserver.io](https://img.shields.io/badge/Website-https%3A%2F%2Fdockserver.io-blue.svg?style=for-the-badge&colorB=177DC1&label=website)](https://dockserver.io)
[![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa)
[![License: GPL 3](https://img.shields.io/badge/License-GPL%203-blue.svg?style=for-the-badge&colorB=177DC1&label=license)](LICENSE)

---

# Rating update tool for IMDB ratings in Plex libraries

A tool to update the IMDB ratings for Plex libraries that contain movies via the IMDB, TMDB and TVDB agents.

![GitHub](https://img.shields.io/github/license/mynttt/updatetool)
![GitHub issues](https://img.shields.io/github/issues/mynttt/updatetool)
![GitHub release (latest by date)](https://img.shields.io/github/v/release/mynttt/updatetool)
![GitHub top language](https://img.shields.io/github/languages/top/mynttt/updatetool)
![Docker Image Size (tag)](https://img.shields.io/docker/image-size/mynttt/updatetool/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/mynttt/updatetool)
<span class="badge-paypal"><a href="https://paypal.me/mynttt" title="Donate to this project using Paypal"><img src="https://img.shields.io/badge/paypal-donate-yellow.svg" alt="PayPal donate button" /></a></span>

## Important

**If you get rating updates on your episodes but not on your TV Shows, you'll have to get access to a TVDB API key. This is because the tool finds IMDB IDs that are associated with the episodes in the database, but for the TV Shows it only finds TVDB IDs that have to be resolved into IMDB IDs by calling their API. Unless you have a key, this is not possible and means that no updates are processed for these items. [You can get a key for free by using their points system.](https://thetvdb.com/points)**

-----

**Make sure to set `USE_PLEX_SQLITE_BINARY_FOR_WRITE_ACCESS` to `true` in your docker configuration (or if using the GUI, set the path to the Plex SQLite binary) and use at least v1.6.0! Plex non-standard SQLite3 version diverged so strongly from vanilla SQLite3 that not using this feature can cause database corruptions in rare cases. Read more [in the environment variable guide](https://github.com/mynttt/UpdateTool#environment-variables-guide)!**

**To run this without docker on Linux in a headless mode check out [this issue](https://github.com/mynttt/UpdateTool/issues/70)!**

**This tool works with the new Plex TV Show agent. The fallback support however is limited and only supports TVDB v4 and not TMDB v3 right now. This feature is a opt-in so please read [more here](#opt-in-for-libraries-using-the-new-tv-show-agent)!**

**While the DB issues are fixed now and using this tool is likely safe to use and never caused issues for myself and a large part of the user base it shall still be noted that this tool should be used with caution and that I'm not responsible for any damages within your PMS database. The database interaction of this tool is minimal and within the milliseconds realm and the queries are executed cleanly by using SQLite's transactions.**

**This tool could in theory break if either the Plex database schema changes or IMDB stops providing a public rating dataset! This would not be dangerous tho as it stops when something goes wrong.**

**If you want to run this on Windows without docker look [here](https://github.com/mynttt/UpdateTool/wiki/Installation-on-Windows)! There is also a GUI for the tool that is discussed [here](#GUI).**

**TV Show updates are done by aired season / aired episode. If you use DVD order for some reason please create an issue and I will implement a flag for you to switch the tool between. Plex uses aired season / aired episode by default tho!**

## What does this do?

The Plex IMDB agent is kind of meh... Sometimes it is not able to retrieve the ratings for newly released movies even tho it matches the IMDB ID with them. It is impossible to comfortable add the rating manually from the users perspective.

This tool allows you to update the database that stores this data with the correct IMDB ratings. It will correct outdated and missing ratings and also set a flag to display the IMDB badge next to the ratings. The source used to retrieve the ratings is the official IMDB dataset that is updated daily and free for non-commercial use. Its download and refreshment will be handled automatically by this tool.

An advantage is that it works outside Plex by manipulating the local Plex database. Thus, no metadata refresh operations have to be done within Plex. It is faster and will not lead into the unforeseen consequences that one sometimes experiences with a Plex metadata refresh (missing or changed posters if not using a custom poster).

Before (Not IMDB matched)            |  After Match
:-------------------------:|:-------------------------:
![](img/star.PNG)  |  ![](img/imdb.PNG)

*Above are two different movies, that why the genres changed*

### This tool processes the following libraries:

Type | Description | Agent
:-------------------------:|:-------------------------:|:-------------------------:
MOVIE | Plex Movie Agent with IMDB | com.plexapp.agents.imdb
MOVIE | TMDB Movie Agent (if TMDB API key set) | com.plexapp.agents.themoviedb
MOVIE | New Plex Movie Agent (if IMDB as ratings source set) | tv.plex.agents.movie
TV SHOW | New Plex TV Show Agent (currently only for items that have the IMDB ID embedded in the Plex database and have been opted-in via a special environment variable) | tv.plex.agents.series
TV SHOW | TMDB Series Agent (if TMDB API key set) | com.plexapp.agents.themoviedb
TV SHOW | TVDB Series Agent (if TVDB auth string set) |com.plexapp.agents.thetvdb

In my library with 1800 movies it transformed entries for 698 items and 1000+ entries for series. If it is left running, every few days when a new IMDB data set is pulled a few ratings will update as well.

### GUI

There is also a GUI to assist users that feel uncomfortable with the CLI way of interacting with the tool. It supports Windows, MacOS and Linux and only [requires the Java 11+ runtime](https://adoptopenjdk.net/?variant=openjdk11&jvmVariant=hotspot) and can be downloaded [here](https://github.com/mynttt/UpdateTool/releases/tag/g1.0.7).

![](https://raw.githubusercontent.com/mynttt/UpdateTool/master/img/gui.PNG)

To use the GUI just double click on the jar file. The GUI will automatically download and update the used version of UpdateTool. You are only required to set the path to the Plex Media Server data folder and submit a path to your java executable. If you want to enable TMDB/TVDB resolvement simply tick the boxes and supply the API keys via the text fields. To start and stop the tool use the respective buttons.

---

## Support

Kindly report any issues/broken-parts/bugs on [github](https://github.com/dockserver/dockserver/issues) or [discord](https://discord.gg/A7h7bKBCVa)

- Join our [![Discord: https://discord.gg/A7h7bKBCVa](https://img.shields.io/badge/Discord-gray.svg?style=for-the-badge)](https://discord.gg/A7h7bKBCVa) for Support
