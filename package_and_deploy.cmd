del waves\exports\web.zip
powershell Compress-Archive -Path .\waves\exports\web -DestinationPath .\waves\exports\web.zip
butler.exe push .\waves\exports\web.zip immutableman/sphere-we-go:html5
