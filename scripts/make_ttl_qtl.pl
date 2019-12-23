#!/usr/local/env :wqperl

print << 'RDF';
@prefix :  <https://plantgardden.jp/ns/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix obo: <http://purl.obolibrary.org/obo/> .
@prefix faldo: <http://biohackathon.org/resource/faldo#> .
@prefix sio: <http://semanticscience.org/resource/> .
@prefix prov: <http://www.w3.org/ns/prov#> .

RDF

#------------------------------

#my $cnt = 0;

while(<>) {
    chop;
    @a = split(/\t/);
#    next if $cnt++ == 0;

# t34305.T000001  NA  6 ARA/P (acetylene reduction activity per plant)  QTL analysis  LjMG RIL population (Miyakojima MG- 20 x Gifu B-129)
#  RIL TM0550  Lj3.0 Lj3.0_chr2  29521387  29521546  TM0324  Lj3.0_chr2  42708540  42708734  68.3  5.56  NA  10.110.1007/s10265-011-0459-1111/tpj.12220  t34305.M000576.1  t34305.M000451.1
#
$locusID = $a[0]; # t34305.T000001
$locusName = $a[1]; # NA


#$DOI
$category = $a[2]; #6
$trait = $a[3]; # ARA/P (acetylene reduction activity per plant)
$analysisMethod = $a[4]; #QTL analysis
$populationName = $a[5]; #LjMG RIL population (Miyakojima MG- 20 x Gifu B-129)
$populationType = $a[6]; #RIL
$populationType =~s/ /\_/g;

$nearestMarker1 = $a[7]; #TM0550
$referenceGenome = $a[8]; #Lj3.0
$chromosome = $a[9]; # Lj3.0_chr2
$startPosition = $a[10]; # 29521387
$endPosition = $a[11]; # 29521546

$nearestMarker2 = $a[12]; # TM0324
$chromosome2 = $a[13]; # Lj3.0_chr2
$startPosition2 = $a[14]; # 42708540
$endPosition2 = $a[15]; # 42708734
$positionOnTheLinkageMap = $a[16]; # 68.3
$maxLOD = $a[17]; # 5.56
$pValue = $a[18]; # NA
$doi = $a[19]; # 10.110.1007/s10265-011-0459-1111/tpj.12220
$nearestMarker1ID = $a[20]; # t34305.M000576.1
$nearestMarker2ID = $a[21]; # t34305.M000451.1
#$species = "<https://plantgarden.jp/en/list/t3747/genome/t3747.G002>";


#------------------------------
  
  #my ($spcode, $mid) = each(split("\.",$locusID));
  my @b = split(/\./,$locusID);
  my $spid = @b[0];
  #print $spid,"\n";

my $subject = "https://plantgarden.jp/en/search/trait/$spid/$locusID";

my $ttl =<< "RDF";
<https://plantgarden.jp/en/search/trait/$spid/$locusID>  rdf:type  obo:SO_0000771  ; #QTL  
  dc:identifier  "$locusID"  ; 
  rdfs:label  "$locusName"  ; 
  :species_id "$spid"  ; 
  dc:references <http://doi.org/$doi> ; 
  :trait  "$trait"  ; 
  :analysis_method  "$analysisMethod"  ; 
  :max_lod  $maxLOD  ; 
  :p_value  "$pValue"  . 
 
# Physical Map Location TODO:更新 Genome/Sequence
<$subject>  faldo:location  [ 
    rdf:type  faldo:Region ; 
    :nearest_marker1  <https://plantgarden.jp/en/list/$spid/marker/$nearestMarker1ID> ; 
    :nearest_marker2  <https://plantgarden.jp/en/list/$spid/marker/$nearestMarker2ID> ; 
    :genome_assembly_id "t34305.G002" ;
  ] .

# Linkage Map Location
<$subject> faldo:location [ 
    rdf:type faldo:Position  ;
    faldo:position $positionOnTheLinkageMap  ; #genetic_locus
    faldo:reference  <https://plantgarden.jp/en/search/trait/$spid#linkage-map> ;
  ] .

# Analysis/Population/LinkageMap

# Population
<$subject>  :population <$subject#population> . 
<$subject#population> rdf:type  sio:SIO_001061  ; #Population 
  rdf:type  :$populationType ;   #Population Type  
  rdfs:label  "$populationName" . #Population Name  
        

# Trait Annotation
<$subject>  sio:has_annotation  <$subject#manual> ;
  rdf:type  :TraitAnnotation  ; 
  :assertion  obo:ECO_0000218 ; 
  prov:wasGeneratedBy <https://plantgarden.jp#curation_activity>  ; 
  :target <$subject>  ; 
  :body "$trait"  ; 
  prov:hadPrimarySource <http://doi.org/$doi> ; 
  :semanticTags obo:TO_0000183  ; 
  :category $category . 

RDF

#my $subject = "https://plantgarden.jp/en/search/trait/$spid/$locusID";        
#<$subject>  sio:has_annotation  [   
#  rdf:type  :TraitAnnotation  ; 
#  :assertion  ECO:0000203 ; #automatic assertion  
#  prov:wasAttributeTo <https://www.ebi.ac.uk/spot/zooma>  ; 
#  :semanticTags obo:TO_0000449  ; 
#  prov:wasDerivedFrom <$subject#manual> ; #generator  
#  :confidence "HIGH"  ; 
# :evidence "COMPUTED_FROM_TEXT_MATCH"  ; 
#  :accuracy null  ; 
#  :generatedDate  1452693184607 ; 
#  :annotationDate 1452693184607 . 

print $ttl,"\n";

}
