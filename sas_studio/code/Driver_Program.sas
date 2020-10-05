options noxwait mprint mlogic sasautos=(sasautos,
"C:\SAS\Projects\GITHUB\Machine_Learning_Cloud\sas_studio\code");


%let myGoogleAPI="https://sheets.googleapis.com/v4/spreadsheets/1mTy5pbRxni4KBNCytRkijvOHolUcvIEDT6ReUgoL6vM/values/Sheet1!A1:F12000?key=AIzaSyD4vVV4HF7_Kotcg9vGcEjRvARIJITTnow";
%let myDSOutput=myGoogleData;
%extractCloudData(remoteURL=&myGoogleAPI, localDataset=&myDSOutput) 

%transformData

%let MyInputVariableName1="10.96.7.219";
%let MYBOOLEANVAR1=PUBLIC;
%load2CAS(TargetHostName=&MyInputVariableName1, LibName=&MYBOOLEANVAR1, 
	DSName=MYGOOGLEDATA_WIDE1)
