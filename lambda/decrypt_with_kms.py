import boto3
import base64
from botocore.exceptions import ClientError

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