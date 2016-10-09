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


# Read text from file: 
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
