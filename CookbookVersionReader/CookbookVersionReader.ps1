Param (
    [string]$searchPattern = "**\metadata.rb",
	[string]$variablesPrefix
)

# Write all params to the console.
Write-Host ("Search Pattern: " + $searchPattern)
Write-Host ("Variables Prefix: " + $variablesPrefix)

function SetBuildVariable([string]$varName, [string]$varValue)
{
	Write-Host ("Setting variable " + $variablesPrefix + $varName + " to '" + $varValue + "'")
	Write-Output ("##vso[task.setvariable variable=" + $variablesPrefix + $varName + ";]" +  $varValue )
}

function SetAssemblyVariables($content)
{
    $matches = [regex]::Matches($content, "[']([0-9]+).([0-9]+).([0-9]+)[']")

    if($matches.Success)
    {
        foreach($match in $matches)
        {
            if($match.Groups.Count -eq 4 -and $match.Groups[0] -ne '')
            {
				$prefix = "Version"

                        if ($match.Groups[1].Success)
                        {
                            $major = $match.Groups[1].Value
                            SetBuildVariable "$prefix.Major" $major

                            if ($match.Groups[2].Success)
                            {
                                $minor = $match.Groups[2].Value
                                SetBuildVariable "$prefix.Minor" $minor

                                if ($match.Groups[3].Success)
                                {
                                    $build = $match.Groups[3].Value
                                    SetBuildVariable "$prefix.Patch" $build
                                    SetBuildVariable "$prefix.Build" $build
                                }
                             }
                        }
             }
         }
    }
 }


$filesFound = Get-ChildItem -Path $searchPattern -Recurse

if ($filesFound.Count -eq 0)
{
    Write-Warning ("No files matching pattern found.")
}

if ($filesFound.Count -gt 1)
{
   Write-Warning ("Multiple assemblyinfo files found.")
}

foreach ($fileFound in $filesFound)
{
    Write-Host ("Reading file: " + $fileFound)
    $fileText = [IO.File]::ReadAllText($fileFound)
    SetAssemblyVariables($fileText)
}
