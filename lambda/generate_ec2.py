import json
import boto3

def generate_ec2(instance_name, instance_type, instance_image, instance_key_name, instance_subnet_id, instance_security_group_id):
    
    
    return f'''
        resource "aws_instance" "terraport_ec2" {{
            ami           = "{instance_image}"
            instance_type = "{instance_type}"
            key_name      = "{instance_key_name}"
            subnet_id     = "{instance_subnet_id}"
            security_groups = ["{instance_security_group_id}"]
            tags = {{
                Name = "{instance_name}"
            }}
        }}
    '''