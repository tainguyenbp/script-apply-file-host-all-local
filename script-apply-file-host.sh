#!/bin/bash
RED='\033[0;31m'
NC='\033[0m'
GREEN='\033[0;32m'

# Setup tool sshpass via yum internet

function check_setup_sshpass() {
	echo -e "${GREEN}===================================================================================================================${NC}"
	value_sshpass=`rpm -qa | grep sshpass | wc -l`

	if [ "$value_sshpass" == 0 ]
		then
			echo -e "${GREEN}Installing tool sshpass via yum internet cmd: yum -y install sshpass${NC}"
			yum -y install sshpass
			echo -e "${GREEN}Done !!!${NC}"
	else
		echo -e "${GREEN}Tool sshpass installed${NC}"
		echo -e "${GREEN}Done !!!${NC}"
	fi
}

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

PATH_FILE_HOSTS="$CURRENT_DIR/hosts"
PATH_FILE_SERVER="$CURRENT_DIR/server-virtual-linux.csv"

function delete_line_empty_file_csv(){

		sed -i /^$/d "$PATH_FILE_SERVER"

}

function check_file_and_run_script() {
	echo -e "${GREEN}============================== Apply File Hosts To Client  !!! ======================================================${NC}"	
	if [ -f "$PATH_FILE_SERVER" ] && [ -f "$PATH_FILE_SERVER" ]
		then
			echo -e "${GREEN}File $PATH_FILE_HOSTS found !!!${NC}"
			echo -e "${GREEN}File $PATH_FILE_SERVER found !!!${NC}"
		# call function delete_line_empty_file_csv
 		delete_line_empty_file_csv
		value_line_csv=0
		while IFS=',' read -r ip_host username password port description;
			do
				if [ $value_line_csv != 0 ]
					then
						echo -e "${GREEN}Ip host : $ip_host${NC}"
						echo -e "${GREEN}Username : $username${NC}"
						echo -e "${GREEN}Password : $password${NC}"
						echo -e "${GREEN}Port ssh : $port${NC}"
						echo -e "${GREEN}Description : $description${NC}"
			
						sshpass -p"$password" scp -r -P"$port" -o StrictHostKeyChecking=no "$PATH_FILE_HOSTS" "$username"@"$ip_host":/etc/
	
						echo -e "${GREEN}============================== Done Virtual !!! ======================================================${NC}"	
				fi
				value_line_csv=$value_line_csv+1
			
		done < "$PATH_FILE_SERVER"
		
	elif [ ! -f $PATH_FILE_HOSTS ] && [ -f $PATH_FILE_SERVER ]
		then	
			echo -e "${RED}[Waring] File $PATH_FILE_HOSTS not found !!!${NC}"
			echo -e "${GREEN}File $PATH_FILE_SERVER found !!!${NC}"
	elif [ -f $PATH_FILE_HOSTS ] && [ ! -f $PATH_FILE_SERVER ]
		then
			echo -e "${GREEN}File $PATH_FILE_HOSTS found !!!${NC}"
                        echo -e "${RED}[Waring] File $PATH_FILE_SERVER not found !!!${NC}"
	else
		echo -e "${RED}[Waring] File $PATH_FILE_HOSTS not found !!!${NC}"
                echo -e "${RED}[Waring] File $PATH_FILE_SERVER not found !!!${NC}"	

	fi

}
check_setup_sshpass
check_file_and_run_script

