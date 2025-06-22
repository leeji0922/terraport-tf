# EC2 Lambda 함수 패키징 스크립트
Write-Host "Building EC2 Lambda function package..." -ForegroundColor Green

# Lambda EC2 디렉토리로 이동
Set-Location lambda\ec2-function

# 기존 패키지가 있다면 삭제
if (Test-Path "../../lambda_ec2.zip") {
    Remove-Item "../../lambda_ec2.zip" -Force
    Write-Host "Removed existing lambda_ec2.zip" -ForegroundColor Yellow
}

# Lambda 함수 패키징
Compress-Archive -Path "*.py" -DestinationPath "../../lambda_ec2.zip" -Force

Write-Host "EC2 Lambda function packaged successfully!" -ForegroundColor Green
Write-Host "Package location: lambda_ec2.zip" -ForegroundColor Cyan

# 원래 디렉토리로 복귀
Set-Location ..\.. 