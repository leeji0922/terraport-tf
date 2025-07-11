import json

from decrypt_with_kms import decrypt_credentials
from generate_provider import generate_provider
from generate_ec2 import generate_ec2
from save_files import save_to_s3, push_to_github

def terraport_main_ec2(event, context):
    
    # terraform 파일 생성
    terraform_files = {}
    # 환경변수 설정
    region = event['region']
    keys = decrypt_credentials(event, event['kms_key_id'])
    access_key = keys['access_key']
    secret_key = keys['secret_key']

    terraform_files['provider.tf'] = generate_provider(region, access_key, secret_key)

    # ec2 tf 파일 생성
    instance_name = event['instance_name']
    instance_type = event['instance_type']
    instance_image = event['instance_image']
    instance_key_name = event['instance_key_name']
    instance_subnet_id = event['instance_subnet_id']
    instance_security_group_id = event['instance_security_group_id']
        
    terraform_files['ec2.tf'] = generate_ec2(instance_name, instance_type, instance_image, instance_key_name, instance_subnet_id, instance_security_group_id)

    # 파일 저장 (s3 or github repo)
    save_type = event['save_type']
    if save_type == 's3':
        save_to_s3(terraform_files, event['s3_bucket_name'], event['s3_bucket_key'])
    elif save_type == 'github':
        #TODO: github repo 저장 기능 추가
        # push_to_github(terraform_files, event['github_repo_name'], event['github_repo_branch'], event['github_repo_token'], event['github_repo_key'])
        return {
            'statusCode': 400,
            'body': json.dumps('Github repo 저장 기능 추가 필요')
        }

    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Terraport!')
    }
