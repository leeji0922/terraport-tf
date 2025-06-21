# RDS 통합 가이드

## 현재 상황 분석

### ✅ 이미 올바르게 구성된 부분:
- Lambda 함수가 Private 서브넷에 배치됨 (`aws_subnet.private[*].id`)
- Lambda VPC 접근 권한 설정됨
- NAT Gateway를 통한 외부 통신 가능

### ❌ 추가로 필요한 부분:
- RDS 데이터베이스 리소스
- RDS용 보안 그룹
- Lambda에서 RDS로의 접근을 위한 보안 그룹 규칙

## 필요한 리소스 추가

### 1. RDS 보안 그룹 추가 (security.tf)

```terraform
# RDS Security Group
resource "aws_security_group" "rds" {
  name_prefix = "${var.project_name}-rds-sg"
  vpc_id      = aws_vpc.main.id

  # Lambda에서 RDS로의 접근 허용
  ingress {
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda.id]
    description     = "Allow Lambda to access RDS"
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}
```

### 2. RDS 리소스 생성 (rds.tf)

```terraform
# RDS Subnet Group
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

# RDS Instance
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-db"
  
  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"
  
  allocated_storage     = 20
  max_allocated_storage = 100
  storage_type          = "gp2"
  storage_encrypted     = true
  
  db_name  = "terraport"
  username = "terraport_admin"
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.rds.id]
  db_subnet_group_name   = aws_db_subnet_group.main.name
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  skip_final_snapshot = true
  deletion_protection = false
  
  tags = {
    Name = "${var.project_name}-db"
  }
}
```

### 3. 변수 추가 (variables.tf)

```terraform
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

### 4. Lambda 환경 변수 추가 (lambda.tf)

```terraform
environment {
  variables = {
    PYTHONPATH     = "/var/task"
    DB_HOST        = aws_db_instance.main.endpoint
    DB_PORT        = aws_db_instance.main.port
    DB_NAME        = aws_db_instance.main.db_name
    DB_USER        = aws_db_instance.main.username
    DB_PASSWORD    = var.db_password
  }
}
```

### 5. 출력 추가 (outputs.tf)

```terraform
output "rds_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.main.endpoint
}

output "rds_port" {
  description = "RDS port"
  value       = aws_db_instance.main.port
}
```

## 배포 방법

```powershell
terraform apply -var="db_password=your_secure_password"
```

## 아키텍처 특징

1. **Lambda 함수**는 Private 서브넷에 위치
2. **RDS**도 Private 서브넷에 위치 (DB Subnet Group 사용)
3. **보안 그룹**으로 Lambda에서 RDS로의 접근만 허용
4. **NAT Gateway**를 통해 Lambda가 외부 패키지 다운로드 가능
5. **환경 변수**로 데이터베이스 연결 정보 제공

## 보안 이점

- 외부에서 직접 RDS 접근 불가
- Lambda에서만 RDS 접근 가능
- Private 서브넷을 통한 네트워크 격리
- 암호화된 스토리지 사용 