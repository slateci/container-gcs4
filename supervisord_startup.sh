#!/bin/bash

# Run configuration
globus-connect-server-setup -v

# now we just run the init scripts and fork em off
/etc/init.d/myproxy-server start
/etc/init.d/globus-gridftp-server start

while true; do sleep 3600; done

# Now we can actually start the supervisor
#exec /usr/bin/supervisord -c /etc/supervisord.conf
