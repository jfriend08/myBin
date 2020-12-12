#!perl
  #use strict;
  #use warnings;
  use SOAP::Lite;
  use HTTP::Cookies;

  my $soap = SOAP::Lite                             
     -> uri('http://service.session.sample')                
     -> proxy('http://david.abcc.ncifcrf.gov/webservice/services/DAVIDWebService',
                cookie_jar => HTTP::Cookies->new(ignore_discard=>1));

 #user authentication by email address
 #For new user registration, go to http://david.abcc.ncifcrf.gov/knowledgebase/register.htm
 my $check = $soap->authenticate('yourEmail@your.org')->result;
  	print "\nUser authentication: $check\n";

 if (lc($check) eq "true") {  
 #list conversion types
 my $conversionTypes = $soap ->getConversionTypes()->result;
	 print  "\nConversion Types: \n$conversionTypes\n"; 
	 
 #list all annotation category names
 #my $allCategoryNames= $soap ->getAllAnnotationCategoryNames()->result;	 	  	
 #print  "\nAll available annotation category names: \n$allCategoryNames\n"; 
 
 #add gene List
 my $idType = 'AFFYMETRIX_3PRIME_IVT_ID';
 my $listName = 'geneList';
 my $listType=0;
 my $inputIds = "";
 
 #read gene lsit ids from file
 my $delimiter = ",";
 open(geneList, "<gene_list.txt");
   while(<geneList>)
   {
      my($line) = $_;   
      chomp($line);
      my $new_string = $line . $delimiter;
      $inputIds .= $new_string;
  };
  print "$inputIds\n";
close(geneList);


 my $list = $soap ->addList($inputIds, $idType, $listName, $listType)->result;
 print "\n$list of gene list was mapped\n"; 

#add background list
$listName = 'Human Genome U133 Plus 2.0 array';
$listType=1;

#read background list from file
$inputIds = "";
 open(backgroundList, "<background_list.txt");
   while(<backgroundList>)
   {
      my($line) = $_;   
      chomp($line);
      my $new_string = $line . $delimiter;
      $inputIds .= $new_string;
  };  

  close(backgroundList);  

 my $bkgList = $soap ->addList($inputIds, $idType, $listName, $listType)->result;
 
 print $soap ->getAllPopulationNames() ->result;#should return:Homo sapiens,Human Genome U133 Plus 2.0 array
 print "\n"; 
 print $soap ->getCurrentPopulation() ->result;# should return 1. If 0 returned, means currentPopulation is Homo sapiens
 print "\n";
 #set current background population to "Human Genome U133 Plus 2.0 array"
 #$soap ->setCurrentPopulation("1") ->result; 
 #print "\n";
 #print $soap ->getCurrentPopulation() ->result; #should return 1
   	
 #list all species  names
 my $allSpecies= $soap ->getSpecies()->result;	 	  	
 # print  "\nAll species: \n$allSpecies\n"; 
 #list current species  names
 my $currentSpecies= $soap ->getCurrentSpecies()->result;	 	  	
 #print  "\nCurrent species: \n$currentSpecies\n"; 

 #set user defined species 
 #my $species = $soap ->setCurrentSpecies("1")->result;

 #print "\nCurrent species: \n$species\n"; 
 
#set user defined categories 
 my $categories = $soap ->setCategories("KEGG_PATHWAY")->result;
 #to user DAVID default categories, send empty string to setCategories():
 #my $categories = $soap ->setCategories("")->result;
 #print "\nValid categories: \n$categories\n\n";  
 
open (chartReport, ">", "chartReport.txt");
print chartReport "Category\tTerm\tCount\t%\tPvalue\tGenes\tList Total\tPop Hits\tPop Total\tFold Enrichment\tBonferroni\tBenjamini\tFDR\n";
#close chartReport;

#open (chartReport, ">>", "chartReport.txt");
#getChartReport 	
my $thd=0.1;
my $ct = 2;
my $chartReport = $soap->getChartReport($thd,$ct);
	my @chartRecords = $chartReport->paramsout;
	#shift(@chartRecords,($chartReport->result));
	#print $chartReport->result."\n";
  	print "Total chart records: ".(@chartRecords+1)."\n";
  	print "\n ";
	#my $retval = %{$chartReport->result};
	my @chartRecordKeys = keys %{$chartReport->result};
	
	#print "@chartRecordKeys\n";
	
	my @chartRecordValues = values %{$chartReport->result};
	
	my %chartRecord = %{$chartReport->result};
	my $categoryName = $chartRecord{"categoryName"};
	my $termName = $chartRecord{"termName"};
	my $listHits = $chartRecord{"listHits"};
	my $percent = $chartRecord{"percent"};
	my $ease = $chartRecord{"ease"};
	my $Genes = $chartRecord{"geneIds"};
	my $listTotals = $chartRecord{"listTotals"};
	my $popHits = $chartRecord{"popHits"};
	my $popTotals = $chartRecord{"popTotals"};
	my $foldEnrichment = $chartRecord{"foldEnrichment"};
	my $bonferroni = $chartRecord{"bonferroni"};
	my $benjamini = $chartRecord{"benjamini"};
	my $FDR = $chartRecord{"afdr"};
	
	print chartReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";
	
	
	for $j (0 .. (@chartRecords-1))
	{			
		%chartRecord = %{$chartRecords[$j]};
		$categoryName = $chartRecord{"categoryName"};
		$termName = $chartRecord{"termName"};
		$listHits = $chartRecord{"listHits"};
		$percent = $chartRecord{"percent"};
		$ease = $chartRecord{"ease"};
		$Genes = $chartRecord{"geneIds"};
		$listTotals = $chartRecord{"listTotals"};
		$popHits = $chartRecord{"popHits"};
		$popTotals = $chartRecord{"popTotals"};
		$foldEnrichment = $chartRecord{"foldEnrichment"};
		$bonferroni = $chartRecord{"bonferroni"};
		$benjamini = $chartRecord{"benjamini"};
		$FDR = $chartRecord{"afdr"};			
		print chartReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";				 
	}		  	
	
	close chartReport;
	print "\nchartReport.txt generated\n";
} 
__END__
		