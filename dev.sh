PGARDEN_IN=/home/metabobank/private/PlantGarden/data
PGARDEN_RDF=. 

#echo "convert species..."
#perl scripts/tsv2ttl_species.pl $PGARDEN_IN/mysql/import_species/import_species_20210525.tsv > $PGARDEN_RDF/rdf/pg_species.ttl
#echo "convert subspecies..."
#perl scripts/tsv2ttl_subspecies.pl $PGARDEN_IN/mysql/import_species/import_sub_species_20210525.tsv > $PGARDEN_RDF/rdf/pg_subspecies.ttl 
#echo "convert genome..."
#perl scripts/tsv2ttl_genomes.pl $PGARDEN_IN/mysql/import_genome/import_genome_20210525.tsv > $PGARDEN_RDF/rdf/pg_genome.ttl

echo "convert gene..."
#perl scripts/tsv2ttl_gene.pl $PGARDEN_IN/mysql/import_gene/import_data/Fragaria_x_ananassa_t3747.G001_gene.import.tsv > $PGARDEN_RDF/rdf/pg_gene_dev.ttl
perl scripts/tsv2ttl_gene.pl $PGARDEN_IN/mysql/import_gene/import_data/Lotus_japonicus_t34305.G001_gene.import.tsv > $PGARDEN_RDF/rdf/pg_gene_dev.ttl
#[tf@at043 rdf-convert-plantgarden]$ ls -l $PGARDEN_IN/mysql/import_gene/import_data |grep Lotus
#-rw-r--r-- 1 metabobank metabobank  10049769  5月 27 19:06 Lotus_japonicus_t34305.G001_gene.import.tsv
#-rw-r--r-- 1 metabobank metabobank   3010177  5月 27 18:44 Lotus_japonicus_t34305.G001_gene_ontology.import.tsv
#-rw-r--r-- 1 metabobank metabobank   3659313  5月 27 19:03 Lotus_japonicus_t34305.G001_goslim.import.tsv
#-rw-r--r-- 1 metabobank metabobank   3618700  5月 27 18:59 Lotus_japonicus_t34305.G001_interpro.import.tsv
#-rw-r--r-- 1 metabobank metabobank   1967115  5月 27 18:44 Lotus_japonicus_t34305.G001_pfam.import.tsv

#echo "convert marker..."
#perl scripts/tsv2ttl_marker.pl $PGARDEN_IN/mysql/import_marker/Fragaria_x_ananassa.import_marker.tsv > $PGARDEN_RDF/rdf/pg_marker_dev.ttl
#echo "convert trait..."
#perl scripts/tsv2ttl_trait.pl $PGARDEN_IN/mysql/import_trait/import_trait_related_miyakogusa_20200930.txt > $PGARDEN_RDF/rdf/pg_trait_dev.ttl
