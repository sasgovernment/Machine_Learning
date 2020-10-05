%macro load2CAS(TargetHostName=, LibName=, DSName=);
	/***********************************************************************************/
	/* Program Name: load2CAS                                                          */
	/* Date Created: 09/15/2020                                                        */
	/* Author: 	Manuel Figallo                                                         */
	/* Purpose: load data to SAS Viya CAS (Cloud Analytic Services                     */
	/*                                                                                 */
	/* ------------------------------------------------------------------------------- */
	/*                                                                                 */
	/* Input(s): TargetHostName is the Target CAS Server Name                          */
	/*           LibName is the target CAS library        							   */
	/*           DSName is the name of the dataset                                     */
	/*                                                                                 */
	/* ---------------------THE SECTION BELOW IS FOR FUTURE ENHANCEMENTS-------------- */
	/* Date Modified: TBD                                                              */
	/* Modified by: TBD                                                                */
	/* Reason for Modification: TBD                                                    */
	/* Modification Made: TBD                                                          */
	/***********************************************************************************/

		%let TargetHostName2=&TargetHostName;
	%let TargetHostName3=%SYSFUNC(STRIP(%QSYSFUNC(TRANWRD(&TargetHostName2, 
		%str(%"), %str()))));
	options comamid=TCP;
	%let local=&TargetHostName3 17551;

	data _null_;
		signon local user='sasdemo' password="Orion123" noscript;
	run;

	%syslput targethostname2_0=&TargetHostName2;
	%syslput Dataset1_0=&DSName;
	%syslput Lib1_0=&LibName;
	rsubmit local;
	options validmemname=EXTEND validvarname=ANY;
	libname &Lib1_0 CAS CASLIB=&Lib1_0 SERVER=&targethostname2_0 PORT=5570;

	proc datasets lib=&Lib1_0 nolist nowarn memtype=(data view);
		delete &Dataset1_0;
	quit;

	proc upload data=&Dataset1_0 out=&Lib1_0..&Dataset1_0 (PROMOTE=YES);
	run;

	endrsubmit;

	data _null_;
		signoff local;
	run;

%mend load2CAS;

%let MyInputVariableName1="10.96.7.219";
%let MYBOOLEANVAR1=PUBLIC;
%load2CAS(TargetHostName=&MyInputVariableName1, LibName=&MYBOOLEANVAR1, 
	DSName=MYGOOGLEDATA_WIDE1)
