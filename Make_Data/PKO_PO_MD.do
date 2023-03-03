/*	*************************************************************/
/*     	File Name:	PKO_PO_Data_Prep		                    */
/*     	Date:   	February 11, 2020	                        */
/*      Author: 	Robert Lee Wood III				            */
/*      Purpose:	Prepare Data for PKO & PO Paper			 	*/
/*      Input Files: WVS_TimeSeries_Stata_v1_6.dta				*/
/*     	Output File: PKO_PO_Final.dta  		                    */	
/*	*************************************************************/


*** Clear frames ***
clear all
frame reset


*** Global Macro of Folder Location ***
global cd_path "/Users/treywood/Dropbox/Projects/Active_Projects/PKO_and_PO"


*** Set Working Directory ***
cd "${cd_path}"


*** Import dataset ***
use Make_Data/WVS_TimeSeries_1981_2022_Stata_v3_0.dta, clear


**********************
*** Wave 4 Dataset ***
**********************

*** Keep only Wave 4 Observations ***
keep if S002VS == 4


*** Use Only PKO Question Data ***
drop if E135 == -4
/* -4 means the question was not 
asked in the survey*/


*** Create Indicator of Experienced a PKO ***
gen PKO_ALL = 0 
replace PKO_ALL = 1 if S003 == 231 | S003 == 504 | S003 == 70 | S003 == 268 |S003 == 646 | S003 == 800 | S003 == 818 | S003 == 196 | S003 == 320 | S003 == 360 | S003 == 364 | S003 == 499 | S003 == 688
label variable PKO_ALL "Experienced a PKO"


*** Create Indicator of UN Preference ***
gen PREF_UN = 0 
replace PREF_UN = 1 if E135 == 2
label variable PREF_UN "Prefer UN"


*** Keep only African countries ***
gen AFRICA = 0
replace AFRICA = 1 if S003 == 12 | S003 == 231 | S003 == 288 | S003 == 466 | S003 == 504 | S003 == 566 | S003 == 646 | S003 == 710 | S003 == 716 | S003 == 800 | S003 == 818 | S003 == 834 | S003 == 854 | S003 == 894
label variable AFRICA "Africa Dummy"


*** Correlate the battery of questions ***
gen E136_UN = 0
replace E136_UN = 1 if E136 == 2

gen E137_UN = 0
replace E137_UN = 1 if E137 == 2

gen E138_UN = 0
replace E138_UN = 1 if E138 == 2

gen E139_UN = 0
replace E139_UN = 1 if E139 == 2

corr PREF_UN E136_UN E137_UN E138_UN E139_UN

/// Most are below .300. 
/// E137_UN and E138_UN (Aid to Developing Countries and Refugess) are .4018. 
/// E138_UN and E139_UN (Refugess and Human Rights) are .3816


*** Variables to keep ***
keep E135 PKO_ALL PREF_UN X003 X025 X025R S002 S003 S020 S021 S024 S025 X001 X007 X024B X028 A076 A093 A070 A087 A105 E069_40 E124 X047_WVS E215 S017 E069_20 A191 AFRICA

*** Voluntary Work ***
drop if A087 == -4 /* Not asked in survey */


* Drop missing responses *
drop if E124 == -1 /* Don't know */
drop if E124 == -2 /* No answer */ 
drop if E124 == -4 /* Not asked in survey */
drop if E124 == -5 /* Missing: Unknown */


*** Flip scale of E124 ***
** net install vreverse, replace 
vreverse E124, gen(E124_2)
drop E124
rename E124_2 E124
label var E124 "Respect for individual human rights nowadays"


* Drop missing responses *
drop if E069_20 == -1 /* Don't know */
drop if E069_20 == -2 /* No answer */ 
drop if E069_20 == -4 /* Not asked in survey */
drop if E069_20 == -5 /* Missing: Unknown */


*** Flip scale of E069_20 ***
** net install vreverse, replace 
vreverse E069_20, gen(E069_20_2)
drop E069_20
rename E069_20_2 E069_20
label var E069_20 "Confidence in the UN"


*** Male indicator ***
drop if X001 == -2 /* No answer */ 
gen MALE = 0 
replace MALE = 1 if X001 == 1
label var MALE "Male"
drop X001


*** Age Variable ***
drop if X003 == -2 /* No answer */ 
drop if X003 == -5 /* Missing: Unknown */
rename X003 AGE
label var AGE "Age"


*** Married Indicator ***
drop if X007 == -1 /* Don't know */
drop if X007 == -2 /* No answer */ 
drop if X007 == -5 /* Missing: Unknown */
gen MARRIED = 0
replace MARRIED = 1 if X007 == 1
drop X007
label var MARRIED "Married"


*** Education Variable ***
drop if X025 == -1 /* Don't know */
drop if X025 == -2 /* No answer */ 
drop if X025 == -5 /* Missing: Unknown */
replace X025 = 0 if X025 == -3 /* Include no formal education */
rename X025 EDUCATION
drop X025
label var EDUCATION "Education"


*** Employment Indicator ***
drop if X028 == -1 /* Don't know */
drop if X028 == -2 /* No answer */ 
drop if X028 == -4 /* Not asked in survey */
drop if X028 == -5 /* Missing: Unknown */
gen EMPLOYED = 0
replace EMPLOY = 1 if X028 == 1 | X028 == 2 | X028 == 3
drop X028
label var EMPLOY "Employed"


