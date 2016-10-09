# SAS-Workshop

libname workshop '/home/mllam/SASWorkshop/';

# library reference and dataset name
data workshop.HotelNearGleacher;   

# INPUT statement indicates variable input specifications
# HotelName is a string ($) from column 1 to 50
# DistanceFromGleacher is a number (thus not $) from column 54-57
# Rating is a number from column 59-61
# Nreviews is a number from column 63-66
# Price is a number from column 68-70
# Decimal place is inferred from input value
input HotelName $ 1-50 DistanceFromGleacher 54-57 Rating 59-61 NReviews 63-66 Price 68-70;

# Assign a variable label to a variable
label HotelName = 'Hotel Name';
label DistanceFromGleacher = 'Distance (miles) from Gleacher Center';
label Rating = 'Rating out of 5';
label NReviews = 'Number of Reviews';
label Price = 'Price for 1 Adult, 1 Night';

# Assign a format to a variable
# w.d format displays a number with d decimal places in a field of width w
# Dollarw.d format displays a number with d decimal places in a field of width w (counts the $ sign in width w)
format DistanceFromGleacher 4.2;
format Rating 3.1;

format NReviews 4.0;
format Price dollar4.0;

# Indicates observations come next
datalines;
Sheraton Chicago Hotel and Towers                    0.10 4.1 1501 289
Hyatt Regency Chicago                                0.12 4.4 2770 279
Embassy Suites Chicago Downtown - Lakefront          0.15 4.4 2289 279
InterContinental Chicago Magnificent Mile            0.15 4.2  900 259
Swissotel - Chicago                                  0.18 4.4  870 400

Comfort Suites Chicago                               0.20 4.4  416 229
Chicago Marriott Downtown Magnificent Mile           0.20 4.1  595 289
Inn of Chicago, an Ascend Hotel Collection Member    0.21 3.7 1705 229
Conrad Chicago                                       0.21 4.7  661 275
Club Quarters, Wacker at Michigan                    0.22 4.3 1800 249
River Hotel                                          0.23 4.3 1278 279
DoubleTree by Hilton Chicago - Magnificent Mile      0.23 4.3 1290 249
Radisson Blu Aqua Hotel Chicago                      0.23 4.6  479 384
Wyndham Grand Chicago Riverfront                     0.24 4.5 1516 299
Hard Rock Hotel Chicago                              0.24 4.3 1620 254


# Execute the above DATA step
run;


# Read data from textfile: 
infile ‘/home/mllam/SASWorkshop/HotelNearGleacher.txt';
data workshop.HotelNearGleacher;
infile '/home/mllam/SASWorkshop/HotelNearGleacher.txt';
input HotelName $ 1-50 DistanceFromGleacher 54-57 Rating 59-61 NReviews 63-66 Price 68-70;

label HotelName = 'Hotel Name';
label DistanceFromGleacher = 'Distance (miles) from Gleacher Center';
label Rating = 'Rating out of 5';
label NReviews = 'Number of Reviews';
label Price = 'Price for 1 Adult, 1 Night';
format DistanceFromGleacher 4.2;
format Rating 3.1;
format NReviews 4.0;
format Price dollar4.0;
/* No DATALINES */

run;

# Read data from Excel:
libname workshop '/home/mllam/SASWorkshop';
proc import datafile = '/home/mllam/SASWorkshop/HotelNearGleacher.xlsx'
            dbms = xlsx   #specifies the import file is a Excel 2007+ file
            out = workshop.HotelNearGleacher  #specifies the output SAS dataset
            replace;   #overwrites an existing SAS dataset
            run;
            


# Use PROC IMPORT to read SPSS dataset (.sav extension)
libname workshop ‘/home/mllam/SASWorkshop';
proc import datafile = '/home/mllam/SASWorkshop/cellular.sav'
            dbms = spss  #specifies the import file is a SPSS file   
            out = workshop.SPSS_cellular   #specifies the output SAS dataset
            replace;  #specifies the output SAS dataset
run;


# Add labels and formats to the results of the previous Excel Import step
# 1. Use PROC DATASETS to add labels and formats without creating additional data
# 2. Use the SET statement to copy the existing dataset to a new dataset, and then add labels and formats to the new dataset
proc datasets library = workshop;   /* Define the library reference */
   modify HotelNearGleacher;        /* Modify this data in the library */
   label HotelName = 'Hotel Name';  /* Modify labels */
   label DistanceFromGleacher = 'Distance (miles) from Gleacher Center';
   label Rating = 'Rating out of 5';
   label NReviews = 'Number of Reviews';
   label Price = 'Price for 1 Adult, 1 Night';
   format DistanceFromGleacher 4.2; /* Modify formats */
   format Rating 3.1;
   format NReviews 4.0;
   format Price dollar4.0;
quit;     /* Run and Exit interactive procedure */


# Select Hotel with price under $300 Canadian Dollars one night
data workshop.HotelNearGleacher (label = 'Hotels within 1/4 mile from Gleacher Center');
   set workshop.HotelNearGleacher;

   ChicagoHotelTaxRate = 4.5;
   ActualCostCAN = (1 + ChicagoHotelTaxRate / 100) * Price; /* Create new variable */
   ActualCostCAN = 1.0832 * ActualCostCAN;                  /* Transform existing variable */
   label ActualCostCAN = 'Actual Hotel Cost in Canadian Dollars per Night';
   format ActualCostCAN dollar7.2;

   length Consider $ 1;           /* Define a string variable of 1 character long */
   if (ActualCostCAN le 300) then Consider = 'Y';  /* Condition statement IF-THEN-ELSE */
   else Consider = 'N';
   label Consider = 'Consider the Hotel (Y/N)?';

   drop ChicagoHotelTaxRate;      /* Delete this temporary variable */
run;


# Short-list the hotels that I will consider
data workshop.HotelConsider (label = 'Hotels I Can Consider');
   set workshop.HotelNearGleacher;    /* Retrieve existing dataset */
   if (Consider eq 'Y') then output;  /* Write record if Consider = ‘Y’ */
   drop Consider;                     /* Since Consider = ‘Y’ on all records */
run;








