#!/usr/local/bin/perl

use Encode qw(decode encode);
use File::Basename 'fileparse';

sub print_prefix {

print "\@prefix : <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc: <http://purl.org/dc/terms/> .\n";
print "\@prefix obo: <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix faldo: <http://biohackathon.org/resource/faldo#> .\n";
print "\n";
print "\n";

}

my @files = @ARGV; 

&print_prefix();

foreach my $file (@files){
  #my ($basename, $dirname, $ext) = fileparse($file, qr/\..*$/);
  #print "### File:", $file,"\n";
  #print "### Basename:", $basename,"\n";
  open my $fh, $file or die $!;

  while(<$fh>) {
    chop;
    my (
    $marker_id, $species_id, $marker_name, $sub_number, $marker_type,
    $mapped_genome_id, $reference_seq_name, $chr, $fwd_primer_seq, $fwd_primer_start_pos,
    $fwd_primer_end_pos, $rev_primer_seq, $rev_primer_start_pos, $rev_primer_end_pos, $target_seq,
    $allele, $enzyme, $comments, $doi, $pubmed,
    $f_active # NOT NULL DEFAULT '0' COMMENT '0:inactive, 1:active',
    ) = split(/\t/);

    #my $comments_encode = encode('UTF-8', $comments);
    #print "### Marker ID: ", $marker_id,"\n";
    $target_seq =substr($target_seq, '"',''); # for t29760.M000059.1

    my $ttl =<< "RDF";
<http://plantgarden.jp/resource/${marker_id}> rdf:type  obo:SO_0000207 ;
  rdf:type :Marker ;
  dc:identifier "${marker_id}" ;
  :species_id "${species_id}" ;
  rdfs:seeAlso <https://plantgarden.jp/en/list/${species_id}/marker/${marker_id}> ;
  rdfs:seeAlso <https://plantgarden.jp/ja/list/${species_id}/marker/${marker_id}> ;
  :species  <http://plantgarden.jp/resource/${species_id}> ;
  rdfs:label  "${marker_name}" ;
  :sub_number ${sub_number} ;
  :marker_type  "${marker_type}" ;
  :mapped_genome_id "${mapped_genome_id}" ;
  :genome  <http://plantgarden.jp/resource/${mapped_genome_id}> ;
  :reference_seq_name "${reference_seq_name}" ;
  :chr  "${chr}" ;
  :target_seq "${target_seq}" ;
  :allele "${allele}" ;
  :enzyme "${enzyme}" ;
  :doi  "${doi}" ;
  dc:references "${pubmed}" ;
  :f_active "${f_active}".
RDF
  #rdfs:comment  '${comments_encode}' ;

    print $ttl,"\n";
    if ($mapped_genome_id ne 'NA' and ${fwd_primer_start_pos} ne 'NA'){
      my $ttl_location =<<"RDF";
<http://plantgarden.jp/resource/${marker_id}>
  :has_forword_primer <http://plantgarden.jp/resource/${marker_id}#forword-primer> ;
  :has_reverse_primer <http://plantgarden.jp/resource/${marker_id}#reverse-primer> .

<http://plantgarden.jp/resource/${marker_id}#forword-primer>
  rdf:type  obo:SO_0000121 ;
  rdfs:label  "${marker_id}#forword-primer" ;
  :sequence "${fwd_primer_seq}" ;
  faldo:location  [
    rdf:type  faldo:Region ;
    faldo:begin [
      faldo:position  ${fwd_primer_start_pos} ;
      faldo:reference <https://plantgarden.jp/en/list/${species_id}/sequence/$chr> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition 
      ] ;
    faldo:end   [
      faldo:position  ${fwd_primer_end_pos} ;
      faldo:reference <https://plantgarden.jp/en/list/${species_id}/sequence/$chr> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition 
      ]
  ] .

<http://plantgarden.jp/resource/${marker_id}#reverse-primer>
  rdf:type  obo:SO_0000132 ;
  rdfs:label  "${marker_id}#reverse-primer" ;
  :sequence "${rev_primer_seq}" ;
  faldo:location  [
    rdf:type  faldo:Region ;
    faldo:begin [
      faldo:position  ${rev_primer_start_pos} ;
      faldo:reference <https://plantgarden.jp/en/list/${species_id}/sequence/$chr> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition 
      ] ;
    faldo:end   [
      faldo:position  ${rev_primer_end_pos} ;
      faldo:reference <https://plantgarden.jp/en/list/${species_id}/sequence/$chr> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition 
      ]
  ] .

RDF

      print  $ttl_location,"\n";
    }
   #exit;
  }
}
