# rdf-convert-plantgarden

## convert rdf

```
perl scripts/make_ttl_primer.pl Lotus_japonicus.mapped_marker.tsv  > Lotus_japonicus.mapped_marker.ttl
perl scripts/make_ttl_gff3.pl Lj3.0_gene_models2.gff3 > Lj3.0_gene_models2.ttl
```

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

## sparql


## gff3-to-ttl
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
