# rdf-convert-plantgarden


## git clone 
```
git clone git@github.com:tfuji/rdf-convert-plantgarden.git
cd rdf-convert-plantgarden
```

## convert rdf

```
perl scripts/make_ttl_primer.pl Lotus_japonicus.mapped_marker.tsv  > Lotus_japonicus.mapped_marker.ttl
perl scripts/make_ttl_gff3.pl Lj3.0_gene_models2.gff3 > Lj3.0_gene_models2.ttl
perl scripts/make_ttl_hayai.pl t34305.G002_import_gene.tsv > t34305.G002_import_gene.ttl

```

## install virtuoso
* See http://wiki.lifesciencedb.jp/mw/index.php/SPARQLthon19/PubChemLoad

## load virtuoso
```
[木 10 31 16:34] tf@/tga/services/virtuoso7dev/var/lib/virtuoso/db
%pwd
/tga/services/virtuoso7dev/var/lib/virtuoso/db
[木 10 31 16:34] tf@/tga/services/virtuoso7dev/var/lib/virtuoso/db
%/tga/services/virtuoso7dev/bin/virtuoso-t
[木 10 31 16:34] tf@/tga/services/virtuoso7dev/var/lib/virtuoso/db
% /tga/services/virtuoso7dev/bin/isql 1111 dba dba
Connected to OpenLink Virtuoso
Driver: 07.00.3207 OpenLink Virtuoso ODBC Driver
OpenLink Interactive SQL (Virtuoso), version 0.9849b.
Type HELP; for help and EXIT; to exit.

% /tga/services/virtuoso7dev/bin/isql 1111 dba dba
Connected to OpenLink Virtuoso
Driver: 07.00.3207 OpenLink Virtuoso ODBC Driver
OpenLink Interactive SQL (Virtuoso), version 0.9849b.
Type HELP; for help and EXIT; to exit.
SQL> ld_dir('repos/rdf-converter-plantgarden', 'L*.ttl', 'https://plantgarden.jp/');

Done. -- 7 msec.
SQL> rdf_loader_run();

Done. -- 9350 msec.
SQL> checkpoint ;

Done. -- 2160 msec.
SQL> 
```


## access virtuoso
http://localhost:8890

## run sparql
```
PREFIX rdf:<http://www.w3.org/1999/02/22-rdf-syntax-ns#>
PREFIX rdfs:<http://www.w3.org/2000/01/rdf-schema#>
PREFIX obo:<http://purl.obolibrary.org/obo/>
PREFIX insdc:<http://ddbj.nig.ac.jp/ontologies/nucleotide/>
PREFIX faldo:  <http://biohackathon.org/resource/faldo#>
PREFIX : <https://plantgardden.jp/ns/>

select
?feature ?type ?faldo_reference
 IF(?fstart < ?fend , ?fstart, ?fend) as ?start 
 IF(?fstart < ?fend , ?fend, ?fstart) as ?end
 IF( ?faldo_type = faldo:ForwardStrandPosition,"+", IF( ?faldo_type = faldo:ReverseStrandPosition,"-",".")) as ?strand
FROM <https://plantgarden.jp/>
WHERE
{
{ 
  values ?type { obo:SO_0000704}
  values ?faldo_type { faldo:ForwardStrandPosition faldo:ReverseStrandPosition }
  ?feature rdf:type ?type .
  #?type rdfs:label ?feature_type .
  ?feature faldo:location ?faldo .
  ?faldo faldo:begin/rdf:type ?faldo_type .
  ?faldo faldo:begin/faldo:position ?fstart .
  ?faldo faldo:begin/faldo:reference ?faldo_reference .
  ?faldo faldo:end/faldo:position ?fend .
} UNION {
  values ?type {obo:SO_0000207}
  values ?faldo_type { faldo:ForwardStrandPosition faldo:ReverseStrandPosition }
  ?feature rdf:type ?type .
  #?type rdfs:label ?feature_type .
  #OPTIONAL{
  ?feature :has_forword_primer/faldo:location ?faldo .
  ?faldo faldo:begin/rdf:type ?faldo_type .
  ?faldo faldo:begin/faldo:position ?fstart .
  ?faldo faldo:begin/faldo:reference ?faldo_reference .
  ?faldo faldo:end/faldo:position ?fend .
}
}
ORDER BY ?faldo_reference ?start
limit 10000
```


