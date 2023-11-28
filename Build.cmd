echo build.cmd

if "%vcversion%"=="vs17" if "%platform%"=="x64" call "C:\Program Files\Microsoft Visual Studio\2022\Community\VC\Auxiliary\Build\vcvars64.bat"
if "%vcversion%"=="vs16" if "%platform%"=="x64" call "C:\Program Files (x86)\Microsoft Visual Studio\2019\Community\VC\Auxiliary\Build\vcvars64.bat"

dir \downloads
if exist \downloads\zlib-%zlib_version% dir \downloads\zlib-%zlib_version%
dir \downloads\subversion-%svn_version%
if exist \downloads\subversion-%svn_version%\Release dir \downloads\subversion-%svn_version%\Release

set lib=C:\OpenSSL-v111-Win64\lib;\downloads\zlib-%zlib_version%\%platform%;\Apache24\lib;%lib%
set include=C:\OpenSSL-v111-Win64\include;\downloads\zlib-%zlib_version%;\Apache24\include;%include%

cd \downloads\serf-1.3.10
if "%run_clean%"=="yes" nmake /s /nologo /f \svn\serf.mak CLEAN APR_SRC=C:\Apache24 APRUTIL_SRC=C:\Apache24 ZLIB_SRC=C:\Apache24 OPENSSL_SRC=C:\Apache24 || exit 0
nmake /s /nologo /f \svn\serf.mak ALL APR_SRC=C:\Apache24 APRUTIL_SRC=C:\Apache24 ZLIB_SRC=C:\Apache24 OPENSSL_SRC=C:\OpenSSL-v111-Win64
if exist Release\serf-1.lib copy Release\serf-1.lib . /y

cd \downloads\subversion-%svn_version%

if "%run_build%"=="no" exit 0

echo C:\Python27-x64\python gen-make.py --release -t vcproj --vsnet-version=2017 --with-apr-util=C:\Apache24 --with-apr=C:\Apache24 --with-apr-iconv=C:\Apache24 --with-apr_memcache=C:\Apache24 --with-httpd=C:\Apache24 --with-openssl=C:\OpenSSL-v111-Win64 --with-zlib=C:\Apache24 --with-sqlite=C:\downloads\sqlite-amalgamation-%sqlite_version% --with-jdk="C:\Program Files\Java\jdk9" --with-serf=\downloads\serf-1.3.10
C:\Python27-x64\python gen-make.py --release -t vcproj --vsnet-version=2017 --with-apr-util=C:\Apache24 --with-apr=C:\Apache24 --with-apr-iconv=C:\Apache24 --with-apr_memcache=C:\Apache24 --with-httpd=C:\Apache24 --with-openssl=C:\OpenSSL-v111-Win64 --with-zlib=C:\Apache24 --with-sqlite=C:\downloads\sqlite-amalgamation-%sqlite_version% --with-jdk="C:\Program Files\Java\jdk9" --with-serf=\downloads\serf-1.3.10
if "%run_clean%"=="yes" devenv subversion_vcnet.sln /Clean "Release|x64" || exit 0
devenv subversion_vcnet.sln /Build "Release|x64" || exit 0
