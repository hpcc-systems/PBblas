SETLOCAL
ECHO OFF
REM runPerf.bat <clustersize>
REM Run each of the performance tests for each of the test sized (small, med, large)
SET host=52.9.80.51
SET lib="\Users\devrog01\source\PBblas"
ECHO cluster size = %1

REM test_size = 1 is small, test_size = 2 is medium, test_size = 3 is large
REM First run the Prep program to create the files.  Then run the test program
REM to get the performance timing for each size.
REM Run small first to avoid wasted time if there is a problem.
REM Set pathPrefix to the folder containing PBblas
SET pathPrefix="\Users\devrog01\source"
SET lib=%pathPrefix%\PBblas

REM MultiplyPerf -- Single Multiply Performance Test
SET progName=MultiplyPerf
SET prepPath=%pathPrefix%\PBblas\performance\%progName%Prep.ecl
SET progPath=%pathPrefix%\PBblas\performance\%progName%.ecl
REM ecl run mythor %prepPath% -s %host% --port 8010 -I%lib% -v --name=%progName%Prep --wait=10000000
REM ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=1 -I%lib% -v --name=%progName%_S_%1 --wait=10000000
REM ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=2 -I%lib% -v --name=%progName%_M_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=3 -I%lib% -v -fthorConnectTimeout=10000000 --name=%progName%_L_%1 --wait=10000000

// MultiplyPerfMyr -- Myriad Multiply Performance Test
SET progName=MultiplyPerfMyr
SET prepPath=%pathPrefix%\PBblas\performance\%progName%Prep.ecl
SET progPath=%pathPrefix%\PBblas\performance\%progName%.ecl
ecl run mythor %prepPath% -s %host% --port 8010 -I%lib% -v --name=%progName%Prep --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=1 -I%lib% -v --name=%progName%_S_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=2 -I%lib% -v --name=%progName%_M_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=3 -I%lib% -v -fthorConnectTimeout=10000000 --name=%progName%_L_%1 --wait=10000000

// SolvePerf -- Single Solve Performance Test
SET progName=SolvePerf
SET prepPath=%pathPrefix%\PBblas\performance\%progName%Prep.ecl
SET progPath=%pathPrefix%\PBblas\performance\%progName%.ecl
ecl run mythor %prepPath% -s %host% --port 8010 -I%lib% -v --name=%progName%Prep
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=1 -I%lib% -v --name=%progName%_S_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=2 -I%lib% -v --name=%progName%_M_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=3 -I%lib% -v --name=%progName%_L_%1 --wait=10000000

// SolvePerfMyr -- Myriad Solve Performance Test
SET progName=SolvePerfMyr
SET prepPath=\Users\devrog01\source\PBblas\performance\%progName%Prep.ecl
SET progPath=\Users\devrog01\source\PBblas\performance\%progName%.ecl
ecl run mythor %prepPath% -s %host% --port 8010 -I%lib% -v --name=%progName%Prep
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=1 -I%lib% -v --name=%progName%_S_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=2 -I%lib% -v --name=%progName%_M_%1 --wait=10000000
ecl run mythor %progPath% -s %host% --port 8010 -Xtest_size=3 -I%lib% -v --name=%progName%_L_%1 --wait=10000000
ECHO 
ENDLOCAL
