Pageboard server config
=======================

This module *requires* manual configuration for now, but provides lots
of ready-to-run config files.

Prerequisites
-------------

* /usr/sbin/nginx
* /etc/nginx/mime.types
* lua5.1 and lua-filesystem packages
* nginx modules: ndk, lua, memc, set_misc, srcache_filter all installed
  in usual location (/usr/share/nginx/modules)
* /usr/bin/memcached


Setup pageboard service
-----------------------

# Override pageboard name

`APPNAME=pageboard1 pageboard`

# Setup minimal config

In `~/.config/pageboard1`:
```
listen = 17000
[connection]
user = eda
```

# Setup pageboard service file

See services/README.md


Setup iptables
--------------

The idea is to redirect traffic bound to an IP address
and port 80 and 443, to 17080 and 17443 (or whatever ports
you choose), and run nginx/memcached as current user on
those ports.

This allow each nginx instance to "catch" all domains redirecting
to that IP, to have additional modules and config kept separate
from other nginx configurations.

It also has the additional benefit of running with unprivileged user.

See etc/ for an example configuration with two pageboard services.


Setup nginx service
-------------------

See services/README.md

