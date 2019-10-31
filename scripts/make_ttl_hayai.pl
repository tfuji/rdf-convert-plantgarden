#!/usr/local/bin/perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix faldo:        <http://biohackathon.org/resource/faldo#> .\n";
print "\@prefix sio: <http://semanticscience.org/resource/> .\n";
print "\n";

while(<>) {
    chop;
    @a = split(/\t/);
    next if $cnt++ == 0;
    my $genome_assembly_id = shift @a;
    my $annotation_version = shift @a;
    my $cds_id= shift @a;
    my $pep_id= shift @a;
    my $genus_name= shift @a;
    my $family_name= shift @a;
    my $phylum_name= shift @a;
    my $superkingdom_name= shift @a;
    my $uniprot_db= shift @a;
    my $ortho_db= shift @a;
    my $description= shift @a;
    my $identity= shift @a;
    my $alignment_length= shift @a;
    my $number_of_mismatch= shift @a;
    my $number_of_gap_open= shift @a;
    my $e_value= shift @a;
    my $bit_score= shift @a;
    my $chromosome= shift @a;
    my $gene_start= shift @a;
    my $gene_end= shift @a;
    my $gene_strand= shift @a;
    my $ec_number= shift @a;
    my $go_bp= shift @a;
    my $go_bp_name= shift @a;
    my $go_mf= shift @a;
    my $go_mf_name= shift @a;
    my $go_cc= shift @a;
    my $go_cc_name= shift @a;
    my $ko_id= shift @a;
    my $ko_definition= shift @a;
    my $ko_gene_name= shift @a;
    #my $comments= shift @a;
    
     my @b = split(/\./,$genome_assembly_id);
     my $taxid = my $spid = @b[0];
     $taxid =~s/^t//;
     my $gene_id = $cds_id; #FIXME
     

     my $start   =  ( $gene_strand eq '-') ?  $gene_end : $gene_start ;
     my $stop    =  ( $gene_strand eq '-') ?  $gene_start : $gene_end ;
     my $fdirect = ( $gene_strand eq '-') ? 'ReverseStrandPosition' : 'ForwardStrandPosition';

my $ttl =<< "RDF";
<https://plantgarden.jp/en/list/$spid>
    :family_name "$family_name" ;
    :genome_assembly_id "$genome_assembly_id" ;
    :genus_name "$genus_name" ;
    :phylum_name "$phylum_name" ;
    :superkingdom_name "$superkingdom_name" .

<https://plantgarden.jp/en/list/$spid/all/$gene_id>
    faldo:location [
        faldo:begin [
            faldo:position $start ;
            faldo:reference <https://plantgarden.jp/en/list/$spid/sequence/$chromosome> ;
            a faldo:ExactPosition, faldo:$fdirect
        ] ;
        faldo:end [
            faldo:position $stop ;
            faldo:reference <https://plantgarden.jp/en/list/$spid/sequence/$chromosome> ;
            a faldo:ExactPosition, faldo:$fdirect
        ] ;
        a faldo:Region
    ] ;
    a obo:SO_0000704 .

<https://plantgarden.jp/en/seq/$spid/$genome_assembly_id/cds/$cds_id>
    obo:BFO_0000050 <https://plantgarden.jp/en/list/$spid/all/$gene_id> ;
    obo:RO_0002162 <http://identifiers.org/taxonomy/$taxid> ;
    dc:identifier "$cds_id" ;
    a obo:SO_0000316 ;
    rdfs:comment "" ;
    :annotation_version "$annotation_version" .

<https://plantgarden.jp/en/seq/$spid/$genome_assembly_id/pep/$pep_id>
    obo:RO_0001000 <https://plantgarden.jp/en/seq/$spid/$genome_assembly_id/cds/$cds_id> ;
    dc:indentifier "$pep_id" ;
    rdfs:label "$description" ;
    sio:SIO_000558 <http://purl.uniprot.org/uniprot/$uniprot_db> ;
    a obo:SO_0000104 ;
    :classifiedWith <https://identifiers.org/kegg.orthology:$koid> .
RDF
#    :classifiedWith obo:GO_0003735;
#    :classifiedWith obo:GO_0006412;
#    :classifiedWith obo:GO_0022625;

print $ttl,"\n";
}
