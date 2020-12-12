#!/usr/bin/perl -w
use 5.010;
use Cwd;

my $input = shift;
open (FILE, $input) or die "cannot open samstat html file"; 
my @file = <FILE>;
close FILE;

foreach my $line (@file){
    chomp $line;
    my @elm=split("\t", $line);
    my @info=split(";", $elm[3]);
    foreach my $eachinfo (@info){
        if ($eachinfo =~ m/transcript_name/){
            push(@elm, $eachinfo);
        }
    }
    my $line=join ("\t", @elm);
    print "$line\n";
}