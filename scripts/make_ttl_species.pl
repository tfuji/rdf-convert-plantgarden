#!/usr/local/bin/perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\n";

# 対象  学名  和名  科目  ID  Scientific Name Common Name Family Name ID  PO:food part  EnvO Foodon URL_en  URL_ja  Genome  Assembly  Assembly2 Assembly3
while(<>) {
    #chop();
    #chomp();
    s/[\r\n]+\z//;
    my ($flag, $name_ja, $cname_ja, $family_ja, $spid_ja, $name, $cname, $family, $spid, $po_food_part, $envo, $foodon, $url, $url_ja, $genome, @assembly) = split(/\t/,$_);
    next unless $flag ==1;
    my $taxid = substr($spid,1); 
    $name =~s/\Q*\E//g;
    my $taxon = "http://purl.obolibrary.org/obo/NCBITaxon_". $taxid;

my $ttl =<< "RDF";
<$url>
    rdf:type <http://purl.obolibrary.org/obo/PO_0000003> ;
    rdf:type <$taxon> ;
    dc:identifier "$spid" ;
    rdfs:label "$cname"\@en ;
    rdfs:label "$cname_ja"\@ja ;
    :scientific_name "$name" ;
    :common_name "$cname" ;
    :family_name "$family" ;
    obo:BFO_0000050 <$url#part> ; # part of
    obo:ENVO_01001307 <$envo> ; # partially surrounded by
    rdfs:seeAlso <$url_ja> ;
    :has_genome <$genome> ;
RDF

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
