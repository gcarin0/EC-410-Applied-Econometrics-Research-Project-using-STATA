cd "/Users/gc/Desktop/Baseball"
import delimited "batstats", clear

// Rename vars and labels
label var hr "Home Runs"
label var slg "Slugging Percentage"
label var bb "Walk Rate (%)"
label var iso "Isolated Power"

// Destring bb and divide by 100 to put units the same as others
// Generate natural log variables to put explanatory variables in terms of % change
// rather than a 1 unit change for regression.
destring bb, ignore(%) replace
gen bbp = bb/100
gen lnbbp = ln(bbp)
gen lnslg = ln(slg)
gen lniso = ln(iso)

//Keep variables used in the hypothesis
keep hr bb iso slg lnslg lniso

//Summary statistics for dependent variable
sum hr

//Summary statistics for independent variables
sum slg
sum bb
sum iso

//Test for Normality using histograms with density overlays
//Home Runs
histogram hr, title(Home Runs in a Season (2010-2017)) subtitle(Minimum 502 Plate Appearances) ///
frequency normal name(hrnorm)

//Slugging Percentage
histogram slg, title(Slugging Percentage in a Season (2010-2017)) subtitle(Minimum 502 Plate Appearances) ///
frequency normal name(slgnorm)

//Walk Rate
histogram bb, title(Walk Rate (%) in a Season (2010-2017)) subtitle(Minimum 502 Plate Appearances) ///
frequency normal name(bbnorm)

//Isolated power
histogram iso, title(Isolated Power in a Season (2010-2017)) subtitle(Minimum 502 Plate Appearances) ///
frequency normal name(isonorm)

//Combine graphs on one page
gr combine hrnorm slgnorm bbnorm isonorm

//Scatter plots with regression lines
graph twoway (lfit hr bb) (scatter hr bb), title(Walk Rate (%) in a Season (2010-2017)) ///
subtitle(Minimum 502 Plate Appearances)

//Scatter plots with regression lines
graph twoway (lfit hr slg) (scatter hr slg), title(Slugging Percentage in a Season (2010-2017)) ///
subtitle(Minimum 502 Plate Appearances)

//Scatter plots with regression lines
graph twoway (lfit hr iso) (scatter hr iso), title(Isolated Power in a Season (2010-2017)) ///
subtitle(Minimum 502 Plate Appearances)

//Check correlation between variables
corr hr slg bb iso

//Lin-Log Regression
reg hr lnbbp lniso lnslg

//Check for functional form of dependent variable and heteroskedasticity
quietly reg hr lnbbp lniso lnslg
rvfplot, yline(0)

//Generate HR^2
gen hr2 = hr^2

//Check for functional form of dependent variable and heteroskedasticity
reg hr2 lnbbp lniso lnslg
rvfplot, yline(0)

//Test for multicollinearlity
quietly reg hr2 lnbbp lniso lnslg
vif




