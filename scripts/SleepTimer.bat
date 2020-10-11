@echo off
color 2
echo Spotify Sleep Timer
color 0
set /p mins=How many minutes should I wait? 
set /a secs=%mins% * 60
timeout %secs%
taskkill -im spotify.exe
rundll32.exe powrprof.dll,SetSuspendState 0,1,0
