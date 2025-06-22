# Save Files Lambda 함수 패키징 스크립트
Write-Host "Building Save Files Lambda function package..." -ForegroundColor Green

# Lambda Save Files 디렉토리로 이동
Set-Location lambda\save-files-function

# 기존 패키지가 있다면 삭제
if (Test-Path "../../lambda_save_files.zip") {
    Remove-Item "../../lambda_save_files.zip" -Force
    Write-Host "Removed existing lambda_save_files.zip" -ForegroundColor Yellow
}

# Lambda 함수 패키징
Compress-Archive -Path "*.py" -DestinationPath "../../lambda_save_files.zip" -Force

Write-Host "Save Files Lambda function packaged successfully!" -ForegroundColor Green
Write-Host "Package location: lambda_save_files.zip" -ForegroundColor Cyan

# 원래 디렉토리로 복귀
Set-Location ..\.. 