/*	*************************************************************/
/*     	File Name:	PKO_PO_Data_Prep		                    */
/*     	Date:   	February 19, 2020	                        */
/*      Author: 	Robert Lee Wood III				            */
/*      Purpose:	Analyze Data for PKO & PO Paper			 	*/
/*      Input Files: PKO_PO_Final.dta							*/
/*     	Output File:           				                    */	
/*	*************************************************************/


*** Global Macro of Folder Location ***
global cd_path "/Users/treywood/Dropbox/Projects/Active_Projects/PKO_and_PO"


*** Set Working Directory ***
cd "${cd_path}"


**************
*** Wave 4 ***
**************


* Import data *
use Data_Analysis/PKO_PO_W4.dta, clear


*** Label Survey Items ***
label var PREF_UN "Prefer UN"
label var A070 "Belong to HR Group"
label var E069_20 "Confidence in the UN"
label var A087 "Volunteer in HR Group"
label var A105 "In/Active Membership of HR Group"


***************
*** Table 2 ***
***************


*** Model 1: Confidence in UN and Volunteer for HR Group, FE ***
eststo m1: logit PREF_UN i.A087##ib1.E069_20 MALE AGE MARRIED EDUCATION EMPLOY INCOME i.S003 if AFRICA ==1, cluster(S003)
quietly estadd local fixed "Yes", replace

esttab m1 using Paper/table1.tex, ///
label se nodepvar se(%6.3f) b(%6.3f) ///
title("Effect of HR Valuations and UN Confidence on Preference") ///
addnote("Dependent variable is preference of UN peacekeeping. Logged odds coefficients.") ///
s(fixed N ll, label("State Fixed Effects" "Observations" "Log Likelihood")) ///
star(+ 0.10 * 0.05 ** 0.01) ///
replace


************************
*** Data for R Plots ***
************************

* Model 1 *
logit PREF_UN i.A087##ib1.E069_20 MALE AGE MARRIED EDUCATION EMPLOY INCOME i.S003 if AFRICA == 1, cluster(S003)
margins A087, at(E069_20 = (1(1)4)) atmeans saving(Data_Analysis/R/M1, replace)


******************************************
*** Descriptive Statistics for Model 1 ***
******************************************

* Model 1 *
logit PREF_UN i.A087##ib1.E069_20 MALE AGE MARRIED EDUCATION EMPLOY INCOME i.S003 if AFRICA == 1, cluster(S003)
gen sample = e(sample)
drop if sample == 0
outreg2 using des_stats_m1.tex, replace sum(log) keep(PREF_UN A087 E069_20 MALE AGE MARRIED EDUCATION EMPLOY INCOME) title("Descriptive Statistics for Model 1") label
drop sample 


**************
*** Wave 5 ***
**************

* Import data *
use Data_Analysis/PKO_PO_W5.dta, clear


*** Label Survey Items ***
label var PREF_UN "Prefer UN"
label var A070 "Belong to HR Group"
label var E069_20 "Confidence in the UN"
label var A105 "In/Active Membership of HR Group"


***************
*** Table 3 ***
***************

* Model 2 *
eststo m2: logit PREF_UN ib0.A105##ib1.E069_20##ib0.PKO_ALL Reg_PKO MALE AGE MARRIED EDUCATION EMPLOY INCOME SECURITY if AFRICA == 1, cluster(S003)
quietly estadd local fixed "No", replace

esttab m2 using Paper/table2.tex, ///
label se nodepvar se(%6.3f) b(%6.3f) ///
title("Effect of UN Confidence, HR Valuations, and PKO Experience on Preference") ///
addnote("Dependent variable is preference of UN peacekeeping. Logged odds coefficients.") ///
s(fixed N ll, label("State Fixed Effects" "Observations" "Log Likelihood")) ///
star(+ 0.10 * 0.05 ** 0.01) ///
replace


	
************************
*** Data for R Plots ***
************************

* Model 2 *
logit PREF_UN ib0.A105##ib1.E069_20##ib0.PKO_ALL Reg_PKO MALE AGE MARRIED EDUCATION EMPLOY INCOME SECURITY if AFRICA == 1, cluster(S003)
margins A105, at(E069_20 = (1(1)4)) dydx(PKO_ALL) atmeans saving(Data_Analysis/R/M2, replace)


******************************
*** Descriptive Statistics ***
******************************

* Model 2 * 
logit PREF_UN ib0.A105##ib1.E069_20##ib0.PKO_ALL Reg_PKO MALE AGE MARRIED EDUCATION EMPLOY INCOME SECURITY if AFRICA == 1, cluster(S003)
gen sample = e(sample)
drop if sample == 0
outreg2 using Paper/des_stats_m2.tex, replace sum(log) keep(PREF_UN A105 E069_20 PKO_ALL Reg_PKO MALE AGE MARRIED EDUCATION EMPLOY INCOME SECURITY) title("Descriptive Statistics for Model 2") label
drop sample 


************************************
*** HR Protections of State Test ***
************************************

*** Build Matching on COW ***

gen COW = .
replace COW = 615 if S003 == 12
replace COW = 530 if S003 == 231
replace COW = 452 if S003 == 288
replace COW = 432 if S003 == 466 
replace COW = 600 if S003 == 504
replace COW = 475 if S003 == 566
replace COW = 517 if S003 == 646
replace COW = 560 if S003 == 710
replace COW = 552 if S003 == 716
replace COW = 500 if S003 == 800
replace COW = 651 if S003 == 818
replace COW = 510 if S003 == 834
replace COW = 439 if S003 == 854
replace COW = 551 if S003 == 894


*** Merge Data ***
merge m:m S020 COW using "Data_Analysis/HR_DATA_FARISS.dta"

drop if S003 == .
drop ciri disap kill polpris tort amnesty state hrw hathaway itt genocide rummel massive_repression executions negative_sanctions mass_killing killing_low killing_best killing_high killing_present cow_year id theta_sd killing_estimate_mean killing_estimate_median country_name _merge
rename theta_mean HR_PROT
label var HR_PROT "HR Protetions, Farris (Higher, more protection)"


*** Correlations ***

corr A105 HR_PROT
* 0.0159

corr E069_20 HR_PROT
* 0.2061

corr PREF_UN HR_PROT
* 0.0579

logit PREF_UN ib0.A105##ib1.E069_20##ib0.PKO_ALL HR_PROT MALE AGE MARRIED EDUCATION EMPLOY INCOME SECURITY if AFRICA == 1, cluster(S003)




