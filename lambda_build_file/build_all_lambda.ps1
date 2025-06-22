# 모든 Lambda 함수 패키징 스크립트
Write-Host "Building all Lambda function packages..." -ForegroundColor Green

# 각 람다 함수별로 빌드 실행
Write-Host "`n=== Building EC2 Lambda Function ===" -ForegroundColor Cyan
& .\build_lambda_ec2.ps1


Write-Host "`n=== Building Subnet List Lambda Function ===" -ForegroundColor Cyan
& .\build_lambda_subnet_list.ps1

Write-Host "`n=== All Lambda functions built successfully! ===" -ForegroundColor Green
Write-Host "Generated packages:" -ForegroundColor Yellow
Write-Host "- lambda_ec2.zip" -ForegroundColor White
Write-Host "- lambda_subnet_list.zip" -ForegroundColor White 