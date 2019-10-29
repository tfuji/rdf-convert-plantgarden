#!/usr/local/bin/perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix        rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix        rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix        dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix        obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix        faldo:        <http://biohackathon.org/resource/faldo#> .\n";

#------------------------------

my $cnt = 0;
my $sp = "<i>Fragaria</i> x <i>ananassa</i>";

while(<>) {
    chop;
    @a = split(/\t/);
    next if $cnt++ == 0;
	$markerid = $a[0];
	$speciesid = $a[1];
	$markername = $a[2];
	$subnum = $a[3];
	$markertype = $a[4];
	$mappedgenomeid = $a[5];
	$species = "<https://plantgarden.jp/en/list/t3747/genome/t3747.G002>";
	$refseqname = $a[6];
	$chr = $a[7];
	$fwprimer = $a[8];
	$fwprimerstart = $a[9];
	$fwprimerend = $a[10];
	$rvprimer = $a[11];
	$rvprimerstart = $a[12];
	$rvprimerend = $a[13];
	$targetseq = $a[14];
	$allele = $a[15];
	$enzyme = $a[16];
	$comment = $a[17];
	$doi = $a[18];
	$pmd = $a[19];
	$act = $a[20];

#------------------------------
  
  #my ($spcode, $mid) = each(split("\.",$markerid));
  my @b = split(/\./,$markerid);
  my $spid = @b[0];
  #print $spid,"\n";
  my $x = $mappedgenomeid eq 'NA' ? '.' : ';';

my $ttl =<< "RDF";
<https://plantgarden.jp/en/list/$spid/marker/$markerid> rdf:type  obo:SO_0000207 ;
  dc:identifier "$markerid" ;
  :species_id "$speciesid" ;
  :has_species  <https://plantgarden.jp/en/list/$speciesid> ;
  rdfs:label  "$markername" ;
  :sub_number $subnum ;
  :marker_type  "$markertype" ;
  :mapped_genome_id "$mappedgenomeid" ;
  :has_species  <https://plantgarden.jp/en/list/$speciesid/genome/$mappedgenomeid> ;
  :reference_seq_name "$refseqname" ;
  :chr  "$chr" ;
  :target_seq "$targetseq" ;
  :allele "$allele" ;
  :enzyme "$enzyme" ;
  rdfs:comment  "$comment" ;
  :doi  "$doi" ;
  dc:references "$pmd" ;
  :f_active "$act".
RDF

print $ttl,"\n";
if ($mappedgenomeid ne 'NA'){

my $ttl_location =<<"RDF";
<https://plantgarden.jp/en/list/$spid/marker/$markerid>  :has_forword_primer <https://plantgarden.jp/en/list/$speciesid/marker/$markerid#forword-primer> ;
  :has_reverse_primer <https://plantgarden.jp/en/list/$speciesid/marker/$markerid#reverse-primer> .
<https://plantgarden.jp/en/list/$speciesid/marker/$markerid#forword-primer> faldo:location  [
  rdf:type  faldo:Region ;
  rdf:type  obo:SO_0000121 ;
  rdfs:label  "$markerid#forword-primer" ;
  :sequence "$fwprimer" ;
  faldo:begin [
  faldo:position  $fwprimerstart ;
  faldo:reference <https://plantgarden.jp/en/list/$speciesid/sequence/$chr> ;
  rdf:type  faldo:ExactPosition ;
  rdf:type  faldo:ForwardStrandPosition 
    ] ;
  faldo:end   [
  faldo:position  $fwprimerend ;
  faldo:reference <https://plantgarden.jp/en/list/$speciesid/sequence/$chr> ;
  rdf:type  faldo:ExactPosition ;
  rdf:type  faldo:ForwardStrandPosition 
    ]
  ] .
<https://plantgarden.jp/en/list/$speciesid/marker/$markerid#reverse-primer> faldo:location  [
  rdf:type  faldo:Region ;
  rdf:type  obo:SO_0000132 ;
  rdfs:label  "$markerid#reverse-primer" ;
  :sequence "$rvprimer" ;
  faldo:begin [
  faldo:position  $rvprimerstart ;
  faldo:reference <https://plantgarden.jp/en/list/$speciesid/sequence/$chr> ;
  rdf:type  faldo:ExactPosition ;
  rdf:type  faldo:ForwardStrandPosition 
    ] ;
  faldo:end   [
  faldo:position  $rvprimerstart ;
  faldo:reference <https://plantgarden.jp/en/list/$speciesid/sequence/$chr> ;
  rdf:type  faldo:ExactPosition ;
  rdf:type  faldo:ForwardStrandPosition 
    ]
  ]
.
RDF

print  $ttl_location,"\n";
}
#exit;
}
