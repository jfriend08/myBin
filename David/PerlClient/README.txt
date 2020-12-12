DAVID Web Service client using Perl
=============================================
The sample client files contain Perl source code showing you how to connect DAVID Web service 
and generate your reports. 

Prerequisites
==============
Download and install Perl SOAP::Lite 0.712


Following the steps:

1. Download  PerlClient-1.1.zip from DAVID WebService site:
       http://david.abcc.ncifcrf.gov/webservice/sample_clients/PerlClient-1.1.zip

2. Extract PerlClient-1.1.zip to your working directory: $PerlClient

3. go to your directory $PerlClient
   
   Run the client file by typing "perl ChartReport.pl" in command line
   Check the report ChartReport.txt in your working directory

   ***If getChartReport (in line 64) failed and the error message is "Incorrect parameter at C:/Perl/site/lib/SOAP/Lite.pm line 1993." 
      Change SOAP/Lite.pm line 1993 from:  
      die "Incorrect parameter" unless $itself =~/^\d$/;
      to
      die "Incorrect parameter" unless $itself =~/^\d+$/;
   ***

4. Edit ChartReportClient.pl to make your own client file in your working directory

5. Run your client file and generate your own report text file 


