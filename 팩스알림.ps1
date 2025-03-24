# 실행 정책 설정 (한 번만 필요)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# System.Windows.Forms 라이브러리 로드
Add-Type -AssemblyName System.Windows.Forms

# 공유 폴더 경로 설정
$folderPath = "\\192.168.219.107\fax" # 감시할 폴더 경로
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderPath
$watcher.Filter = "*.*" # 모든 파일 감지
$watcher.IncludeSubdirectories = $true # 하위 폴더도 포함
$watcher.EnableRaisingEvents = $true

# 이벤트 트리거(파일 생성 시 실행되는 동작)
Register-ObjectEvent $watcher Created -Action {
    $filePath = $Event.SourceEventArgs.FullPath
    $fileName = $Event.SourceEventArgs.Name

    # 중복 방지를 위한 처리된 파일 정보 저장
    if (-not $script:processedFiles) {
        $script:processedFiles = @{}
    }

    # 현재 시간 가져오기
    $currentTime = Get-Date

    # 이미 처리된 파일인지 확인 (1초 내 동일 파일 무시)
    if ($script:processedFiles[$filePath] -and ($currentTime - $script:processedFiles[$filePath]).TotalSeconds -lt 1) {
        return
    }

    # 처리된 파일 시간 업데이트
    $script:processedFiles[$filePath] = $currentTime

    # 콘솔에 메시지 출력
    Write-Host "새 파일 생성: $filePath"

    # 팝업 메시지 표시 (최상위 창으로 설정)
    [System.Windows.Forms.MessageBox]::Show("팩스가 수신 되었습니다. 확인해주세요.", "팩스 알림", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)
}

# 무한 대기 루프 (스크립트 지속 실행)
while ($true) {
    Start-Sleep -Seconds 1
}
