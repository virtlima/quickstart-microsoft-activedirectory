#!/bin/bash +ex
# author tonynv@amazon.com
#

VERSION=2.1
# This script validates the cloudformation template then executes stack creation
# Note: build server need to have aws cli install and configure with proper permissions

EXEC_DIR=`pwd`
echo "Starting execution in ${EXEC_DIR}"
#Set Debug 0=ON 1=OFF
DEBUG=0
# Get Change details for DEBUG

# SET PARMS
APPNAME=qstester
TEMPLATE_DIR="/root/QS_MSActiveDirectory/cf_template"

# Set up Logging
NOW=$(date +"%F")
EPOC=$(date +"%s")
LOGDIR=/var/log/${APPNAME}
LOG=${LOGDIR}/deploy.${EPOC}.log

printf "Checking for Log directory"
        if [ -d ${LOGDIR} ];
        then 
	echo "(found)"
	echo
         
        else 
	mkdir -p ${LOGDIR}
	echo

        fi

# Check for proper folder and file structure
printf "Checking for Template directory "
if [ -d "$TEMPLATE_DIR" ]; then
	echo "(found)";

	printf "Checking for Template file "
        TEMPLATE_FILE=$(/bin/ls -1  $TEMPLATE_DIR | grep .json$)
        if [ -f ${TEMPLATE_DIR}/${TEMPLATE_FILE} ]; then
		echo "(found)";
	else 
		echo "(not found)";
		exit 1;
        fi

else
	echo "(not found)"; 
	exit 1;
fi

# Validate Cloud formation template
if which aws >/dev/null; then
    echo "Looking for awscli:(found)"
else
    echo "Looking for awscli:(not found)"
    echo "Please install awscli and add it to the runtime path"
    exit 1;
fi
aws cloudformation validate-template --region=us-west-1 --template-body  file://${TEMPLATE_DIR}/${TEMPLATE_FILE}; VALIDATED=$?

   printf "Validating Template file "
        if [ ${VALIDATED} -ne 0 ];
        then echo "(fail)"; 
        else echo "(pass)";
        fi
