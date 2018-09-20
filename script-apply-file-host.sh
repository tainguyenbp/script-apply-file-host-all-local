#!/bin/bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DIR"

PATH_FILE_HOSTS="$CURRENT_DIR/hosts"
PATH_FILE_SERVER="$CURRENT_DIR/server-virtual-linux.csv"

check_file_and_run_script(){
	
	if [ -f "$PATH_FILE_HOSTS" ] && [ -f "$PATH_FILE_SERVER" ]
		then
			echo "File $PATH_FILE_HOSTS found !!!"
			echo "File $PATH_FILE_SERVER found !!!"
		while IFS=',' read -r ip_host username password port description
			do
				echo "Ip host : $ip_host"
				echo "Username : $username"
				echo "Password : $password"
				echo "Port ssh : $port"
				echo "Description : $description"
			
			sshpass -p"$password" scp -r -P"$port" -o StrictHostKeyChecking=no "$PATH_FILE_HOSTS" "$username"@"$ip_host":/etc/
	
			echo "============================== Done Virtual ===================================================================="	
			
		done < "$PATH_FILE_SERVER"
		
	elif [ ! -f $PATH_FILE_HOSTS ] && [ -f $PATH_FILE_SERVER ]
		then	
			echo "File $PATH_FILE_HOSTS not found !!!"
			echo "File $PATH_FILE_SERVER found !!!"
	elif [ -f $PATH_FILE_HOSTS ] && [ ! -f $PATH_FILE_SERVER ]
		then
			echo "File $PATH_FILE_HOSTS found !!!"
                        echo "File $PATH_FILE_SERVER not found !!!"
	else
		echo "File $PATH_FILE_HOSTS not found !!!"
                echo "File $PATH_FILE_SERVER not found !!!"	

	fi

}

check_file_and_run_script
