#!/usr/bin/perl -w
use Cwd;
my $mrfFile = shift;




open (MRF, $mrfFile) or die "cannot open file: $mrfFile";
@mrffile = <MRF>;
close MRF;

for (my $i=0; $i<@mrffile; $i++){
    chomp $mrffile[$i];
    my @elm1=split("\t",$mrffile[$i]);
    my @elm2=split('\|',$elm1[0]);
    my @block1=split(":",$elm2[0]);
    my @block2=split(":",$elm2[1]);    
    if(($block1[0]=~m/chr14|chrX/)&&($block2[0]=~m/chr14|chrX/)){
        my $name1=changeName($block1[0]);
        my $name2=changeName($block2[0]);;
        print "$name1 $block1[2] $block1[3] $name2 $block2[2] $block2[3]\n";
    }
    
    
}



sub changeName{
    my ($name)=@_ ;
    # substr($name, 1, 3)='hs';
    # return $name ;        
    @ elm=split("chr",$name);
    my $newName="hs".$elm[1];
    if ($newName=~m/hsX/){
        $newName='hsx';
        
    }
    return $newName;


    
    # elsif ($name=~m/chr4/){
    #     $name='hs4';
    #     return $name;
    # }

}