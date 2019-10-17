#!/bin/sh
# Docker entrypoint script.

# Sets up tables and running migrations.
/app/bin/ms eval "Ms.Release.migrate"
# Start our app
/app/bin/ms start