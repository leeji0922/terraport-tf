# Subnet List Lambda 함수 패키징 스크립트
Write-Host "Building Subnet List Lambda function package..." -ForegroundColor Green

# Lambda Subnet List 디렉토리로 이동
Set-Location lambda\get-subnet-list-function

# 기존 패키지가 있다면 삭제
if (Test-Path "../../lambda_subnet_list.zip") {
    Remove-Item "../../lambda_subnet_list.zip" -Force
    Write-Host "Removed existing lambda_subnet_list.zip" -ForegroundColor Yellow
}

# Lambda 함수 패키징
Compress-Archive -Path "*.py" -DestinationPath "../../lambda_subnet_list.zip" -Force

Write-Host "Subnet List Lambda function packaged successfully!" -ForegroundColor Green
Write-Host "Package location: lambda_subnet_list.zip" -ForegroundColor Cyan

# 원래 디렉토리로 복귀
Set-Location ..\.. 