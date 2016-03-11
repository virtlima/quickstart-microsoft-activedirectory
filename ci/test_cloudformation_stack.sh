#!/bin/bash +ex
# author tonynv@amazon.com
#

VERSION=2.1
# This script validates the cloudformation template then executes stack creation
# Note: build server need to have aws cli install and configure with proper permissions

EXEC_DIR=`pwd`
echo "----------START-----------"
echo "Timestamp: `date`"
echo "Starting execution in ${EXEC_DIR}"

# SET PARMS
PARMS=0
EPOC=$(date +"%s")
APPNAME=QS_MSActiveDirectory
TEMPLATE_DIR="/root/QS_MSActiveDirectory/cf_template"
#ID=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 4 | head -n 1)
ID=`hexdump -n 5 -v -e '/1 "%02X"' /dev/urandom`

# Check for AWS Cli
if which aws >/dev/null; then
    echo "Looking for awscli:(found)"
else
    echo "Looking for awscli:(not found)"
    echo "Please install awscli and add it to the runtime path"
    exit 1;
fi

# Set Default Region 
REGION_DEFAULT="us-east-1"
# Get Region List
REGION_LIST=$(aws ec2 describe-regions --region ${REGION_DEFAULT} --output table | awk '{print $4}' | grep "^[a-z].\+[0-9]$")

## Check for TEMPLATE_DIR
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

# Check for region file
if [ -f ${TEMPLATE_DIR}/_region ]; then
	        
		echo "Getting region list"
                echo "Using region in file ${TEMPLATE_DIR}/_region}"
		echo "Checking if region is valid"
		REGION=$(<${TEMPLATE_DIR}/_region)
		VALID_REGION=`echo ${REGION_LIST} | grep ${REGION}`

		if (( $? == 0 )); then
			echo "Region set to ${REGION}"
		else
			echo "Region ${REGION} is invalid using default region ${REGION_DEFAULT} "
		fi
        else
		REGION=${REGION_DEFAULT}
		echo "Not _region file found"
                echo "(using default region)$REGION";
        fi

printf "Checking for stack parameter file "
PARAM_FILE="_parameter"

        if [ -f ${TEMPLATE_DIR}/${PARAM_FILE} ]; then
		echo "(found)";
	        echo "This Cloudformation template will use  parameter file ${TEMPLATE_DIR}/${PARAM_FILE}"
		PARAM_INPUT=`cat ${TEMPLATE_DIR}/${PARAM_FILE} | grep -v "^#"`
		PARMS=1
	else 
		echo "(not found)";
	        echo "This Cloudformation template does not use the parameter file"
        fi

STACKDES=`echo ${APPNAME}|tr -cd '[[:alnum:]]'`
STACKNAME="${STACKDES}0x$ID"
echo "Requesting cloudformation name=${STACKNAME}"

if [ $PARMS -eq 1 ]; then
	aws cloudformation create-stack --stack-name ${STACKNAME} --disable-rollback --capabilities CAPABILITY_IAM  --region ${REGION} --template-body file://${TEMPLATE_DIR}/${TEMPLATE_FILE} --parameters ${PARAM_INPUT}

else 
	aws cloudformation create-stack --stack-name ${STACKNAME} --disable-rollback --capabilities CAPABILITY_IAM --region ${REGION} --template-body file://${TEMPLATE_DIR}/${TEMPLATE_FILE}

fi

# Build Stack Query
QUERY="'Stacks[?StackName==\`${STACKNAME}\`].StackStatus'"
CFGET_STATUS="aws cloudformation --region ${REGION}  describe-stacks  --query ${QUERY} --output=text"

CF_STATUS=`bash <(echo $CFGET_STATUS)`

echo "$CF_STATUS"
while [[ $CF_STATUS == "CREATE_IN_PROGRESS" ]]; do sleep 10; echo "Waiting for stack-create to complete"; CF_STATUS=`bash <(echo $CFGET_STATUS)`;  done

sleep 2;
CF_STATUS=`bash <(echo $CFGET_STATUS)`

if [ $CF_STATUS == "CREATE_COMPLETE" ];  then
   echo "Stack created successful" 
else 
   echo "Stack creation failed"
   exit 1;
fi 

# Delete Stack (Cleanup)
echo "Starting cleanup of ${STACKNAME}"
aws cloudformation delete-stack --stack-name ${STACKNAME} --region ${REGION}
sleep 2;

CF_DELETE=`bash <(echo $CFGET_STATUS)`

while [[ $CF_DELETE == "DELETE_IN_PROGRESS" ]]; do sleep 10; echo "Waiting for stack-delete to complete"; CF_DELETE=`bash <(echo $CFGET_STATUS)`;  done

CF_DELETE=`bash <(echo $CFGET_STATUS)`

if [ CF_DELETE != "DELETE_COMPLETE" ];  then
   echo "Stack delete (complete)" 
   echo "Test result  (success)" 
else 
   echo "Stack delete (failed)"
   echo "Stack in status ${CF_STATUS}"
fi 
echo "----------END-----------"
rm -rf /root/$APPNAME
touch /root/$APPNAME.cleaned


