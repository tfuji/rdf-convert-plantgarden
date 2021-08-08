#!/usr/local/env perl

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

#my $cnt = 0;
  my $to = {
   '1' => "obo:TO_0000164", #'stress trait'=> "obo:TO_0000164", 
   '2' => 'obo:TO_0000392', #'sterility or fertility trait' => 'obo:TO_0000392', 
   '3' => 'obo:TO_0000371', #'yield trait' => 'obo:TO_0000371', 
   '4' => 'obo:TO_0000017', #'anatomy and morphology trait' => 'obo:TO_0000017', 
   '5' => 'obo:TO_0000597', #'quality trait' => 'obo:TO_0000597', 
   '6' => 'obo:TO_0000183'  #'other miscellaneous trait' => 'obo:TO_0000183' 
  };

while(<>) {
    chop;
    @a = split(/\t/);
   #next if $cnt++ == 0;

    my (
     #t34305.T000001  t34305  NW      1       6
     #t3818.T000001   t3818   cp1     1       1
     ## $locus_id, $species_id, $locus_name, $genome_assembly_id, $reference_doi,
     $locus_id, $species_id, $locus_name, $xxx, $category_id, 
     #nodule weight/plant     t34305.G002     QTL analysis    Miyakojima MG-20 x Gifu B-129   RIL
     #cp, resistance to C. personatum (late leaf spot disease resistance)     NA      QTL analysis    A. duranensis (K7988) x A. stenosperma (V10309) F2
     #$category_id, $trait_detail, $method, $population_name, $population_type,
     $trait_detail, $genome_assembly_id, $method, $population_name, $population_type,
     #Lj3.0   t34305.M000690.1        TM0832  Lj3.0_chr0      140451547       140451676
     #Tifrunner.gnm1.KYV3     t3818.M014442.1 RN5H02  arahy.Tifrunner.gnm1.Arahy.04   102722262       102722462
     #$marker_gene_id_1, $marker_gene_name_1, $taeget_name, $chr_1, $target_1_start_pos, $target_1_end_pos,
     $target_name, $marker_gene_id_1, $marker_gene_name_1, $chr_1, $target_1_start_pos, $target_1_end_pos,
     #t34305.M000222.1        TM0063  Lj3.0_chr1      17766925        17767088 
     #NA      cnu_mBRPGM0085  NA      NA      NA
     $marker_gene_id_2, $marker_gene_name_2, $chr_2, $target_2_start_pos, $target_2_end_pos,
     #Miyakojima_MG-20_x_Gifu_B-129 chr0      9.6     3.95    NA      10.1007/s10265-011-0459-1       analysis of symbiotic nitrogen fixation activity.
     #835 x B2 LG_02          3.72            10.1007/s00122-013-2154-1       835:Susceptible; B2:Strong resistant    835:Susceptible; B2:Strong resistant
     #$target_position_on_linkage_map, $lod, $p_value
     $target_position_on_linkage_map, $lod, $p_value, $reference_doi, $yyy
    ) = split(/\t/);

#$DOI
$trait = $trait_detail; # ARA/P (acetylene reduction activity per plant)
$analysisMethod = $method; #QTL analysis
$populationName = $population_name ; #LjMG RIL population (Miyakojima MG- 20 x Gifu B-129)
$populationType = $population_type ; #RIL
$populationType =~s/ /\_/g;

$nearestMarker1 = $marker_gene_name_1; #TM0550
#$referenceGenome = $a[8]; #Lj3.0
#$chromosome = $a[9]; # Lj3.0_chr2
#$startPosition = $a[10]; # 29521387
#$endPosition = $a[11]; # 29521546

$nearestMarker2 = $marker_gene_name_2; # TM0324
#$chromosome2 = $a[13]; # Lj3.0_chr2
#$startPosition2 = $a[14]; # 42708540
#$endPosition2 = $a[15]; # 42708734

$positionOnTheLinkageMap = $target_position_on_linkage_map; # 68.3
$maxLOD = $lod ; # 5.56
$pValue = $p_value ; # NA
$doi = $reference_doi ; # 10.110.1007/s10265-011-0459-1111/tpj.12220
$nearestMarker1ID = $marker_gene_id_1; # t34305.M000576.1
$nearestMarker2ID = $marker_gene_id_2; # t34305.M000451.1
#$species = "<https://plantgarden.jp/en/list/t3747/genome/t3747.G002>";


my $subject = "http://plantgarden.jp/resource/$locus_id";

my $ttl =<< "RDF";
# QTL 
<$subject>  rdf:type  obo:SO_0000771  ; #QTL  
  rdf:type :TraitRealted ;
  dc:identifier  "$locus_id"  ; 
  rdfs:seeAlso <https://plantgarden.jp/en/search/trait/$species_id/$locus_id> ;
  rdfs:seeAlso <https://plantgarden.jp/ja/search/trait/$species_id/$locus_id> ;
  rdfs:label  "$locus_name"  ; 
  :species_id "$species_id"  ; 
  :species <http://plantgarden.jp/resource/$species_id> ;
  :genome <http://plantgarden.jp/resource/$genome_assembly_id> ;
  :trait  "$trait"  ; 
  :has_trait  $to->{$category_id} ; # QTL->Trait
  dc:references <http://doi.org/$doi> ; 
  :analysis_method  "$analysisMethod"  ; 
  :max_lod  $maxLOD  ; 
  :p_value  "$pValue" . 
 
# PhysicalMap location
<$subject>  faldo:location  [ 
    rdf:type  faldo:Region ; 
    :nearest_marker1  <https://plantgarden.jp/en/list/$species_id/marker/$nearestMarker1ID> ; 
    :nearest_marker2  <https://plantgarden.jp/en/list/$species_id/marker/$nearestMarker2ID> ; 
  ] .

# LinkageMap
<$subject> :has_mapfeature [ 
    rdf:type :Mapfeature  ;
    rdf:type faldo:Position  ;
    faldo:position "$positionOnTheLinkageMap"  ; #genetic_locus
    faldo:reference  <http://plantgarden.jp/resource/linkage-map#$species_id> ;
  ] .

# Study
<$subject#study> rdf:type :Study ;
  :has_population <$subject#population> ;
  :has_observation <$subject> .

# Population
<$subject#population> rdf:type  sio:SIO_001061  ; #Population 
  rdf:type  :$populationType ;    #Population Type  
  rdfs:label  "$populationName" . #Population Name  
        
# Trait Annotation
<$subject>  sio:has_annotation  <$subject#manual> .
<$subject#manual> 
  rdf:type  :TraitAnnotation  ; 
  :assertion  obo:ECO_0000218 ; 
  prov:wasGeneratedBy <https://plantgarden.jp/resource/curation_activity>  ; 
  :target <$subject>  ; 
  :body "$trait"  ; 
  prov:hadPrimarySource <http://doi.org/$doi> ; 
  :semanticTags  $to->{$category_id} ;
  :category_id $category_id . 

RDF

#my $subject = "https://plantgarden.jp/en/search/trait/$species_id/$locus_id";        
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
