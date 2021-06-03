#!/bin/bash

#############################################################################
### cURL cacher: aggressively cache curl results locally.
#
# `curlcache` is just a thin wrapper around curl that aggressively caches all requests.
# This is useful when you know that the results of a query won't change or don't care. For example, 
# I used this when accessing an API which is just returns static data that never changes. Helps to
# avoid hitting an API query limit. 
#
# Notes:
# - caching is based on the hash of curl args and is completely independent of HTTP caching headers
# - identical curl commands that have args in a different order will be cached seperately
# - by default the cache is in /tmp/ so it will not surive system reboots
# 
#############################################################################

VERBOSE=1
TMP_CACHE_PATH="/tmp"

log() {
    if [ $VERBOSE -gt 0 ]; then
        >&2 echo "###" $*;
    fi
}

cmd_exists() {
  if command -v $1 > /dev/null ; then true; else false; fi
}

if cmd_exists "sha256"; then
    SHA256_CMD="sha256"
elif cmd_exists "shasum"; then
    SHA256_CMD=(shasum -p -a256)
else
    echo "no sha256 command"
fi

CURL_ARGS=("$@");
HASH=$(echo -n $@ | $SHA256_CMD | awk '{print $1}')
CACHE_FILE=$TMP_CACHE_PATH/$HASH

if [ -e $CACHE_FILE ] ; then
    log "Using existing cache for curl request"
else
    log "Not in cache. Saving query: curl $(printf "'%s' " "$@")   to $CACHE_FILE"
    curl --silent --show-error --fail --location -o "$CACHE_FILE" "$@" || exit
fi

cat $CACHE_FILE;


#############################################################################
# Copyright (c) 2021 Chris Varenhorst <chris@varenhor.st / varenc@gmail.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#############################################################################
