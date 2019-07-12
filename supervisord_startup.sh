#!/bin/bash

# check for configmap / volume with users to be created
stat /root/passwd
if [[ $? -eq 0 ]]; then
	#set the internal field splitter to colon to parse /etc/passwd-like files
	IFS=':'
	# loop through every line of the config map / passwd file and create the user,
	# unlock them, and add their public key
	while read -r user pass uid gid comment home shell; do
		echo "username is: " $user
		echo "password is: " $pass
		echo "uid is: " $uid
		echo "gid is: " $gid
		echo "comment is: " $comment
		echo "home is: " $home
		echo "shell is: " $shell

		if [[ $pass -eq "" ]]; then
			echo "password seems to be empty.. cowardly refusing to continue"
			break
		fi

		useradd $user -d $home -u $uid -g $gid -s $shell -p $pass
	done < /root/passwd
fi

# Run configuration
globus-connect-server-setup -v

# now we just run the init scripts and fork em off
/etc/init.d/myproxy-server start
/etc/init.d/globus-gridftp-server start

while true; do sleep 3600; done # maybe do other stuff at some point.

# Now we can actually start the supervisor
#exec /usr/bin/supervisord -c /etc/supervisord.conf
