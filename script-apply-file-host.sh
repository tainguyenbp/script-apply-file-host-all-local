#!/bin/bash

# Setup tool sshpass via yum internet

function check_setup_sshpass() {

	value_sshpass=`rpm -qa | grep sshpass | wc -l`

	if [ "$value_sshpass" == 0 ]
		then
			echo "Installing tool sshpass via yum internet cmd: yum -y install sshpass"
			yum -y install sshpass
			echo "Done !!!"
	else
		echo "Tool sshpass installed"
		echo "Done !!!"
	fi
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "$CURRENT_DIR"

PATH_FILE_HOSTS="$CURRENT_DIR/hosts"
PATH_FILE_SERVER="$CURRENT_DIR/server-virtual-linux.csv"

function delete_line_empty_file_csv(){

		sed -i /^$/d "$PATH_FILE_SERVER"

}

function check_file_and_run_script() {
	
	if [ -f "$PATH_FILE_SERVER" ] && [ -f "$PATH_FILE_SERVER" ]
		then
			echo "File $PATH_FILE_HOSTS found !!!"
			echo "File $PATH_FILE_SERVER found !!!"
		# call function delete_line_empty_file_csv
 		delete_line_empty_file_csv
		value_line_csv=0
		while IFS=',' read -r ip_host username password port description;
			do
				if [ $value_line_csv != 0 ]
					then
						echo "Ip host : $ip_host"
						echo "Username : $username"
						echo "Password : $password"
						echo "Port ssh : $port"
						echo "Description : $description"
			
						sshpass -p"$password" scp -r -P"$port" -o StrictHostKeyChecking=no "$PATH_FILE_HOSTS" "$username"@"$ip_host":/etc/
	
						echo "============================== Done Virtual ===================================================================="	
				fi
				value_line_csv=$value_line_csv+1
			
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
check_setup_sshpass
check_file_and_run_script