## RDF model ##
### Marker RDFの例 ###

```
@prefix :  <https://plantgardden.jp/ns/> .			
@prefix        rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .			
@prefix        rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .			
@prefix        dc:        <http://purl.org/dc/terms/> .			
@prefix        obo:        <http://purl.obolibrary.org/obo/> .			
@prefix        faldo:        <http://biohackathon.org/resource/faldo#> .			
<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1>	rdf:type	obo:SO_0000207	;
	dc:identifier	"t3747.M000002.1"	;
	:species_id	"t3747"	;
	:has_species	<https://plantgarden.jp/en/list/t3747>	;
	rdfs:label	"FAES0002"	;
	:sub_number	1	;
	:marker_type	"SSR"	;
	:mapped_genome_id	"t3747.G002"	;
	:has_species	<https://plantgarden.jp/en/list/t3747/genome/t3747.G002>	;
	:reference_seq_name	"v1.0.a1"	;
	:chr	"Fvb6-1"	;
	:target_seq	"NA"	;
	:allele	"NA"	;
	:enzyme	"NA"	;
	rdfs:comment	"<i>F. x ananassa</i> EST-SSR"	;
	:doi	"NA"	;
	dc:references	"NA"	;
	:f_active	"1"	;
	:has_forword_primer	<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:forword-primer>	;
	:has_reverse_primer	<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:reverse-primer>	.
<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:forword-primer>	faldo:location	[	
	rdf:type	faldo:Region	;
	rdf:type	obo:SO_0000121	;
	rdfs:label	"t3747.M000001.1:fwd"	;
	:sequence	"GCAACAACAGCTCTCGCATA"	;
	faldo:begin	[	
	faldo:position	22027099	;
	faldo:reference	<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>	;
	rdf:type 	faldo:ExactPosition	;
	rdf:type 	faldo:ForwardStrandPosition	
		]	;
	faldo:end 	[	
	faldo:position	22027118	;
	faldo:reference	<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>	;
	rdf:type 	faldo:ExactPosition	;
	rdf:type 	faldo:ForwardStrandPosition	
		]	
		]	.
<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:reverse-primer>	faldo:location	[	
	rdf:type	faldo:Region	;
	rdf:type	obo:SO_0000132	;
	rdfs:label	"t3747.M000001.1:fwd"	;
	:sequence	"GACTATCTCCGCCATCCAAA"	;
	faldo:begin	[	
	faldo:position	22027216	;
	faldo:reference	<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>	;
	rdf:type 	faldo:ExactPosition	;
	rdf:type 	faldo:ForwardStrandPosition	
		]	;
	faldo:end 	[	
	faldo:position	22027197	;
	faldo:reference	<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>	;
	rdf:type 	faldo:ExactPosition	;
	rdf:type 	faldo:ForwardStrandPosition	
		]	
		]	.
```

### HayaiAnnotation RDFの例 ###

```
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix : <https://plantgardden.jp/ns/> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix obo: <http://purl.obolibrary.org/obo/> .
@prefix faldo: <http://biohackathon.org/resource/faldo#> .
@prefix sio: <http://semanticscience.org/resource/> .

<https://plantgarden.jp/en/list/t34305>
    :family_name "Phrymaceae" ;
    :genome_assembly_id "t34305.G002" ;
    :genus_name "Erythranthe" ;
    :phylum_name "Streptophyta" ;
    :superkingdom_name "Eukaryota" .

<https://plantgarden.jp/en/list/t3747/gene/Lj0g3v0013599.1>
    faldo:location [
        faldo:begin [
            faldo:position "125577831" ;
            faldo:reference <https://plantgarden.jp/en/list/t34305/sequence/Lj3.0_chr0> ;
            a faldo:ExactPosition, faldo:ReverseStrandPosition
        ] ;
        faldo:end [
            faldo:position "125578853" ;
            faldo:reference <https://plantgarden.jp/en/list/t34305/sequence/Lj3.0_chr0> ;
            a faldo:ExactPosition, faldo:ReverseStrandPosition
        ] ;
        a faldo:Region
    ] ;
    a obo:SO_0000704 .

<https://plantgarden.jp/en/seq/t34305/t34305.G002/cds/Lj0g3v0013599.1>
    obo:BFO_0000050 <https://plantgarden.jp/en/list/t34305/gene/Lj0g3v0013599.1> ;
    obo:RO_0002162 <http://identifiers.org/taxonomy/34305> ;
    dc:identifier "Lj0g3v0242029.1" ;
    a obo:SO_0000316 ;
    rdfs:comment "" ;
    :annotation_version "Lj3.0" .

<https://plantgarden.jp/en/seq/t34305/t34305.G002/pep/Lj0g3v0013599.1>
    obo:RO_0001000 <https://plantgarden.jp/en/seq/t34305/t34305.G002/cds/Lj0g3v0013599.1> ;
    dc:indentifier "Lj0g3v0242029.1" ;
    sio:SIO_000558 <http://purl.uniprot.org/uniprot/A0A022RW76> ;
    a obo:SO_0000104 ;
    :classifiedWith obo:GO_0003735, obo:GO_0006412, obo:GO_0022625, <https://identifiers.org/kegg.orthology:K02885> .
```

