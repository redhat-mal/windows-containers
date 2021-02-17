#FROM microsoft/windowsservercore
FROM mcr.microsoft.com/windows/servercore:ltsc2019
##FROM mcr.microsoft.com/windows/servercore/iis:windowsservercore-ltsc2019

# BlogEngine.NET dependencies
RUN dism.exe /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN powershell add-windowsfeature web-asp-net45 

# # Download and extract BlogEngine.NET project files
RUN powershell -Command \
    $ErrorActionPreference = 'Stop'; \
	[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; \
	Invoke-WebRequest -Method Get -Uri https://github.com/rxtur/BlogEngine.NET/releases/download/v3.3.6.0/3360.zip -OutFile c:\BlogEngineNETSrc.zip ; \
	Expand-Archive -Path c:\BlogEngineNETSrc.zip -DestinationPath c:\inetpub\wwwroot\blogengine ; \
	Remove-Item c:\BlogEngineNETSrc.zip -Force ; 

# Configure Web App
COPY buildapp.ps1 C:/
RUN powershell.exe C:\buildapp.ps1

# Overwrite Web.config file so that web service points to db service
COPY Web.config C:/inetpub/wwwroot/blogengine

RUN powershell -Command \
    Add-WindowsFeature Web-Server; \
    Invoke-WebRequest -UseBasicParsing -Uri "https://dotnetbinaries.blob.core.windows.net/servicemonitor/2.0.1.10/ServiceMonitor.exe" -OutFile "C:\ServiceMonitor.exe"

EXPOSE 80

ENTRYPOINT ["C:\\ServiceMonitor.exe", "w3svc"]