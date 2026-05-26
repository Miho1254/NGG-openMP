param(
    [string]$Root = (Resolve-Path "$PSScriptRoot\..")
)

$ErrorActionPreference = "Stop"

function Assert-FileContains {
    param(
        [string]$Path,
        [string]$Pattern,
        [string]$Message
    )

    $content = Get-Content -LiteralPath (Join-Path $Root $Path) -Raw
    if ($content -notmatch $Pattern) {
        throw $Message
    }
}

Assert-FileContains "gamemodes\includes\core\phone_new.pwn" "new payphoneid = ListItemTrackId\[playerid\]\[listitem\];" "Payphone dialog must resolve the selected list item into a payphone id."
Assert-FileContains "gamemodes\includes\core\phone_new.pwn" "ListItemTrackId\[playerid\]\[x\] = i;" "Payphone list must store array indexes, not phone numbers."
Assert-FileContains "gamemodes\includes\group\fires.pwn" "if\(!response\) return 1;" "Fire dialog must ignore cancel responses."
Assert-FileContains "gamemodes\includes\group\fires.pwn" "fireid < 0 \|\| fireid >= iServerFires" "Fire dialog must validate selected fire id."
Assert-FileContains "gamemodes\includes\admin\intlist.pwn" "id < 0 \|\| id >= sizeof\(InteriorsList\)" "Interior dialog must validate parsed interior id."
Assert-FileContains "gamemodes\includes\business\businesscore.pwn" "Businesses\[i\]\[bExtPos\]\[0\] == 0\.0 && Businesses\[i\]\[bExtPos\]\[1\] == 0\.0 && Businesses\[i\]\[bExtPos\]\[2\] == 0\.0" "Business next command must check all exterior coordinates."
Assert-FileContains "gamemodes\includes\core\ATMs.pwn" "IsValidDynamicArea\(STREAMER_TAG_AREA:ATMPoint\[i\]\)" "ATM interaction loop must skip uninitialized dynamic areas."
Assert-FileContains "gamemodes\includes\group\callsystem.pwn" "VALUES \('%e', %d, '%e', '%e', '%e', %d, UNIX_TIMESTAMP\(\)\)" "911 call insert must escape all string values."

Write-Host "Regression checks passed."