### GFF3 ###

```
@prefix : <https://plantgardden.jp/ns/> .
@prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .
@prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#> .
@prefix dc: <http://purl.org/dc/terms/> .
@prefix obo: <http://purl.obolibrary.org/obo/> .
@prefix faldo: <http://biohackathon.org/resource/faldo#> .

<https://plantgarden.jp/en/seq/t34305/all/Ljchlorog3v0000020> rdf:type  obo:SO_0000704 ; # Gene
  dc:identifier "Ljchlorog3v0000020" ;
  rdfs:label  "Ljchlorog3v0000020" ;
  faldo:location  [
    rdf:type  faldo:Region ;
    faldo:begin [
      faldo:position  519 ;
      faldo:reference <https://plantgarden.jp/en/list/t34305/sequence/Lj3.0_chrC> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition 
      ] ;
    faldo:end   [
      faldo:position  1371 ;
      faldo:reference <https://plantgarden.jp/en/list/t34305/sequence/> ;
      rdf:type  faldo:ExactPosition ;
      rdf:type  faldo:ForwardStrandPosition
      ]
    ] .
```

## TODO  ##
* 植物ゲノムのgene/mRNA/CDS/exon/intron構造アノテーションが揺れているのでとりあえずgeneのみ対応

### gff3-to-ttl ###
```
%perl scripts/make_ttl_gff3.pl FANhybrid_r1.2.genes.gff3
$VAR1 = {
          'intron' => 110204,
          'CDS' => 143958,
          'gene' => 45377,
          'exon' => 148259
        };
```        

```
%perl scripts/make_ttl_gff3.pl Glycine_max.Glycine_max_v2.1.42.chr.gff3
$VAR1 = {
          'mRNA' => 87977,
          'CDS' => 522339,
          'pre_miRNA' => 78,
          'RNase_MRP_RNA' => 2,
          'ncRNA_gene' => 1237,
          'five_prime_UTR' => 62642,
          'three_prime_UTR' => 63724,
          'snRNA' => 147,
          '' => 56872,
          'tRNA' => 427,
          'rRNA' => 361,
          'SRP_RNA' => 20,
          'exon' => 523576,
          'biological_region' => 2169,
          'lnc_RNA' => 8,
          'snoRNA' => 192,
          'ncRNA' => 2,
          'chromosome' => 20,
          'gene' => 55589
        };
```

```
%perl scripts/make_ttl_gff3.pl glyma.Lee.gnm1.ann1.6NZV.gene_models_main.gff3
$VAR1 = {
          'three_prime_UTR' => 76908,
          'CDS' => 437712,
          'five_prime_UTR' => 89458,
          'gene' => 47649,
          'mRNA' => 71358,
          '' => 3
        };
```

```
%perl scripts/make_ttl_gff3.pl GWHAAEV00000000.gff 
$VAR1 = {
          'mRNA' => 58017,
          'CDS' => 333842,
          'rRNA_primary_transcript' => 8,
          '' => 489,
          'gene' => 52178,
          'three_prime_UTR' => 32903,
          'five_prime_UTR' => 34834,
          'tRNA_primary_transcript' => 29,
          'exon' => 345307
        };
     
```

```
%perl scripts/make_ttl_gff3.pl Brapa_genome_v3.0_genes.gff3   
$VAR1 = {
          'gene' => 46250,
          'mRNA' => 46250,
          'CDS' => 221750
        };
```
