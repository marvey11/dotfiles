#! /bin/bash

#
# Depends on the AWS Command Line Interface --> see https://aws.amazon.com/cli/
#
# Also, requires the CLI to be configured --> run "aws configure" if it isn't yet
#

function get_ec2_instance_ids()
{
    aws ec2 describe-instances --output text --query 'Reservations[*].Instances[*].[InstanceId]'
}

#
# Returns the public DNS names for all instances or for only a selected one.
#
# Optional parameter is an EC2 instance ID which will print the DNS name only for that instance.
#
function get_ec2_public_dns()
{
    local instance_id=$1

    if [[ -n ${instance_id} ]]; then
        query_string="Reservations[*].Instances[?InstanceId=='${instance_id}'].[PublicDnsName]"
    else
        query_string="Reservations[*].Instances[*].[PublicDnsName]"
    fi

    aws ec2 describe-instances --output text --query ${query_string}
}

#
# Returns the public IP addresses for all instances or for only a selected one.
#
# Optional parameter is an EC2 instance ID which will print the IP address only for that instance.
#
function get_ec2_public_ips()
{
    local instance_id=$1

    if [[ -n ${instance_id} ]]; then
        query_string="Reservations[*].Instances[?InstanceId=='${instance_id}'].[PublicIpAddress]"
    else
        query_string="Reservations[*].Instances[*].[PublicIpAddress]"
    fi

    aws ec2 describe-instances --output text --query ${query_string}
}
