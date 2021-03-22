$fileName = "contribution.txt"
$dateFile = "date.txt"

# Read dates from date.txt
$dateData = Get-Content $dateFile

# Process each date
foreach ($date in $dateData) {

    # Skip empty lines
    if ([string]::IsNullOrWhiteSpace($date)) {
        continue
    }

    $commitDate = "${date}T12:00:00"

    $env:GIT_AUTHOR_DATE = $commitDate
    $env:GIT_COMMITTER_DATE = $commitDate

    git add -- contribution.txt
    git commit -m "Commit on $commitDate"

    Remove-Item Env:\GIT_AUTHOR_DATE
    Remove-Item Env:\GIT_COMMITTER_DATE
    $commitCount = Get-Random -Minimum 1 -Maximum 5
    for ($i = 1; $i -le $commitCount; $i++) {
        

        
        $step = Get-Random -Minimum 1 -Maximum 7

        # Append content to contribution file
        Add-Content -Path $fileName -Value "Commit on $commitDate"

        # Add file
        git add *

        # Commit with specific date
        git commit -m "Commit on $commitDate" --date="$commitDate"
    }
    # Push changes
    Write-Host "pushing ---- $commitDate"
    git push
    Write-Host "------------"
    # Check push result
    if ($LASTEXITCODE -eq 0) {

        Write-Host "Successfully committed and pushed for $commitDate. Removing date from $dateFile."

        # Remove processed date from date.txt
        $remainingDates = Get-Content $dateFile | Where-Object { $_ -ne $date }

        Set-Content -Path $dateFile -Value $remainingDates

    }
    else {

        Write-Host "Push failed for $commitDate. Date will remain in $dateFile."

        exit 1
    }
}

Write-Host "Script finished."