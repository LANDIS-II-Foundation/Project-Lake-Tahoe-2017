rem Scenario is %1
rem Replicate number is %2

set workingdir=G:\Kretchun\SNPLMA2\ClimateChangeFuelTreatments_Low-Ignitions
set homedir=J:\SNPLMA2\LTB_Modeling\LTB_WorkingCopy\ClimateChangeFuelTreatments_Low-Ignitions

if not exist %workingdir%\%1\replicate%2 mkdir %workingdir%\%1\replicate%2
g:
cd %workingdir%\%1\replicate%2
copy J:\SNPLMA2\LTB_Modeling\LTB_WorkingCopy\ClimateChangeFuelTreatments_Low-Ignitions\%1.txt
call landis %1.txt
j:
cd %homedir%

