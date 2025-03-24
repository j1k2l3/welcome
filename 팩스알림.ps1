# ���� ��å ���� (�� ���� �ʿ�)
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# System.Windows.Forms ���̺귯�� �ε�
Add-Type -AssemblyName System.Windows.Forms

# ���� ���� ��� ����
$folderPath = "\\192.168.219.107\fax" # ������ ���� ���
$watcher = New-Object System.IO.FileSystemWatcher
$watcher.Path = $folderPath
$watcher.Filter = "*.*" # ��� ���� ����
$watcher.IncludeSubdirectories = $true # ���� ������ ����
$watcher.EnableRaisingEvents = $true

# �̺�Ʈ Ʈ����(���� ���� �� ����Ǵ� ����)
Register-ObjectEvent $watcher Created -Action {
    $filePath = $Event.SourceEventArgs.FullPath
    $fileName = $Event.SourceEventArgs.Name

    # �ߺ� ������ ���� ó���� ���� ���� ����
    if (-not $script:processedFiles) {
        $script:processedFiles = @{}
    }

    # ���� �ð� ��������
    $currentTime = Get-Date

    # �̹� ó���� �������� Ȯ�� (1�� �� ���� ���� ����)
    if ($script:processedFiles[$filePath] -and ($currentTime - $script:processedFiles[$filePath]).TotalSeconds -lt 1) {
        return
    }

    # ó���� ���� �ð� ������Ʈ
    $script:processedFiles[$filePath] = $currentTime

    # �ֿܼ� �޽��� ���
    Write-Host "�� ���� ����: $filePath"

    # �˾� �޽��� ǥ�� (�ֻ��� â���� ����)
    [System.Windows.Forms.MessageBox]::Show("�ѽ��� ���� �Ǿ����ϴ�. Ȯ�����ּ���.", "�ѽ� �˸�", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information, [System.Windows.Forms.MessageBoxDefaultButton]::Button1, [System.Windows.Forms.MessageBoxOptions]::DefaultDesktopOnly)
}

# ���� ��� ���� (��ũ��Ʈ ���� ����)
while ($true) {
    Start-Sleep -Seconds 1
}
