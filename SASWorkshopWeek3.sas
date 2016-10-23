/*Output Delivery System*/
ods trace on;
proc freq data = sampsio.hmeq;
	table BAD REASON;
	table BAD* REASON / chisq;
run;

ods output OneWayFreqs = WORK.OneWayFreqs;
proc freq data = sampsio.hmeq;
	table BAD REASON;
	table BAD * REASON;
run;
ods output close; 

proc print data = WORK.OneWayFreqs;
run;

/*Heat Map of Correlation(Suggested Codes)*/
/*Write the correlations and their association statistics to WORK.Pearsonorr*/
ods output PearsonCorr = WORK.PearsonCorr;
proc corr data = sashelp.cars;
	var _NUMERIC_;
run;
ods output close;

/*This is the default display*/
proc print data = WORK.PearsonCorr;
run;

/*Apply the best format on the P: variables which contain the significances*/
proc print data = WORK.PearsonCorr;
	format P: best32.; /*scientific E counting ways*/
run;

/*Save the correlation coefficients to a separate data*/
data WORK.CorrCoef;
	set WORK.PearsonCorr;
	rename Variable = RowVariable;
	keep Variable MSRP Invoice EngineSize Cylinders Horsepower MPG_City
	MPG_Highway Weight Wheelbase Length;
run;

/*Transpose the matrix of coefficient as columns because the default layout
from CORR is no good for Heat Map*/
proc sort data = WORK.CorrCoef;
	by RowVariable;

run;

proc transpose data = WORK.CorrCoef
	out = WORK.Data4HeatMap(rename = (COL1 = Correlation))
	name = ColumnVariable;
   by RowVariable;
   var MSRP Invoice EngineSize Cylinders Horsepower MPG_City MPG_Highway
       Weight Wheelbase Length;
run;

proc sort data = WORK.Data4HeatMap;
	by RowVariable ColumnVariable;
run;

proc print data = WORK.Data4HeatMap;
run;

/*HeatMap*/
proc template;
	define statgraph HeatMap;
	begingraph / designwidth = 800 designheight = 800;
	 entrytitle "Correlation of Numeric Variables in SASHELP.CARS";
	 layout overlay/
	    xaxisopts = (label = "Row Variable")
	    yaxisopts = (label = "Column Variable");
	    heatmapparm x = RowVariable y = ColumnVariable colorresponse = Correlation/
			name = "heatmapparm" 
			xbinaxis = false 
			ybinaxis = false;
	    continuouslegend "heatmapparm"/
			      orient = vertical location = outside
			      halign = center valign = center
			      valuecounthint = 9  title = 'Correlation';
	    endlayout;
          endgraph;
          end;
run;
  
proc sgrender data = WORK.Data4HeatMap
template = HeatMap;
run;


proc hpsample data = sampsio.hmeq  out = hmeq_sample
	seed = 60611  partition  samppct = 70;
class JOB REASON BAD;
var CLAGE CLNO DEBTINC DELINQ DEROG LOAN MORTDUE NINQ VALUE YOJ;
run;

/*Simple Random Sampling*/
/*Inspect metadata of the output dataset: hmeq_sample*/
proc contents data = hmeq_sample;
run;

/*Check distributions of the two partitions*/
proc tabulate data = hmeq_sample;
	class BAD _PARTIND_;
	tables (_PARTIND_ ALL),
	(colpctn = 'Distribution of _PARTIND_ within BAD')*(BAD ALL)
	(rowpctn = 'Distribution of BAD within _PARTIND_')*(BAD ALL);
run;


/*Stratified Sampling*/
/*70% of BAD = 0 observations go to partition as indicated by _PARTIND_ = 1*/
/*70% OF BAD = 1 observations go to partition as indicated by _PARTIND_ = 1*/
proc hpsample data = sampsio.hmeq  out = hmeq_sample
	seed = 60611  partition  samppct = 70;
	class JOB REASON BAD;
	var CLAGE CLNO DEBTINC DELINQ DEROG LOAN MORTDUE NINQ VALUE YOJ;
	target BAD;
run; 
/*Check distributions of the two partitions*/
proc tabulate data = hmeq_sample;
	class BAD _PARTIND_;
	tables (_PARTIND_ ALL),
	(colpctn = 'Distribution of _PARTIND_ within BAD') * (BAD ALL)
	(rowpctn = 'Distribution of BAD within _PARTIND_')*(BAD ALL);
run;


/*Data Partition Exercise*/
proc hpsample data = sashelp.cars   out=cars_sample
	seed = 10152016  partition  samppct = 80;
	class _CHAR_;
	var _NUMERIC_;
	target ORIGIN;
run;

proc format;
	value PartFmt 0 = '0: Validation Partition' 1 = '1: Training Partition';
run; 

proc sgpanel data = cars_sample pctlevel = cell;
	panelby _PARTIND_/rows = 2 columns = 1;
	hbar ORIGIN / stat = percent;
	format _PARTIND_ PartFmt.;
run;





	
			
	


