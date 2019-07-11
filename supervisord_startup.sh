#!/bin/bash

# Run configuration
globus-connect-server-setup

# Now we can actually start the supervisor
exec /usr/bin/supervisord -c /etc/supervisord.conf
