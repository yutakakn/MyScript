<#
�^�C�g���o�[�Ɏ��v�����I�ɕ\������

(C) 2016 Yutaka Hirata
https://github.com/yutakakn
#>

# �R�}���h���C���I�v�V�����̒�`
 param (
    [string]$motion
 )

$FuncTimer = $null
$FuncTimerID = "updateTimerOnBar"
$FuncTimerValue = 1    # �X�V����(�b�P��)
$global:ShowSecondEnabled = 0    # �b�����v�\������

function global:updateTimeDataTimer {
    $weeks = (
        "��", "��", "��", "��", "��", "��", "�y"
    )
    $now = Get-Date 
    $w = [Convert]::ToInt32($now.DayOfWeek)
    if ($ShowSecondEnabled -eq 1) {
        $nowstr = [String]::Format("{0:00}/{1:00}({2}) {3:00}:{4:00}:{5:00}", 
            $now.Month, $now.Day, $weeks[$w], $now.Hour, $now.Minute, $now.Second)
    } else {
        $nowstr = [String]::Format("{0:00}/{1:00}({2}) {3:00}:{4:00}", 
            $now.Month, $now.Day, $weeks[$w], $now.Hour, $now.Minute)
    }
#    echo $nowstr

#    (Get-Host).UI.RawUI.WindowTitle = "Windows PowerShell " + $nowstr
    (Get-Host).UI.RawUI.WindowTitle = "PowerShell " + $nowstr + " " + $PWD
}

function startTimerFunction {
    echo "Starting timer..."

    $FuncTimer = New-Object System.Timers.Timer
    $FuncTimer.Interval =  $FuncTimerValue * 1000
    Register-ObjectEvent `
        -InputObject $FuncTimer `
        -EventName Elapsed `
        -SourceIdentifier $FuncTimerID `
        -Action { updateTimeDataTimer }

    $FuncTimer.Enabled = $true
    $FuncTimer.Start()
}

function stopTimerFunction {
    echo "Stopping timer..."

    if (! [String]::IsNullOrEmpty($FuncTimer)) {
        $FuncTimer.Stop()
    }
    Unregister-Event $FuncTimerID
#    Remove-Item function:updateTimeDataTimer
}

if ($motion -eq 'start') {
    stopTimerFunction
    startTimerFunction
} elseif ($motion -eq 'stop') {
    stopTimerFunction
} else {
    $own = Split-Path -Leaf $PSCommandPath
    echo "Help: $own [start|stop]"
    exit
}
