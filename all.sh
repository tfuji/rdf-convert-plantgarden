# PGARDEN_IN=/home/metabobank/private/PlantGarden/data
# PGARDEN_RDF=. 
echo "convert species..."
perl scripts/tsv2ttl_species.pl $PGARDEN_IN/mysql/import_species/import_species_20210525.tsv > $PGARDEN_RDF/rdf/pg_species.ttl
echo "convert subspecies..."
perl scripts/tsv2ttl_subspecies.pl $PGARDEN_IN/mysql/import_species/import_sub_species_20210525.tsv > $PGARDEN_RDF/rdf/pg_subspecies.ttl 
echo "convert genome..."
perl scripts/tsv2ttl_genomes.pl $PGARDEN_IN/mysql/import_genome/import_genome_20210525.tsv > $PGARDEN_RDF/rdf/pg_genome.ttl
echo "convert gene..."
perl scripts/tsv2ttl_gene.pl   /home/metabobank/private/PlantGarden/data/mysql/import_gene/import_data/*_gene.import.tsv > $PGARDEN_RDF/rdf/pg_gene.ttl
echo "convert marker..."
perl scripts/tsv2ttl_marker.pl /home/metabobank/private/PlantGarden/data/mysql/import_marker/*.import_marker.tsv > $PGARDEN_RDF/rdf/pg_marker.ttl
echo "convert trait..."
perl scripts/tsv2ttl_trait.pl /home/metabobank/private/PlantGarden/data/mysql/import_trait/import_trait_related_*.txt > $PGARDEN_RDF/rdf/pg_trait.ttl
