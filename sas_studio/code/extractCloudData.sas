%macro extractCloudData(remoteURL=, localDataset=);
/***********************************************************************************/
/* Program Name: extractCloudData                                                  */
/* Date Created: 12/15/2019                                                        */
/* Author: 	Manuel Figallo                                                         */
/* Purpose: extract data from the Google Cloud                                     */
/*                                                                                 */
/* ------------------------------------------------------------------------------- */
/*                                                                                 */
/* Input(s): remoteURL is the REST Query for the Google Cloud                      */
/*           localDataset is the dataset with all data from the REST query         */
/* Output(s): sas7bdat with all the comments                                       */
/*                                                                                 */
/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
/* Date Modified: TBD                                                              */
/* Modified by: TBD                                                                */
/* Reason for Modification: TBD                                                    */
/* Modification Made: TBD                                                          */
/***********************************************************************************/
options noquotelenmax;

	%if &remoteURL=%then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide an HTTP location.;
			%return;
		%end;

	%if &localDataset=%then
		%do;
			%put ERROR: A null value is not valid.;
			%put ERROR- Please provide an destination location on your C: drive, 
				S: drive, etc.;
			%return;
		%end;
	%let remoteURL2 = %QSYSFUNC(TRANWRD(&remoteURL, %str(%"), %str(%')));
	%put &remoteURL2;
	%put &remoteURL2;

	proc ds2;
		data &localDataset (overwrite=yes);

			/* Global package references */
			dcl package json j();
			dcl double YEAR_NUM;
			dcl nvarchar(32767) LOCALE_VA;
			dcl nvarchar(32767) INDICATOR;
			dcl double VALUE;

			/* these are temp variables */
			dcl varchar(3276700) character set utf8 response;
			dcl int rc;
			drop response rc;
			method parseMessages();
				dcl int tokenType parseFlags;
				dcl nvarchar(3276700) token;
				rc=0;

				do while (rc=0);
					j.getNextToken(rc, token, tokenType, parseFlags);

					if ((token eq '['))then
						do;
							j.getNextToken(rc, token, tokenType, parseFlags);

							if (token ne 'YEAR_NUM') then
								do;
									YEAR_NUM=token;
								end;
							j.getNextToken(rc, token, tokenType, parseFlags);

							if (token ne 'VA_LOCALE') then
								do;
									LOCALE_VA=token;
								end;
							j.getNextToken(rc, token, tokenType, parseFlags);

							if (token ne 'INDICATOR') then
								do;
									INDICATOR=token;
								end;
							j.getNextToken(rc, token, tokenType, parseFlags);

							if (token ne 'VALUE') then
								do;
									VALUE=token;
								end;

							if ((token ne 'YEAR_NUM') AND (token ne 'VA_LOCALE') AND
								(token ne 'INDICATOR') AND (token ne 'VALUE') ) then
								do;
									output;
								end;
						end;
				end;
				return;
			end;
			method init();
				dcl package http webQuery();
				dcl int rc tokenType parseFlags;
				dcl nvarchar(3276700) token;
				dcl integer i rc;

				/* create a GET call to the API                                         */
				webQuery.createGetMethod(&remoteURL2);

				/* execute the GET */
				webQuery.executeMethod();

				/* retrieve the response body as a string */
				webQuery.getResponseBodyAsString(response, rc);
				rc=j.createParser(response);

				do while (rc=0);
					j.getNextToken(rc, token, tokenType, parseFlags);

					if (token='values') then
						parseMessages();
				end;
			end;
			method term();
				rc=j.destroyParser();
			end;
		enddata;
		run;
	quit;

%mend extractCloudData;

%let myGoogleAPI="https://sheets.googleapis.com/v4/spreadsheets/1mTy5pbRxni4KBNCytRkijvOHolUcvIEDT6ReUgoL6vM/values/Sheet1!A1:F12000?key=AIzaSyD4vVV4HF7_Kotcg9vGcEjRvARIJITTnow";
%let myDSOutput=myGoogleData;
%extractCloudData(remoteURL=&myGoogleAPI, localDataset=&myDSOutput) 