*** Income Variable ***
drop if X047_WVS == -1 /* Don't know */
drop if X047_WVS == -2 /* No answer */ 
drop if X047_WVS == -4 /* Not asked in survey */
drop if X047_WVS == -5 /* Missing: Unknown */
rename X047_WVS INCOME
label var INCOME "Income"


*** Drop Variables ***
drop  X024B E215 E069_40 A093 A076 A191


*** Save Data ***
save ${cd_path}/Data_Analysis/PKO_PO_W4, replace


**********************
*** Wave 5 Dataset ***
**********************


*** Bring in Data ***
use Make_Data/WVS_TimeSeries_1981_2022_Stata_v3_0.dta, clear


*** Keep only Wave 5 Observations ***
keep if S002VS == 5


*** Use Only PKO Question Data ***
drop if E135 == -4
/* -4 means the question was not 
asked in the survey*/


*** Create Indicator of Experienced a PKO ***
gen PKO_ALL = 0 
replace PKO_ALL = 1 if S003 == 231 | S003 == 504 | S003 == 70 | S003 == 268 |S003 == 646 | S003 == 800 | S003 == 818 | S003 == 196 | S003 == 320 | S003 == 360 | S003 == 364 | S003 == 499 | S003 == 688
label variable PKO_ALL "Experienced a PKO"


*** Create Indicator of Experienced a Regional PKO ***
gen Reg_PKO = 0
replace Reg_PKO = 1 if S003 == 466 | S003 == 504 | S003 == 646 | S003 == 818 | S003 == 854
label variable Reg_PKO "Regional PKO"


*** Create Indicator of UN Preference ***
gen PREF_UN = 0 
replace PREF_UN = 1 if E135 == 2
label variable PREF_UN "Prefer UN"


*** Keep only African countries ***
gen AFRICA = 0
replace AFRICA = 1 if S003 == 12 | S003 == 231 | S003 == 288 | S003 == 466 | S003 == 504 | S003 == 566 | S003 == 646 | S003 == 710 | S003 == 716 | S003 == 800 | S003 == 818 | S003 == 834 | S003 == 854 | S003 == 894
label variable AFRICA "Africa Dummy"


*** Variables to keep ***
keep E135 PKO_ALL Reg_PKO PREF_UN X003 X025 S002 S003 S020 S021 S024 S025 X001 X007 X024B X028 A076 A093 A070 A105 E069_40 E124 X047_WVS E215 S017 E069_20 A191 AFRICA


* Drop missing responses *
drop if E124 == -1 /* Don't know */
drop if E124 == -2 /* No answer */ 
drop if E124 == -4 /* Not asked in survey */
drop if E124 == -5 /* Missing: Unknown */


*** Flip scale of E124 ***
** net install vreverse, replace 
vreverse E124, gen(E124_2)
drop E124
rename E124_2 E124
label var E124 "Respect for individual human rights nowadays"


* Drop mission responses *
drop if A105 == -1 /* Don't know */
drop if A105 == -2 /* No answer */ 
drop if A105 == -4 /* Not asked in survey */
drop if A105 == -5 /* Missing: Unknown */


* Drop missing responses *
drop if E069_20 == -1 /* Don't know */
drop if E069_20 == -2 /* No answer */ 
drop if E069_20 == -4 /* Not asked in survey */
drop if E069_20 == -5 /* Missing: Unknown */ 


*** Flip scale of E069_20 ***
** net install vreverse, replace 
vreverse E069_20, gen(E069_20_2)
drop E069_20
rename E069_20_2 E069_20
label var E069_20 "Confidence in the UN"


*** Male indicator ***
drop if X001 == -2 /* No answer */ 
gen MALE = 0 
replace MALE = 1 if X001 == 1
label var MALE "Male"
drop X001


*** Age Variable ***
drop if X003 == -2 /* No answer */ 
drop if X003 == -5 /* Missing: Unknown */
rename X003 AGE
label var AGE "Age"


*** Married Indicator ***
drop if X007 == -1 /* Don't know */
drop if X007 == -2 /* No answer */ 
drop if X007 == -5 /* Missing: Unknown */
gen MARRIED = 0
replace MARRIED = 1 if X007 == 1
drop X007
label var MARRIED "Married"


*** Education Variable ***
drop if X025 == -1 /* Don't know */
drop if X025 == -2 /* No answer */ 
drop if X025 == -5 /* Missing: Unknown */
replace X025 = 0 if X025 == -3 /* Include no formal education */
rename X025 EDUCATION
label var EDUCATION "Education"


*** Employment Indicator ***
drop if X028 == -1 /* Don't know */
drop if X028 == -2 /* No answer */ 
drop if X028 == -4 /* Not asked in survey */
drop if X028 == -5 /* Missing: Unknown */
gen EMPLOYED = 0
replace EMPLOY = 1 if X028 == 1 | X028 == 2 | X028 == 3
drop X028
label var EMPLOY "Employed"


*** Income Variable ***
drop if X047_WVS == -1 /* Don't know */
drop if X047_WVS == -2 /* No answer */ 
drop if X047_WVS == -4 /* Not asked in survey */
drop if X047_WVS == -5 /* Missing: Unknown */
rename X047_WVS INCOME
label var INCOME "Income"


*** Security Variable ***
drop if A191 == -1 /* Don't know */
drop if A191 == -2 /* No answer */ 
drop if A191 == -4 /* Not asked in survey */
drop if A191 == -5 /* Missing: Unknown */
rename A191 SECURITY
label var SECURITY "Personal Security"


*** Drop Variables ***
drop  X024B E215 E069_40 A093 A076


save ${cd_path}/Data_Analysis/PKO_PO_W5, replace


