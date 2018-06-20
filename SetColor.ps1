Set-PSReadlineOption -TokenKind Parameter -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind String -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Operator -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Type -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Variable -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Number -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Member -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Command -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Comment -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -TokenKind Keyword -ForegroundColor DarkYellow -BackgroundColor DarkMagenta
Set-PSReadlineOption -ContinuationPromptForegroundColor DarkYellow -ContinuationPromptBackgroundColor DarkMagenta
Set-PSReadlineOption -EmphasisForegroundColor DarkYellow -EmphasisBackgroundColor DarkMagenta
Set-PSReadlineOption -ErrorForegroundColor DarkYellow -ErrorBackgroundColor DarkMagenta

(Get-Host).PrivateData.ErrorForegroundColor="DarkYellow"
(Get-Host).PrivateData.ErrorBackgroundColor="DarkMagenta"
(Get-Host).PrivateData.WarningForegroundColor="DarkYellow"
(Get-Host).PrivateData.WarningBackgroundColor="DarkMagenta"
(Get-Host).PrivateData.DebugForegroundColor="DarkYellow"
(Get-Host).PrivateData.DebugBackgroundColor="DarkMagenta"
(Get-Host).PrivateData.VerboseForegroundColor="DarkYellow"
(Get-Host).PrivateData.VerboseBackgroundColor="DarkMagenta"
(Get-Host).PrivateData.ProgressForegroundColor="DarkYellow"
(Get-Host).PrivateData.ProgressBackgroundColor="DarkMagenta"
