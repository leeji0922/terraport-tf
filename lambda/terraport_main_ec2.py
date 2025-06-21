import json
import boto3
import base64
from botocore.exceptions import ClientError

from generate_provider import generate_provider
from generate_ec2 import generate_ec2
from save_files import save_to_s3, push_to_github

# KMS 복호화 함수
def decrypt_with_kms(encrypted_data, kms_key_id):
    kms_client = boto3.client('kms')
    try :
        ciphertext_blob = base64.b64decode(encrypted_data)
        decrypt_params = {
            'CiphertextBlob': ciphertext_blob,
            'KeyId': kms_key_id
        }

        response = kms_client.decrypt(**decrypt_params)

        return response['Plaintext'].decode('utf-8')
    except ClientError as e:
        error_code = e.response['Error']['Code']
        if error_code == 'InvalidCiphertextException':
            print(f"잘못된 암호화된 데이터: {e}")
        elif error_code == 'AccessDeniedException':
            print(f"KMS 접근 권한 없음: {e}")
        elif error_code == 'NotFoundException':
            print(f"KMS 키를 찾을 수 없음: {e}")
        else:
            print(f"KMS 복호화 오류: {e}")
        raise
    except Exception as e:
        print(f"예상치 못한 오류: {e}")
        raise

# 복호화 헬퍼 함수
def decrypt_credentials(event, kms_key_id):
    return {
        'access_key': decrypt_with_kms(event['access_key'], kms_key_id),
        'secret_key': decrypt_with_kms(event['secret_key'], kms_key_id)
    }

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
