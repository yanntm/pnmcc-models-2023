#! /usr/bin/perl


my @index = ("00","01","02","03","04","05","06","07","08","09","10","11","12","13","14","15");
my %globalProperties = (
	"ReachabilityDeadlock" => 1,
	"Liveness" => 1,
	"StableMarking" => 1,
	"QuasiLiveness" => 1,
	"OneSafe" => 1 ) ;

while (my $line = <STDIN>) {
    # print $line;
    chomp $line;
  my @fields = split /,/, $line;
  my $modelname = @fields[0];
  
  my $examination = @fields[1];
  my $prefix = $modelname."-".@fields[1];
 
 # A patch for 2020 name of formula
 # $prefix =~ s/HouseConstruction-PT-00020/HouseConstruction-PT-0020/;

  # Names of LTL formulas are now patched outside of this script
  #if ($examination =~ /LTL.*/) {
  #	# in 2023 no examination in these formulas
  #	$prefix = $modelname ;
  #}
  @fields[2] =~ s/[\(\)]//g;
  my @verdicts = split //, @fields[2];

   # print "Verdicts ($#verdicts) = @verdicts \n";
  if ($#verdicts != 15 && $#verdicts != 0) {
    @verdicts = split / /, @fields[2];
    if ($#verdicts != 15) {
	    next;
	}
  }
  my $abbrev = @fields[1];
  $abbrev =~ s/[a-z]//g;
  
  my $outff = $modelname."-".$abbrev.".out";
  my $csvff = "consensus.csv";

  if (-f $outff) {
      print "Not overwriting existing oracle file $outff\n";
  } else {
      print "doing $prefix, in file $outff has ".($#verdicts + 1)." entries \n";  
      open OUT, "> $outff";
      open CSV, ">> $csvff";
      # model examination
      print OUT @fields[0]." ".@fields[1] ."\n";
      for (my $i=0 ; $i <= $#verdicts ; $i++) {
		  my $res = @verdicts[$i];   
		  $res =~ s/F/FALSE/g;
		  $res =~ s/T/TRUE/g;
		  $res =~ s/(\d)\.0000E\+0005/${1}00000/g ;
		  if ($globalProperties{$examination}) {
			# GlobalProperties cases : formula name is simply examination
		  	print OUT "FORMULA ".$examination." ".$res." TECHNIQUES ORACLE2023\n";
			print CSV  @fields[0].",".@fields[1].",0,".$res."\n";
		  } else {
			  if ($#verdicts != 0) {
			  	  # ordinary case : 16 formulas
				  print OUT "FORMULA ".$prefix."-".@index[$i]." ".$res." TECHNIQUES ORACLE2023\n";
				  print CSV  @fields[0].",".@fields[1].",".@index[$i].",".$res."\n";
			  } else {
			  	# total failure of all tools in 2023, simulate question mark answer
			  	foreach (@index) {
				  	print OUT "FORMULA ".$prefix."-".$_." "."?"." TECHNIQUES ORACLE2023\n";
					print CSV  @fields[0].",".@fields[1].",".$_.",".$res."\n";
			  	}
			  }		  	
		  }
      }
      close OUT;
      close CSV;
  }
}

# for COL formula names in PT models, it might be necassary to run this in sh.
# for j in `(for i in *COL*.out ; do echo $i | sed 's/-.*\.out//'  ; done) | uniq ` ; do for k in $j*PT*.out ; do cat $k | sed -re 's/(FORMULA.*)PT(.*)/\1COL\2/g' > $k.bak ; \mv $k.bak $k  ; done ; done 
