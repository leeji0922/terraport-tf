# Terraport Terraform Infrastructure

이 프로젝트는 AWS에서 VPC 망분리, Lambda 함수, API Gateway, RDS를 구성하는 Terraform 인프라 코드입니다.

## 아키텍처

```
 Internet
    │
    ▼
┌─────────────────┐
│  API Gateway    │
└─────────────────┘
    │
    │
    ▼
┌─────────────────┐    ┌────────────────────┐
│   Public        │    │   Private          │
│   Subnets       │    │   Subnets          │
│                 │    │                    │
│ 10.10.1.0/24    │    │  10.10.10.0/24     │
│ 10.10.2.0/24    │    │  10.10.11.0/24     │
│                 │    │  ┌──────────────┐  │
│                 │    │  │   Lambda     │  │
│                 │    │  │  Functions   │  │
│                 │    │  └──────────────┘  │
│                 │    │        │           │
│                 │    │        ▼           │
│ ┌─────────────┐ │    │  ┌─────────────┐   │
│ │ NAT Gateway │ │◄───┤  │     RDS     │   │
│ │             │ │    │  │  Database   │   │
│ └─────────────┘ │    │  │  (History)  │   │
│                 │    │  └─────────────┘   │
│ ┌─────────────┐ │    └────────────────────┘
│ │  Bastion    │ │
│ │   Host      │ │
│ └─────────────┘ │
└─────────────────┘
```

## 구성 요소

### VPC (10.10.0.0/16)
- **Public Subnets**: 10.10.1.0/24, 10.10.2.0/24
- **Private Subnets**: 10.10.10.0/24, 10.10.11.0/24
- **Internet Gateway**: 외부 인터넷 연결
- **NAT Gateway**: Private 서브넷의 외부 통신

### Lambda Functions
- **EC2 Function**: EC2 관련 처리
- **Provider Function**: Provider 생성 처리
- **Save Files Function**: 파일 저장 처리
- Python 3.12 런타임
- Private 서브넷에 배치
- RDS 데이터베이스와 통신

### API Gateway
- REST API
- Lambda 프록시 통합
- CORS 지원

### RDS
- PostgreSQL 15.4
- Private 서브넷에 배치
- Lambda 함수에서만 접근 가능

## 파일 구조

```
terraport-tf/
├── providers.tf                          # Terraform provider 설정
├── variables.tf                          # 변수 정의
├── vpc.tf                                # VPC, 서브넷, 라우팅 테이블
├── security.tf                           # 보안 그룹, IAM 역할
├── lambda.tf                             # Lambda 함수들
├── api-gateway.tf                        # API Gateway
├── outputs.tf                            # 배포 후 확인할 정보
├── lambda/                               # Lambda 소스 코드
│   ├── ec2-function/                     # EC2 람다 함수
│   │   └── terraport_main_ec2.py
│   ├── provider-function/                # Provider 람다 함수
│   │   └── generate_provider.py
│   └── save-files-function/              # Save Files 람다 함수
│       └── save_files.py
├── build_lambda_ec2.ps1                  # EC2 람다 패키징 스크립트
├── build_lambda_provider.ps1             # Provider 람다 패키징 스크립트
├── build_lambda_save_files.ps1           # Save Files 람다 패키징 스크립트
├── build_all_lambda.ps1                  # 모든 람다 패키징 스크립트
├── README.md                             # 프로젝트 문서
└── .gitignore                            # Git 무시 파일
```

## 사전 요구사항

1. **Terraform** (>= 1.0)
2. **AWS CLI** 설정
3. **PowerShell** (Windows)

## 사용법

### 1. AWS 자격 증명 설정
```powershell
aws configure
```

### 2. Lambda 함수 패키징

#### 개별 람다 함수 빌드
```powershell
# EC2 람다 함수만 빌드
.\build_lambda_ec2.ps1

# Provider 람다 함수만 빌드
.\build_lambda_provider.ps1

# Save Files 람다 함수만 빌드
.\build_lambda_save_files.ps1
```

#### 모든 람다 함수 한 번에 빌드
```powershell
.\build_all_lambda.ps1
```

### 3. Terraform 초기화
```powershell
terraform init
```

### 4. 계획 확인
```powershell
terraform plan
```

### 5. 인프라 배포
```powershell
terraform apply
```

### 6. 인프라 삭제
```powershell
terraform destroy
```

## 변수 설정

`variables.tf` 파일에서 다음 변수들을 수정할 수 있습니다:

- `aws_region`: AWS 리전 (기본값: ap-northeast-2)
- `project_name`: 프로젝트 이름 (기본값: terraport)
- `availability_zones`: 가용 영역
- `public_subnets`: Public 서브넷 CIDR 블록
- `private_subnets`: Private 서브넷 CIDR 블록

## 출력 값

배포 후 다음 정보들을 확인할 수 있습니다:

- VPC ID 및 CIDR
- Public/Private 서브넷 ID
- Lambda 함수들 이름 및 ARN
  - EC2 Lambda Function
  - Provider Lambda Function
  - Save Files Lambda Function
- API Gateway URL
- NAT Gateway ID

## 보안 고려사항

- Lambda 함수들은 Private 서브넷에 배치되어 외부에서 직접 접근 불가
- NAT Gateway를 통해서만 외부 통신 가능
- Security Group으로 네트워크 트래픽 제어
- IAM 역할과 정책으로 최소 권한 원칙 적용

## 비용 최적화

- NAT Gateway는 시간당 요금이 발생하므로 필요시에만 사용
- Lambda 함수는 실행 시간에 따라 과금
- API Gateway는 요청 수에 따라 과금

## 문제 해결

### Lambda 함수가 외부에 접근할 수 없는 경우
1. NAT Gateway가 올바르게 구성되었는지 확인
2. Lambda 함수의 Security Group 설정 확인
3. Private 서브넷의 라우팅 테이블 확인

### API Gateway에서 500 에러가 발생하는 경우
1. Lambda 함수의 권한 설정 확인
2. Lambda 함수의 로그 확인 (CloudWatch)
3. API Gateway의 통합 설정 확인

### 특정 람다 함수만 업데이트하고 싶은 경우
1. 해당 람다 함수의 소스 코드만 수정
2. 해당 람다 함수만 빌드 (예: `.\build_lambda_ec2.ps1`)
3. `terraform apply` 실행하여 해당 람다 함수만 업데이트 