#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Std;
use Cwd;

my $file = shift;
open (FILE, $file) or die "cannot open anno file";
my @file = <FILE>;

for (my $i=1; $i<@file; $i++){
    chomp $file[$i];
    my @elm=split("\t", $file[$i]);

    print "$elm[4]\t$elm[5]\t$elm[6]\t$elm[0]\t$elm[8]\n";    
    
}
