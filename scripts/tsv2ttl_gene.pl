#!/usr/local/bin/perl

# /home/metabobank/private/PlantGarden/data/mysql/import_gene/*_gene.import.tsv
#
use File::Basename 'fileparse';

my @files = @ARGV;
foreach my $file (@files){
  my ($basename, $dirname, $ext) = fileparse($file, qr/\..*$/);
  print "### File:", $file,"\n";
  print "### Basename:", $basename,"\n";
  open my $fh, $file or die $!;

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix faldo:        <http://biohackathon.org/resource/faldo#> .\n";
print "\@prefix sio: <http://semanticscience.org/resource/> .\n";
print "\n";

# gene_id,genome_assembly_id,queryid_pep,queryid_cds,kusakidb_accession,kusakidb_version,chromosome_number,genome_gene_start,genome_gene_end,genome_frame_position,evidence_existence,databases_intersection,orthodb_version,orthodb_description,orthodb_gene_id,orthodb_unique_id,source_db,source_description,source_accession,xref_uni2ref,ec_number,kegg_entry,ko_id,flawed_stop_codons,plant_tfdb_family,plant_tfdb_description,species_target,family_target,phylum_target,superkingdom_target

while(<$fh>) {
    chop;
    print "### ",$_,"\n";
    @a = split(/\t/);
    my(
    #t34305.G001.037980      t34305.G001     LjSGA_000035.2.1        LjSGA_000035.2.1        KPRO01582076
    $gene_id, $genome_assembly_id, $queryid_pep, $queryid_cds, $kusakidb_accession,
    # 2       LjSGA_000035    1005    1239    -       
    $kusakidb_version, $chromosome_number, $genome_gene_start, $genome_gene_end, $genome_frame_position,
    # Yes     orthodb-refseq-uniprot  10.1    uncharacterized protein LOC107787590    
    $evidence_existence, $databases_intersection, $orthodb_version, $orthodb_description, $orthodb_gene_id,
    # 4081_0:00635d   169343at33090   ref     hypothetical protein (mitochondrion)    YP_009941480    
    $orthodb_unique_id, $source_db, $source_description, $source_accession, $xref_uni2ref,
    # NA      NA      NA      NA      The gene has stop codons in the middle of the protein sequence  
    $ec_number,$kegg_entry,$ko_id,$flawed_stop_codons, $plant_tfdb_family,
    # NA      NA      Fagus sylvatica Fagaceae        Streptophyta    Eukaryota
    $plant_tfdb_description, $species_target, $family_target, $phylum_target, $superkingdom_target) 
    = split(/\t/,$_);
    #next if $cnt++ == 0;
    
     my ($spid, $gid) = split(/\./,$genome_assembly_id);
     my $taxid = substr($spid,"t","");
     my $start   =  ( $genome_frame_position eq '-') ? $genome_gene_end : $genome_gene_start ;
     my $stop    =  ( $genome_frame_position eq '-') ? $genome_gene_start : $genome_gene_end ;
     my $fdirect = ( $genome_frame_position eq '-') ? 'ReverseStrandPosition' : 'ForwardStrandPosition';

# sequnece: <https://plantgarden.jp/en/list/$spid/sequence/$chromosome>

my $ttl =<< "RDF";
<http://plantgarden.jp/resource/$genome_assembly_id/gene#$gene_id> #Gene
    faldo:location [
        faldo:begin [
            faldo:position $start ;
            faldo:reference <http://plantgarden.jp/resource/$genome_assembly_id/sequence#$chromosome_nubmer> ;
            a faldo:ExactPosition, faldo:$fdirect
        ] ;
        faldo:end [
            faldo:position $stop ;
            faldo:reference <http://plantgarden.jp/resource/$genome_assembly_id/sequence#$chromosome_nubmer> ;
            a faldo:ExactPosition, faldo:$fdirect
        ] ;
        a faldo:Region
    ] ;
    rdfs:seeAlso <https://plantgarden.jp/en/list/$spid/all/$gene_id> ;
    rdfs:seeAlso <https://plantgarden.jp/ja/list/$spid/all/$gene_id> ;
    dc:identifier "$gene_id";
    a obo:SO_0000704 .

<http://plantgarden.jp/resource/$genome_assembly_id/cds#$queryid_cds> #CDS
    obo:BFO_0000050 <http://plantgarden.jp/resource/gene#$gene_id> ;
    obo:RO_0002162 <http://identifiers.org/taxonomy/$taxid> ;
    dc:identifier "$queryid_cds" ;
    a obo:SO_0000316 ;
    rdfs:comment "" ;
    rdfs:seeAlso <https://plantgarden.jp/en/seq/$spid/$genome_assembly_id/cds/$queryid_cds> ;
    rdfs:seeAlso <https://plantgarden.jp/ja/seq/$spid/$genome_assembly_id/cds/$queryid_cds> ;
    dc:identifier "$queryid_cds" ;
    :annotation_version "$annotation_version" .

<http://plantgarden.jp/resource/$genome_assembly_id/pep#$queryid_pep> #Peptide
    obo:RO_0001000 <http://plantgarden.jp/resource/$genome_assembly_id/cds#$queryid_cds> ;
    dc:indentifier "$queryid_pep" ;
    rdfs:label "$description" ;
    sio:SIO_000558 <http://purl.uniprot.org/uniprot/$uniprot_db> ;
    a obo:SO_0000104 ;
    rdfs:seeAlso <https://plantgarden.jp/en/seq/$spid/$genome_assembly_id/pep/$queryid_pep> ;
    rdfs:seeAlso <https://plantgarden.jp/ja/seq/$spid/$genome_assembly_id/pep/$queryid_pep> ;
    :classifiedWith <https://identifiers.org/kegg.orthology:$koid> .
RDF
#    :classifiedWith obo:GO_0003735;
#    :classifiedWith obo:GO_0006412;
#    :classifiedWith obo:GO_0022625;

  print $ttl,"\n";
  }
  close($fh);
}
