<#
PowerShell�p�v���t�@�C���ݒ� for Windows10(PowerShell 5.1)

PS>notepad $profile

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# �R�}���h���C���̑��샂�[�h��Emacs�n�ɂ���E�x�����������E�q�X�g���̏d�����Ȃ���
Set-PSReadlineOption -EditMode Emacs -BellStyle None -HistoryNoDuplicates

# �J�����g�f�B���N�g���̐ݒ�
Set-Location C:\usr\GitHub\MyScript\PowerShell

# �^�C�g����ݒ肷��
$a = (Get-Host).UI.RawUI 
$add_str = " - Yutaka Hirata"
if (! $a.WindowTitle.Contains($add_str)) {
   $a.WindowTitle += $add_str
}

# F2�L�[�������ƁA�s�S�̂�I����Ԃɂ���B
#Set-PSReadlineKeyHandler -Key F2 -Function SelectAll


#
# F2�L�[�������ƁA�s�S�̂�I����Ԃɂ��āA�N���b�v�{�[�h�փR�s�[����B
#
Set-PSReadlineKeyHandler -Chord F2 `
                         -BriefDescription SelectEntireCommandLine `
                         -Description "Selects the entire command line" `
                         -ScriptBlock {
    param($key, $arg)
  
    [Microsoft.PowerShell.PSConsoleReadLine]::BeginningOfLine($key, $arg)
  
    $line = $null
    $cursor = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)

    # �I����Ԃɂ���  
    while ($cursor -lt $line.Length) {
        [Microsoft.PowerShell.PSConsoleReadLine]::SelectForwardChar($key, $arg)
        [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$line, [ref]$cursor)
    }

    # �N���b�v�{�[�h�֑��M����
    [Microsoft.PowerShell.PSConsoleReadLine]::CopyOrCancelLine($key, $arg)
}



#
# F7�L�[�������ƁA���L�q�X�g���t�@�C������ߋ��̗�����\������ёI���\�ɂȂ�B
# 
# (get-psreadlineoption).HistorySavePath
# C:\Users\yutaka\AppData\Roaming\Microsoft\Windows\PowerShell\PSReadline\ConsoleHost_history.txt
#
Set-PSReadlineKeyHandler -Key F7 `
                         -BriefDescription History `
                         -LongDescription 'Show command history' `
                         -ScriptBlock {
    $pattern = $null
    [Microsoft.PowerShell.PSConsoleReadLine]::GetBufferState([ref]$pattern, [ref]$null)
    if ($pattern)
    {
        $pattern = [regex]::Escape($pattern)
    }

    $history = [System.Collections.ArrayList]@(
        $last = ''
        $lines = ''
        foreach ($line in [System.IO.File]::ReadLines((Get-PSReadlineOption).HistorySavePath))
        {
            if ($line.EndsWith('`'))
            {
                $line = $line.Substring(0, $line.Length - 1)
                $lines = if ($lines)
                {
                    "$lines`n$line"
                }
                else
                {
                    $line
                }
                continue
            }

            if ($lines)
            {
                $line = "$lines`n$line"
                $lines = ''
            }

            if (($line -cne $last) -and (!$pattern -or ($line -match $pattern)))
            {
                $last = $line
                $line
            }
        }
    )
    $history.Reverse()

    $command = $history | Out-GridView -Title History -PassThru
    if ($command)
    {
        [Microsoft.PowerShell.PSConsoleReadLine]::RevertLine()
        [Microsoft.PowerShell.PSConsoleReadLine]::Insert(($command -join "`n"))
    }
}


