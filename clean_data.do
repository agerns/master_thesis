/// Birth recode data
* This dataset has one record for every child ever born to interviewed women. 
* Essentially, it is the full birth history of all women interviewed including its information on pregnancy and postnatal care 
* as well as immunization and health for children born in the last 5 years. Data for the mother of each of these children is also included. 
* This file can be used to calculate health indicators as well as fertility and mortality rates. 
* The unit of analysis (case) in this file is the children ever born of eligible women.d

use "/Users/gerns/Documents/Academics/thesis/data/2015/IABR74DT/IABR74FL.DTA", clear

keep v001 v002 v003 b16 b1 b2 b3 b4 b5 b8 v025 v106 v133 v155 v190 b9 v481 v467b v467c v467d v467e v467f v467g v467h v467i v008 v006 v007 v012 v730 v701 v715 v102
sort v001 v002 v003
keep if b16>0 & b16<90

keep if b8>=6 
gen child_lives_here = b9
br if child_lives_here==0
drop b9

gen line_number_of_mother=v003
ren v001 hv001
ren v002 hv002
ren b16 hvidx
drop v003

rename v008 date_interview
rename v006 interview_month
rename v007 interview_year
rename v102 residence

rename b1 birth_month
rename b2 birth_year
rename b3 birth_cmc
rename b4 child_sex
rename b5 child_alive
rename b8 child_age
rename v025 urban_rural
rename v106 mother_educ_level
rename v133 mother_educ_years
rename v155 mother_d_literate
rename v190 wealth_index
rename v481 d_has_insurance
rename v467b access_hf_permission
rename v467c access_hf_money
rename v467d access_hf_distance
rename v467e access_hf_transport
rename v467f access_hf_alone
rename v467g access_hf_nofemaleCHW 
rename v467h access_hf_noprovider
rename v467i access_hf_nodrugsthere

rename v012 mother_age
rename v730 father_age
rename v701 father_educ_level
rename v715 father_educ_years




sort hv001 hv002 hvidx
cd "/Users/gerns/Documents/Academics/thesis/data/2015"

sort hv001 hv002 hvidx 
quietly by  hv001 hv002 hvidx: gen dup = cond(_N==1, 0, _n)
tab dup
*        dup |      Freq.     Percent        Cum.
*------------+-----------------------------------
*          0 |    760,105       99.99       99.99
*          1 |         23        0.00      100.00
*          2 |         23        0.00      100.00
*------------+-----------------------------------
*      Total |    760,151      100.00

* keep one of each duplicate - not actually important which one since identical 
drop if dup==2
drop dup
save temp_child.dta, replace

*** PR data
use "/Users/gerns/Documents/Academics/thesis/data/2015/IAPR74DT/IAPR74FL.DTA", clear
cd "/Users/gerns/Documents/Academics/thesis/data/2015"

ssc install sdecode
sdecode shdistri, gen(district_string)
sdecode hv024, gen(state_string)

keep hv001 hv002 hvidx hv104 hv105 shdistri district_string state_string hhid hv001 hv002 hv104 hv105 hv106 hv107 hv108 hv109 hv121 hv122 hv123 hv124 

sort hv001 hv002 hvidx

rename hv104 sex
rename hv105 age
rename hv108 educ_num_years
rename hv106 educ_level_reached
rename hv107 educ_year_completed
rename hv109 educ_attainment
rename hv121 educ_attended_at_current_year
rename hv122 educ_level_at_current_year
rename hv123 educ_grade_at_current_year
rename hv124 educ_years_at_current_year


merge 1:1 hv001 hv002 hvidx using temp_child.dta

* Result                           # of obs.
*    -----------------------------------------
*    not matched                     2,108,931
*        from master                 2,108,923  (_merge==1)
*        from using                          8  (_merge==2)
*
*    matched                           760,120  (_merge==3)
*    -----------------------------------------

ren _merge merge_child
//summarize hv105 if line_number_of_mother>0 & line_number_of_mother<.
** merge==3 contains all observations where we do have a mother that was interviewed.

* line number of mother should match hv112 for children under 18

keep if merge_child==3
drop merge_child

rename hv001 cluster_number
rename hv002 household_number
rename hvidx child_line_number



cd "/Users/gerns/Documents/Academics/thesis/data/2015"
save final_dhs.dta,replace














