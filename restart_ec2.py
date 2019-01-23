#!python
import boto3
import botocore
import logging
import os
from collections import defaultdict

ec2 = boto3.resource('ec2')

# Set up logging
logger = logging.getLogger("reboot_ec2_logging")
logger.setLevel(logging.INFO)
formatter = logging.Formatter("%(asctime)s|%(levelname)s|%(message)s", "%Y-%m-%d %H:%M:%S")

# Create console logger
ch = logging.StreamHandler()
ch.setFormatter(formatter)

# https://boto3.amazonaws.com/v1/documentation/api/latest/guide/migrationec2.html#checking-what-instances-are-running
# Main function. This is the entrypoint for AWS Lambda
def handler(event, context):
    # Get list of EC2 instances that have been passed in to this function
    if 'IDS' not in os.environ:
        logger.error("Please pass in the list of EC2 ids that you want to monitor. The list needs to be passed in via the environment variable 'IDS' and each id needs to be separated by a '|' symbol.")
        return True

    if 'DEBUG' in os.environ and "1" == os.environ['DEBUG']:
        logger.setLevel(logging.DEBUG)

    ids = os.environ['IDS'].split("|")
    instances = {ids[i] : 1 for i in range(0, len(ids))}
    logger.debug("Monitoring EC2s with the following ids: " + str(instances.keys()))

    logger.debug("Checking instances...")

    # Get list of instances that are not running and restart any that are not running. It would be nicer to use filters here.
    for instance in ec2.instances.all():
        # instance is an instance of ec2.Instance (https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#instance)
        logger.debug("Found EC2 instance with an id of " + instance.id)

        if instance.id in instances:
            logger.info("Checking EC2 with an id of " + instance.id)
            logger.debug("State of " + instance.id + " is " + instance.state['Name'] + ". State code is " + str(instance.state['Code']))

            if instance.state['Name'] == 'stopped':
                logger.warn("EC2 instance with id of " + instance.id + " has stopped. Restarting it")
                # https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/ec2.html#EC2.ServiceResource.start
                response = instance.start(DryRun=False)

            elif instance.state['Name'] == 'running':
                logger.info("EC2 instance with an id of " + instance.id + " is running (public ip address is " + instance.public_ip_address + ")")
            else:
                logger.info("EC2 instance with an id of " + instance.id + " has a status of '" + instance.state['Name'] + "'")

    return False

# For testing the script
if __name__ == "__main__":
    # Add test data here
    # Test function
    handler(test, None)
