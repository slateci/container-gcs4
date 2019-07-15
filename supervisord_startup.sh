#!/bin/bash

# check for configmap / volume with users to be created
stat /root/passwd
if [[ $? -eq 0 ]]; then
	#set the internal field splitter to colon to parse /etc/passwd-like files
	IFS=':'
	# loop through every line of the config map / passwd file and create the user,
	# unlock them, and add their public key
    cp /root/passwd /root/passwd1
    # small sanitization of the passwd file.
    # kubernetes will strip newlines, but we need at least one so the while 
    # loop can read the file.  this strips any empty lines after..
    sed -i '/^$/d' /root/passwd1
	while read -r user pass uid gid comment home shell; do
		echo "username is: " $user
		echo "password is: xxxxxxx"  # we dont watn to print out the password, actually
		echo "uid is: " $uid
		echo "gid is: " $gid
		echo "comment is: " $comment
		echo "home is: " $home
		echo "shell is: " $shell

		if [[ $pass == "" ]]; then
			echo "password seems to be empty.. cowardly refusing to continue"
			break
		fi
		useradd $user -d $home -u $uid -s $shell -p $pass

	done < /root/passwd1
fi

# clean up any of these in case the file leaks out of gridftp
rm -f /root/passwd
rm -f /root/passwd1

# Run configuration
globus-connect-server-setup -v

# now we just run the init scripts and fork em off
/etc/init.d/myproxy-server start
/etc/init.d/globus-gridftp-server start

while true; do sleep 3600; done # we need to get some health checks in here

# Now we can actually start the supervisor
#exec /usr/bin/supervisord -c /etc/supervisord.conf
