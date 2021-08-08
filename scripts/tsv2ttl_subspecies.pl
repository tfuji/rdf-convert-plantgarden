#!/usr/bin/env perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\n";


# CREATE TABLE `sub_species` (
#  `pgid` varchar(32) NOT NULL,
#  `species_name` varchar(128) NOT NULL,
#  `sub_rank` varchar(20),
#  `sub_name` varchar(32),
#  `english_name` varchar(128),
#  `japanese_name` varchar(128),
#  `species_id` varchar(32) NOT NULL,
#  PRIMARY KEY (`pgid`),
#  KEY `species_id` (`species_id`)
#) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='sub_species table';
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
    #my ($species_id, $tax_id, $scientific_name, $family, $family_J, $genus, $genus_J, $common_name, $common_name_J) = split(/\t/,$_);
    my ($pgid, $species_name, $sub_rank, $sub_name, $english_name, $japanese_name, $species_id) = split(/\t/,$_);
    #next unless $flag ==1;
    #my $taxid = substr($spid,1); 
    $name =~s/\Q*\E//g;
    #my $taxon = "http://purl.obolibrary.org/obo/NCBITaxon_". $tax_id;

my $ttl =<< "RDF";
<http://plantgarden.jp/resource/$pgid>
    rdf:type :Subspecies ;
    dc:identifier "$pgid" ;
    rdfs:label "$english_name"\@en ;
    rdfs:label "$japanese_name"\@ja ;
    rdfs:seeAlso <https://plantgarden.jp/en/list/$species_id> ;
    rdfs:seeAlso <https://plantgarden.jp/ja/list/$species_id> ;
    :species_name "$species_name" ;
    :sub_rank "$sub_rank" ;
    :sub_name "$sub_name" ;
    :species <http://plantgarden.jp/resource/$species_id> ;
    :species_id "$species_id" . 
RDF

print $ttl,"\n";
}

