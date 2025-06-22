import boto3
import json

from decrypt_with_kms import decrypt_credentials

def get_subnet_list(event, context):
    """
    boto3를 사용해서 AWS 서브넷 목록을 추출하는 함수
    
    Args:
        event (dict): 이벤트 데이터
            - region: AWS 리전
            - kms_key_id: KMS 키 ID (자격 증명 복호화용)
            - vpc_id: 특정 VPC ID (선택사항)
            - filters: 추가 필터 (선택사항)
        context: Lambda 컨텍스트
    
    Returns:
        dict: 서브넷 목록 정보
    """
    
    try:
        # 이벤트에서 파라미터 추출
        region = event.get('region', 'ap-northeast-2')
        vpc_id = event.get('vpc_id')
        filters = event.get('filters', [])
        
        # KMS를 통한 자격 증명 복호화 (필요한 경우)
        if 'kms_key_id' in event:
            keys = decrypt_credentials(event, event['kms_key_id'])
            access_key = keys['access_key']
            secret_key = keys['secret_key']
            
            # 자격 증명으로 EC2 클라이언트 생성
            ec2_client = boto3.client(
                'ec2',
                region_name=region,
                aws_access_key_id=access_key,
                aws_secret_access_key=secret_key
            )
        else:
            # 기본 자격 증명 사용 (IAM 역할 또는 환경 변수)
            ec2_client = boto3.client('ec2', region_name=region)
        
        # 서브넷 목록 조회를 위한 파라미터 구성
        params = {}
        
        # VPC ID 필터 추가
        if vpc_id:
            params['Filters'] = [{'Name': 'vpc-id', 'Values': [vpc_id]}]
        
        # 서브넷 목록 조회
        response = ec2_client.describe_subnets(**params)
        
        # 결과 정리
        subnets = []
        for subnet in response['Subnets']:
            subnet_info = {
                'SubnetId': subnet['SubnetId'],
                'VpcId': subnet['VpcId'],
                'CidrBlock': subnet['CidrBlock'],
                'AvailabilityZone': subnet['AvailabilityZone'],
                'State': subnet['State'],
                'AvailableIpAddressCount': subnet['AvailableIpAddressCount'],
                'Tags': subnet.get('Tags', [])
            }
            subnets.append(subnet_info)
        
        return {
            'statusCode': 200,
            'body': {
                'message': 'Subnet list retrieved successfully',
                'count': len(subnets),
                'subnets': subnets,
                'region': region
            }
        }
        
    except Exception as e:
        return {
            'statusCode': 500,
            'body': {
                'message': f'Error retrieving subnet list: {str(e)}',
                'error': str(e)
            }
        }

def get_subnet_list_by_vpc(event, context):
    """
    특정 VPC의 서브넷 목록만 조회하는 함수
    """
    vpc_id = event.get('vpc_id')
    if not vpc_id:
        return {
            'statusCode': 400,
            'body': {
                'message': 'vpc_id is required'
            }
        }
    
    return get_subnet_list(event, context)

def get_public_subnets(event, context):
    """
    Public 서브넷만 조회하는 함수
    """
    filters = [{'Name': 'map-public-ip-on-launch', 'Values': ['true']}]
    event['filters'] = filters
    return get_subnet_list(event, context)

def get_private_subnets(event, context):
    """
    Private 서브넷만 조회하는 함수
    """
    filters = [{'Name': 'map-public-ip-on-launch', 'Values': ['false']}]
    event['filters'] = filters
    return get_subnet_list(event, context)