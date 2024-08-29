set "ROOT=%~dp0"

"%ROOT%..\bin\bash" -l -c "/bin/cygrunsrv -Q CygMonitSvc && /bin/cygrunsrv --remove CygMonitSvc"

"%ROOT%..\bin\bash" -l -c "rm -rf /home/SYSTEM/"
"%ROOT%..\bin\bash" -l -c "rm -rf /tmp/monitqueue/"

"%ROOT%..\bin\bash" -l -c "chown Administrator /usr/local/bin/monit.exe"	
"%ROOT%..\bin\bash" -l -c "chown Administrator /etc/monitrc"	
	