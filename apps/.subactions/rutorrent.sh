#!/usr/bin/with-contenv bash
# shellcheck shell=bash
# Copyright (c) 2020, MrDoob
# All rights reserved.
#########################################################################
# Author:         crazy-max/docker-rtorrent-rutorrent                   #
# Docker:         https://github.com/crazy-max/docker-rtorrent-rutorrent#
# URL:            https://github.com/crazy-max/                         #
#########################################################################
#                   GNU General Public License v3.0                     #
#########################################################################
runscript() {
basefolder="/opt/appdata"
composeoverwrite="compose/docker-compose.override.yml"
typed=rutorrent
echo -e "---
version: '3'
services:
  rutorrent:
    environment:
      - 'PGID=${ID:-1000}'
      - 'PUID=${ID:-1000}'
      - 'TZ=${TZ:-UTC}'
      - 'UMASK=${UMASK:-022}'
      - 'RT_DHT_PORT=${RT_DHT_PORT:-6881}'
      - 'XMLRPC_PORT=${XMLRPC_PORT:-8000}'
      - 'RUTORRENT_PORT=${RUTORRENT_PORT:-8080}'
      - 'WEBDAV_PORT=${WEBDAV_PORT:-9000}'
      - 'RT_INC_PORT=${RT_INC_PORT:-50000}'
      - 'MEMORY_LIMIT=${MEMORY_LIMIT:-256M}'
      - 'UPLOAD_MAX_SIZE=${UPLOAD_MAX_SIZE:-16M}'
      - 'OPCACHE_MEM_SIZE=${OPCACHE_MEM_SIZE:-128}'
      - 'MAX_FILE_UPLOADS=${MAX_FILE_UPLOADS:-50}'
      - 'REAL_IP_FROM=${REAL_IP_FROM:-0.0.0.0/32}'
      - 'REAL_IP_HEADER=${REAL_IP_HEADER:-X-Forwarded-For}'
      - 'LOG_IP_VAR=${LOG_IP_VAR:-http_x_forwarded_for}'
      - 'XMLRPC_AUTHBASIC_STRING=${XMLRPC_AUTHBASIC_STRING:-rTorrent_XMLRPC_restricted_access}'
      - 'RUTORRENT_AUTHBASIC_STRING=${RUTORRENT_AUTHBASIC_STRING:-ruTorrent_restricted_access}'
      - 'WEBDAV_AUTHBASIC_STRING=${WEBDAV_AUTHBASIC_STRING:-WebDAV_restricted_access}'
      - 'RT_LOG_LEVEL=${RT_LOG_LEVEL:-info}'
      - 'RT_LOG_EXECUTE=${RT_LOG_EXECUTE:-false}'
      - 'RT_LOG_XMLRPC=${RT_LOG_XMLRPC:-false}'
      - 'RU_REMOVE_CORE_PLUGINS=${RU_REMOVE_CORE_PLUGINS:-erasedata,httprpc.geoip}'
      - 'RU_HTTP_USER_AGENT=${RU_HTTP_USER_AGENT:-Mozilla/5.0 (Windows NT 6.0; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0}'
      - 'RU_HTTP_TIME_OUT=${RU_HTTP_TIME_OUT:-30}'
      - 'RU_HTTP_USE_GZIP=${RU_HTTP_USE_GZIP:-true}'
      - 'RU_RPC_TIME_OUT=${RU_RPC_TIME_OUT:-5}'
      - 'RU_LOG_RPC_CALLS=${RU_LOG_RPC_CALLS:-false}'
      - 'RU_LOG_RPC_FAULTS=${RU_LOG_RPC_FAULTS:-true}'
      - 'RU_PHP_USE_GZIP=${RU_PHP_USE_GZIP:-false}'
      - 'RU_PHP_GZIP_LEVEL=${RU_PHP_GZIP_LEVEL:-2}'
      - 'RU_SCHEDULE_RAND=${RU_SCHEDULE_RAND:-10}'
      - 'RU_LOG_FILE=${RU_LOG_FILE:-/data/rutorrent/rutorrent.log}'
      - 'RU_DO_DIAGNOSTIC=${RU_DO_DIAGNOSTIC:-true}'
      - 'RU_SAVE_UPLOADED_TORRENTS=${RU_SAVE_UPLOADED_TORRENTS:-false}'
      - 'RU_OVERWRITE_UPLOADED_TORRENTS=${RU_OVERWRITE_UPLOADED_TORRENTS:-false}'
      - 'RU_FORBID_USER_SETTINGS=${RU_FORBID_USER_SETTINGS:-false}'
      - 'RU_LOCALE=${RU_LOCALE:-UTF8}'" > $basefolder/$composeoverwrite
}
runscript
## EOF
