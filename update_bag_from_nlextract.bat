@echo off
REM :> Set parameters to download, backup and restore BAG
REM :> Stel hierodnerde database parameters in:
SET PGPASSWORD=password
SET db_name=bag
SET host_name=localhost
SET user_name=postgres
SET portname=5432

REM :> Niet aanpassen backup file format is type custom
SET file_format=c

REM :> Geef de juiste paden op naar pg_dump, pg_restore en psql
SET pg_dump_path="C:\Program Files\PostgreSQL\10\bin\pg_dump.exe"
SET pg_restore_path="C:\Program Files\PostgreSQL\10\bin\pg_restore.exe"
SET psql_path="C:\Program Files\PostgreSQL\10\bin\psql"

REM :> Eerst wordt er een backup gemaakt geef het juiste pad op
SET target_backup_path=D:\BAG\backup\

REM :> Geef het pad op waar de gedownloade moet komen te staan
SET target_restore_path_file=D:\BAG\download\bag-laatst.backup

REM :> Deze instellingen niet aanpassen
SET target_url=https://data.nlextract.nl/bag/postgis/bag-laatst.backup
SET other_pg_dump_flags=--no-owner --compress 7 --encoding UTF8 --verbose --schema bagactueel
SET other_pg_restore_flags=--no-owner --no-privileges --clean -v

REM :> Fetch Current System Date and set month,day and year variables to name the backup
For /f "tokens=2-4 delims=/ " %%a in ('date /t') do (set mydate=%%c-%%a-%%b)
For /f "tokens=1-2 delims=/:" %%a in ("%TIME%") do (set mytime=%%a%%b)

REM :> Creating string for backup file name
set datestr=backup_%mydate%

REM :> Backup File name
set BACKUP_FILE=%db_name%_%datestr%.backup
REM	:> Download the BAG PostGIS database from nlExtract
powershell -Command "(New-Object Net.WebClient).DownloadFile('%target_url%', '%target_restore_path_file%')"
REM :> Executing command to backup BAG database
%pg_dump_path% --host=%host_name% -U %user_name% --format=%file_format% --port %portname% %other_pg_dump_flags% -f %target_backup_path%%BACKUP_FILE% %db_name%
REM :> Executing command to clear and restore schema bagactueel an restore BAG database
%pg_restore_path% -h %host_name% -U %user_name% -p %portname% -d %db_name% %other_pg_restore_flags% %target_restore_path_file%
REM :> Set timestamp in the comment of the schema BAGactueel
%psql_path% -d %db_name% -U %user_name% -c "COMMENT ON SCHEMA bagactueel IS 'BAG versie: %mydate%'"
pause