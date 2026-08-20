$files = git ls-files --others --exclude-standard
$totalFiles = $files.Count
$commits = 65

$filesPerCommit = [math]::Floor($totalFiles / $commits)
if ($filesPerCommit -lt 1) { $filesPerCommit = 1 }

$i = 0
$commitCount = 0

while ($i -lt $totalFiles) {
    if ($commitCount -eq $commits - 1) {
        $chunk = $files[$i..($totalFiles - 1)]
        $i = $totalFiles
    } else {
        $end = $i + $filesPerCommit - 1
        if ($end -ge $totalFiles) { $end = $totalFiles - 1 }
        $chunk = $files[$i..$end]
        $i = $end + 1
    }
    
    foreach ($file in $chunk) {
        git add "`"$file`""
    }
    
    $filename = Split-Path $chunk[0] -Leaf
    $commitMsg = "Add $filename and related components"
    git commit -m $commitMsg
    
    $commitCount++
}

git remote add origin https://github.com/Pranav140/Guidelens
git branch -M main
git push -u origin main
