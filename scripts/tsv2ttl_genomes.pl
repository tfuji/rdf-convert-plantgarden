#!/usr/bin/env perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\n";

# Field   Type    Null    Key     Default Extra
# genome_assembly_id      varchar(32)     NO      PRI     NULL    
# species_id      varchar(32)     NO      MUL     NULL    
# pgid    varchar(32)     NO      MUL     NULL    
# biological_sample_name  varchar(128)    YES             NULL    
# assembly_version        varchar(128)    YES             NULL    
# chromosome_count        varchar(32)     YES             NULL    
# assembly_level  varchar(32)     YES             NULL    
# assembly_count  int(10) unsigned        YES             NULL    
# assembly_size   int(10) unsigned        YES             NULL    
# estimated_genome_size   int(10) unsigned        YES             NULL    
# scaffold_N50    int(10) unsigned        YES             NULL    
# sequencing_depth        varchar(32)     YES             NULL    
# sequencing_method       varchar(128)    YES             NULL    
# sequencing_method_comments      text    YES             NULL    
# assembly_method varchar(256)    YES             NULL    
# other_comments  text    YES             NULL    
# submitter       varchar(256)    YES             NULL    
# reference_doi   varchar(128)    YES             NULL    
# data_source_name        varchar(256)    YES             NULL    
# data_source_url varchar(256)    YES             NULL    
# f_active        tinyint(1)      NO              0       

# t271171.G001	t271171	t271171.S001	cv. HPK4 	MUN_r1.11	2n=20	Pseudomolecule	3288	296778765	343.6	28154654	NA	llumina		SOAPdenovo2,  SSPACE2.0, Platanus, MaSuRCA, GM closer		Sachiko Isobe (Kazusa DNA Research Institute)	10.1101/2021.01.18.427074 	Horse gram DataBase	http://horsegram.kazusa.or.jp/	1 
#
# 対象  学名  和名  科目  ID  Scientific Name Common Name Family Name ID  PO:food part  EnvO Foodon URL_en  URL_ja  Genome  Assembly  Assembly2 Assembly3

while(<>) {
    chomp();
    print "#", $_,"\n";
    #my ($genome_assembly_id, $species_id, $pgid, $biological_sample_name, $assembly_version, $chromosome_count, $assembly_level, $assembly_count, $assembly_size, $estimated_genome_size, $scaffold_N50, $sequencing_depth, $sequencing_method, $sequencing_method_comments, $assembly_method, $sequencing_method_comments, $other_comments, $submitter, $reference_doi, $data_source_name, $data_source_url, $f_active) = split(/\t/,$_);
    ### 一致していないので、other_commentsを仮に除く
    my ($genome_assembly_id, $species_id, $pgid, $biological_sample_name, $assembly_version, $chromosome_count, $assembly_level, $assembly_count, $assembly_size, $estimated_genome_size, $scaffold_N50, $sequencing_depth, $sequencing_method, $sequencing_method_comments, $assembly_method, $sequencing_method_comments, $submitter, $reference_doi, $data_source_name, $data_source_url, $f_active) = split(/\t/,$_);

    #next unless $flag ==1;
    #my $taxid = substr($spid,1); 
    $name =~s/\Q*\E//g;
    my $subject_url = "https://plantgarden.jp/resource/genome/$genome_assembly_id";
    my $genome_url_en  = "https://plantgarden.jp/en/list/$species_id/genome/$genome_assembly_id";
    my $genome_url_ja  = "https://plantgarden.jp/ja/list/$species_id/genome/$genome_assembly_id";
   
    my $url    = "https://plantgarden.jp/en/list/$species_id/genome/$genome_assembly_id" ;
    my $url_ja = "https://plantgarden.jp/ja/list/$species_id/genome/$genome_assembly_id" ;
    my $taxon = "http://purl.obolibrary.org/obo/NCBITaxon_". $tax_id;
    my $spid = $species_id;
    my $cname = $common_name;
    my $cname_ja = $common_name_J;
    my $foodon ="";
    my $po_food_part =""; #TODO
    my $envo = "#envO";   #TODO
    my $genome = "#genome"; #TODO
    my @assembly = (); #TODO

my $ttl =<< "RDF";
<http://plantgarden.jp/resource/$genome_assembly_id>
    rdf:type :Genome ;
    dc:identifier "$genome_assembly_id" ;
    rdfs:label "$assembly_version" ;
    rdfs:seeAlso <$url> ;
    rdfs:seeAlso <$url_ja> ;
    :genome_assembly_id "$genome_assembly_id" ;
    :species <http://plantgarden.jp/resource/$species_id> ; #genome-species
    :subspecies <http://plantgarden.jp/resource/$pgid> ;    #genome-subspecies
    :species_id "$species_id" ; 
    :pgid "$pgid" ;
    :biological_sample_name "$biological_sample_name" ;
    :assembly_version "$assembly_version" ; 
    :chromosome_count "$chromosome_count" ; 
    :assembly_level "$assembly_level" ; 
    :assembly_count "$assembly_count" ;
    :assembly_size "$assembly_size" ; 
    :estimated_genome_size "$estimated_genome_size" ; 
    :scaffold_N50 "$scaffold_N50" ; 
    :sequencing_depth "$sequencing_depth" ;
    :sequencing_method "$sequencing_method" ; 
    :sequencing_method_comments "$sequencing_method_comments" ;  
    :assembly_method "$assembly_method" ;
    :other_comments "$other_comments" ;
    :submitter "$submitter" ; 
    :reference_doi "$reference_doi" ;
    :data_source_name "$data_source_name" ;
    :data_source_url "$data_source_url" ;
    :f_active "$f_active" .
RDF

print $ttl,"\n";
next;

foreach my $asm (@assembly){
    next if $asm =~//;
    $ttl .= "    :genome_assembly <$asm> ;\n";
}

$ttl  .= "    rdfs:seeAlso <$url_ja> .\n\n";

if($po_food_part ne '-'){
$ttl  .=<< "RDF";
<$url#food_source>
    obo:BFO_0000050 <$url> ; # part of
    rdf:type <$po_food_part> ;
    obo:RO_0001000 <$foodon> . # derives from" 
RDF
}


#    :genome_assembly_id "$genome_assembly_id" ;
#    :genus_name "$genus_name" ;
#    :phylum_name "$phylum_name" ;
#    :superkingdom_name "$superkingdom_name" .


print $ttl,"\n";
}
