@echo off
cd /d "%~dp0"
echo.
echo  Keu Semijoias
echo  Loja:  http://localhost:4173
echo  Admin: http://localhost:4173/admin.html
echo.
echo  E-mail admin: admin@keusemijoias.com.br
echo  Senha admin:  keu123
echo.
python -m http.server 4173
if errorlevel 1 py -m http.server 4173
pause
