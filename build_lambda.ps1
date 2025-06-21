# Lambda 함수 패키징 스크립트
Write-Host "Building Lambda function package..." -ForegroundColor Green

# Lambda 디렉토리로 이동
Set-Location lambda

# 기존 패키지가 있다면 삭제
if (Test-Path "../lambda_function_ec2.zip") {
    Remove-Item "../lambda_function_ec2.zip" -Force
    Write-Host "Removed existing lambda_function_ec2.zip" -ForegroundColor Yellow
}

# Lambda 함수 패키징
Compress-Archive -Path "*.py" -DestinationPath "../lambda_function_ec2.zip" -Force

Write-Host "Lambda function packaged successfully!" -ForegroundColor Green
Write-Host "Package location: lambda_function_ec2.zip" -ForegroundColor Cyan

# 원래 디렉토리로 복귀
Set-Location .. 