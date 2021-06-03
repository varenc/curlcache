## cURL cacher: aggressively cache curl results locally.

`curlcache` is just a thin wrapper around curl that aggressively caches all requests.
This is useful when you know that the results of a query won't change or don't care. For example, 
I used this when accessing an API which just returns static data that never changes. Helps to
avoid hitting an API query limit. 

Notes:
- caching is based on the hash of curl args and is completely independent of HTTP caching headers
- identical curl commands that have args in a different order will be cached seperately
- by default the cache is in `/tmp` so it will not survive system reboots

Use just like curl:

```shell
$ ./curlcache.sh https://example.org
$ ./curlcache.sh --header "FunFun: true" https://example.org
$ ./curlcache.sh --header "FunFun: true" --request GET https://example.org
```

(the last example behaves indentically but is cached seperately than preceding one)
