#! /bin/sh
#
# sqlgrey      start/stop the postgrey greylisting deamon for postfix
#		(priority should be smaller than that of postfix)
#
# Author:	(c)2008 Antonin Kral <A.Kral@sh.cvut.cz>
#		Based on Debian sarge's 'skeleton' example
#               Distribute and/or modify at will.
#
### BEGIN INIT INFO
# Provides:          sqlgrey
# Required-Start:    $syslog $local_fs $remote_fs
# Required-Stop:     $syslog $local_fs $remote_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop the sqlgrey daemon
### END INIT INFO

set -e

PATH=/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/sbin/sqlgrey
SQLGREY_HOME=/var/lib/sqlgrey
NAME=sqlgrey
DESC="postfix greylisting daemon (sqlgrey)"

PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME

# Gracefully exit if the package has been removed.
test -x $DAEMON || exit 0

# Read config file if it is present.
if [ -r /etc/default/$NAME ]
then
    . /etc/default/$NAME
fi

SQLGREY_OPTS="--daemonize $SQLGREY_OPTS"

case "$1" in
  start)
	echo -n "Starting $DESC: $NAME"
	start-stop-daemon --start --quiet --pidfile $PIDFILE \
                --chdir $SQLGREY_HOME \
		--exec $DAEMON -- $SQLGREY_OPTS
	echo "."
	;;
  stop)
	echo -n "Stopping $DESC: $NAME"
	start-stop-daemon --stop --quiet \
			--user sqlgrey --pidfile $PIDFILE --oknodo
        rm -f $PIDFILE
	echo "."
	;;
  reload|force-reload)
	echo -n "Reloading $DESC configuration..."
	start-stop-daemon --stop --quiet --signal 1 \
			--user sqlgrey --pidfile $PIDFILE --oknodo
	echo "done."
        ;;
  restart)
	echo -n "Restarting $DESC: $NAME"
	start-stop-daemon --stop --quiet \
			--user sqlgrey --pidfile $PIDFILE --oknodo
        rm -f $PIDFILE
	sleep 1
	start-stop-daemon --start --quiet --pidfile $PIDFILE \
                --chdir $SQLGREY_HOME \
                --exec $DAEMON -- $SQLGREY_OPTS
	echo "."
	;;
  *)
	echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
	exit 1
	;;
esac

exit 0
