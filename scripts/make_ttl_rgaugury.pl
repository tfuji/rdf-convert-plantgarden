#!/usr/local/env perl

# perl scripts/make_ttl_rgaugury.pl RGAugury/Citrullus_lanatus/watermelon_v1.RGA.info.txt > t3654.G002.rgaugury.ttl
# FIXME : Resolve sp_id and genome_id 
# TODO: : Define RGA identification in OWL 

print << 'RDF';
@prefix :  <https://plantgardden.jp/ns/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .

RDF

#------------------------------
#ID      Length(aa)      Type    Gene Structure
#Cla017476       332     NBS>CN  .
#Cla015257       1036    NBS>CNL .


while(<>) {
    chop;
    @a = split(/\t/);
    my $locusID = $a[0]; # t34305.T000001
    next if $locusID eq 'ID';
    my $length = $a[1]; # NA
    my $type = $a[2]; # 
    my $gene_structure = $a[3]; # 

    my $spid = "t3654";
    my $genomeid = "t3654.G002";
    $type =~ s/NBS>//;

  # https://plantgarden.jp/ja/list/t3654/genome/t3654.G002/Cla001162
  my $subject = "https://plantgarden.jp/en/list/$spid/genome/$genomeid/$locusID";

my $ttl =<< "RDF";
<$subject> rdf:type :$type .
RDF

print $ttl;

}
