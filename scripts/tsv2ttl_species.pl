#!/usr/bin/env perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\n";

# CREATE TABLE `species` (
#  `species_id` varchar(32) NOT NULL,
#  `tax_id` varchar(32) NOT NULL,
#  `scientific_name` varchar(128),
#  `family`  varchar(128),
#  `family_J` varchar(128),
#  `genus`  varchar(128),
#  `genus_J` varchar(128),
#  `common_name` varchar(256),
#  `common_name_J` varchar(256),
#  PRIMARY KEY (`species_id`)
#) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='species table';
# /home/metabobank/private/PlantGarden/data/mysql/sql/import_table_species.sql 
#
# /home/metabobank/private/PlantGarden/data/mysql/import_species/mysql_import_ichihara20210525.sh
# /home/metabobank/private/PlantGarden/data/mysql/import_species/import_sub_species_20210525.tsv
# t271171.S001    Macrotyloma uniflorum                   Horsegram, Madras bean  ホースグラム    t271171
# /home/metabobank/private/PlantGarden/data/mysql/import_species/import_species_20210525.tsv
# t271171 271171  Macrotyloma uniflorum   Fabaceae        マメ科  Macrotyloma     Macrotyloma属   Horsegram, Madras bean  ホースグラム

# 対象  学名  和名  科目  ID  Scientific Name Common Name Family Name ID  PO:food part  EnvO Foodon URL_en  URL_ja  Genome  Assembly  Assembly2 Assembly3

while(<>) {
    #chop();
    chomp();
    print "### ", $_,"\n";
    #s/[\r\n]+\z//;
    #my ($flag, $name_ja, $cname_ja, $family_ja, $spid_ja, $name, $cname, $family, $spid, $po_food_part, $envo, $foodon, $url, $url_ja, $genome, @assembly) = split(/\t/,$_);
    my ($species_id, $tax_id, $scientific_name, $family, $family_J, $genus, $genus_J, $common_name, $common_name_J) = split(/\t/,$_);
    #next unless $flag ==1;
    #my $taxid = substr($spid,1); 
    $name =~s/\Q*\E//g;
    my $url   = "https://plantgarden.jp/en/list/". $species_id ;
    my $url_ja   = "https://plantgarden.jp/ja/list/". $species_id ;
    my $taxon = "http://purl.obolibrary.org/obo/NCBITaxon_". $tax_id;
    my $spid = $species_id;
    #my $cname = $common_name;
    #my $cname_ja = $common_name_J;
    my $foodon ="";
    my $po_food_part =""; #TODO
    my $envo = "#envO";   #TODO
    my $genome = "#genome"; #TODO
    my @assembly = (); #TODO

my $ttl =<< "RDF";
<http://plantgarden.jp/resource/$species_id>
    rdf:type <http://purl.obolibrary.org/obo/PO_0000003> ;
    rdf:type <$taxon> ;
    rdf:type :Species ;
    dc:identifier "$spid" ;
    rdfs:label "$scientific_name" ;
    rdfs:seeAlso <$url> ;
    rdfs:seeAlso <$url_ja> ;
    :scientific_name "$scientific_name" ;
    :family_name "$family"\@en ;
    :family_name "$family_J"\@ja ;
    :genus_name "$genus"\@en ;
    :genus_name "$genus_J"\@ja ;
    :common_name "$common_name"\@en ;
    :common_name "$common_name_J"\@ja .
RDF
    #obo:BFO_0000050 <$url#part> ; # part of
    #obo:ENVO_01001307 <$envo> ; # partially surrounded by
    #:has_genome <$genome> .

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
