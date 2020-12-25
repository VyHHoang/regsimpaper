*Raw dataset 
use "I:\20211-ECON385A\VYHOANG_2021\Paper\Dataset and Do-file\Double Majoring Dataset.dta" 


*Data recoding-------------
*1) Drop unnescessary observations
drop if incwage <= 1000 //deleting all the income entries that has income less than $1000 
drop if degfield == 0 & degfield2 == 0 //deleting those who do not have any majors
drop if uhrswork == 00 //deleting those who do not work at all 
*2) Educyears variable
gen educYears = 13 if educ == 07
replace educYears = 14 if educ == 08
replace educYears = 15 if educ == 09
replace educYears = 16 if educ == 10
replace educYears = 18 if educ == 11
label variable educYears "Years of Education"
*3) Recode sex variable
gen female = 1 if sex == 2 
replace female = 0 if sex == 1
label variable female "Female"
*4) Recode race variable
gen white = 1 if race == 1
replace white = 0 if race != 1
label variable white "White"

gen black = 1 if race == 2 
replace black = 0 if race != 2
label variable black "Black"

gen asian = 1 if race == 4 | race == 5 | race == 6
replace asian = 0 if race != 4 & race != 5 & race != 6 
label variable asian "Asian"

gen others = 1 if race == 3 | race == 7 | race == 8 | race == 9
replace others = 0 if race != 3 & race != 7 & race !=8 & race != 9 
label variable others "Other races"
*5) Recode hispan variable
gen hispanic = 0 if hispan == 0 | hispan == 9
replace hispanic  = 1 if hispan != 0 & hispan != 9 
label variable hispanic "Hispanic"
*3) Create experience and Experience squared 
gen experience = age - educYears - 6
gen experienceSq = experience^2
label variable experience "Experience"
label variable experienceSq "Experience Squared"
*4) Double majoring (1=yes)
gen doubleMajoring = 1 if degfield != 0 & degfield2 != 0 
replace doubleMajoring = 0 if degfield ==0 | degfield2 == 0
label variable doubleMajoring "Double Majoring"
*5)Creating the independent variable 
gen lnINCWAGE = ln(incwage)
label variable lnINCWAGE "ln(Earnings)"
*6) Create Fulltime worker variable
gen fulltime = 1 if uhrswork >= 20
replace fulltime = 0 if uhrswork < 20
label variable fulltime "Full-time workers"
*Figures-------------
hist incwage, freq

hist doubleMajoring, freq

*Regression and table-------------------
ssc install estout 

**Dataset summary table
eststo: estpost summarize incwage female age white black asian others hispanic experience fulltime educYears doubleMajoring
esttab using summaryTable.rtf, label nonumber nomtitle cells("mean(fmt(2)) sd(fmt(2)) min(fmt(2)) max(fmt(2))")

eststo clear

*1) Model 1
eststo: regress lnINCWAGE doubleMajoring
di e(r2_a) 
*2) Model 2 
eststo: regress lnINCWAGE doubleMajoring educYears experience experienceSq
di e(r2_a) 
*3) Model 3
eststo: regress lnINCWAGE doubleMajoring educYears experience experienceSq fulltime
di e(r2_a) 
*4) Model 4
eststo: regress lnINCWAGE doubleMajoring educYears experience experienceSq fulltime female white black asian others hispanic
di e(r2_a)
*5) Model 5
eststo: regress lnINCWAGE doubleMajoring educYears experience experienceSq fulltime female white black asian others hispanic [pw=perwt]
di e(r2_a)

*Store the regression result in regressionTable.rtf
esttab using regressionTable.rtf, ar2 label nobaselevels se 



