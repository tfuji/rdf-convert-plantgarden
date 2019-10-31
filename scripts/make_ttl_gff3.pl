#!/usr/bin/env perl

#use strict;
#use warnings;
use Data::Dumper;

my $file = shift;
my $genome = { 
   'FANhybrid_r1.2.genes.gff3' => 't3747.G001', #Fragaria x ananassa 
   'Glycine_max.Glycine_max_v2.1.42.chr.gff3' => 't3847.G001', #Glycine max
   'glyma.Lee.gnm1.ann1.6NZV.gene_models_main.gff3', => 't3847.G002',
   'GWHAAEV00000000.gff' => 't3847.G003',
   'Brapa_genome_v3.0_genes.gff3' => 't3711.G001', #Brassica rapa
   'Lj3.0_gene_models.gff3' => 't34305.G002', # Lotus japonicus
   'Lj3.0_gene_models2.gff3' => 't34305.G002' # Lotus japonicus

   }; 
my $gid = $genome->{$file} or die "unkown: plant genome.";


print "\@prefix : <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc: <http://purl.org/dc/terms/> .\n";
print "\@prefix obo: <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix faldo: <http://biohackathon.org/resource/faldo#> .\n";
print "\n";

#------------------------------

my @keys  = qw/seqid source feature start stop score direct frame attribute/;
my $gff ={};
my $feature ={};
open(IN, $file) or die("error :$!");
while(<IN>) {
    chomp();
    #print $_,"\n";
    my @values = split(/\t/,$_);
    @$gff{@keys} = @values;
    $gff->{'_attrs'} = &parse_attrs($gff->{'attribute'}) ;
    $gff->{'_meta'} = &metadata($gid) ;
    &gene_ttl($gff) if $gff->{'feature'} eq 'gene';
    $feature->{$gff->{'feature'}} += 1;
  }
close(IN);

print Dumper $feature ;

sub parse_attrs {
  my $attrs = shift;
  my @attr  = split(/\s*;\s*/,$attrs);
  return { map { split /=/, $_ } @attr } ;
  }

sub metadata {
  my $gid =  shift;
  my @b = split(/\./,$gid);
  my $spid = @b[0];
  return {
      'spid' => $spid,
      'gid' => $gid
  }
}

sub gene_ttl {
  my $gff = shift @_;
  #print Dumper $gff;
  my $seqid = $gff->{'seqid'};
  my $source = $gff->{'source'};
  my $fature= $gff->{'feature'};
  #my $start = $gff->{'start'};
  #my $stop = $gff->{'stop'};
  my $score = $gff->{'score'};
  my $direct = $gff->{'direct'};
  my $frame = $gff->{'frame'};
  #my $atts = $gff->{'_attrs'};
  my $spid =  $gff->{'_meta'}->{'spid'};
  my $fid  =  $gff->{'_attrs'}->{'ID'};
  my $pid  =  $gff->{'_attrs'}->{'Parent'};

  my $start   =  ( $direct eq '-') ?  $gff->{'stop'} : $gff->{'start'};
  my $stop    =  ( $direct eq '-') ?  $gff->{'start'} : $gff->{'stop'};

  my $fdirect = ( $direct eq '-') ? 'ReverseStrandPosition' : 'ForwardStrandPosition';

  my $feature_id  = $fid ; 
  $fid =~s/^gene://;
  
print $ttl_gene =<< "RDF";
<https://plantgarden.jp/en/seq/$spid/all/$fid> rdf:type  obo:SO_0000704 ; # Gene
  dc:identifier "$fid" ;
  rdfs:label  "$feature_id" ;
  faldo:location  [
    rdf:type  faldo:Region ;
    faldo:begin [
      faldo:position  $start ;
      faldo:reference <https://plantgarden.jp/en/list/$spid/sequence/$seqid> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:$fdirect 
      ] ;
    faldo:end   [
      faldo:position  $stop ;
      faldo:reference <https://plantgarden.jp/en/list/$spid/sequence/$chr> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:$fdirect
      ]
    ] .

RDF

}

#print  $ttl_location,"\n";
#}
#exit;
#}
