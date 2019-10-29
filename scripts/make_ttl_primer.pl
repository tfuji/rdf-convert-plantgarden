#!/usr/local/bin/perl

print "\@prefix :  <https://plantgardden.jp/ns/> .\n";
print "\@prefix        rdf:        <http://www.w3.org/1999/02/22-rdf-syntax-ns#> .\n";
print "\@prefix        rdfs:        <http://www.w3.org/2000/01/rdf-schema#> .\n";
print "\@prefix        dc:        <http://purl.org/dc/terms/> .\n";
print "\@prefix        obo:        <http://purl.obolibrary.org/obo/> .\n";
print "\@prefix        faldo:        <http://biohackathon.org/resource/faldo#> .\n";

#------------------------------

$cnt = 0;
$sp = "<i>Fragaria</i> x <i>ananassa</i>";

while(<>) {
    chop;
    @a = split(/\t/);
    if ($cnt >= 1) {
	$markerid = $a[0];
	$speciesid = $a[1];
	$markername = $a[2];
	$subnum = $a[3];
	$markertype = $a[4];
	$mappedgenomeid = $a[5];
	$species = "<https://plantgarden.jp/en/list/t3747/genome/t3747.G002>";
	$refseqname = $a[6];
	$chr = $a[7];
	$fwprimer = $a[8];
	$fwprimerstart = $a[9];
	$fwprimerend = $a[10];
	$rvprimer = $a[11];
	$rvprimerstart = $a[12];
	$rvprimerend = $a[13];
	$targetseq = $a[14];
	$allele = $a[15];
	$enzyme = $a[16];
	$comment = $a[17];
	$doi = $a[18];
	$pmd = $a[19];
	$act = $a[20];
#print "<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1>\t";
	print "<https://plantgarden.jp/en/list/t3747/marker\/$markerid\>\t";
	print "rdf:type\t"; # R rdf:type C -> R is an instance of C.
# SO_0000207: Definition: SSLP are a kind of sequence alteration where the number of repeated sequences in intergenic regions may differ. [database_cross_reference: SO:ke]
	print "obo:SO_0000207\t"; # http://purl.obolibrary.org/obo/SO_0000207 -> obo:SO_0000207
	print "\;\n";
	
	print "\t";
	print "dc:identifier\t";
	print "\"$markerid\"\t";
	print "\;\n";

	print "\t";
	print ":species_id\t";
	print "\"$speciesid\"\t";
	print "\;\n";

	print "\t";
	print ":has_species\t";
	print "<https://plantgarden.jp/en/list/$speciesid>\t";
	print "\;\n";

#  rdfs:label  "FAES0002"
	print "\t";
	print "rdfs:label\t";
	print "\"$markername\"\t";
	print "\;\n";

#  :sub_number
	print "\t";
	print ":sub_number\t";
	print "$subnum\t";
	print "\;\n";	

#  :marker_type  "SSR"
	print "\t";
	print ":marker_type\t";
	print "\"$markertype\"\t";
	print "\;\n";	

#  :mapped_genome_id   "t3747.G002"
	print "\t";
	print ":mapped_genome_id\t";
	print "\"$mappedgenomeid\"\t";
	print "\;\n";	

#  :has_species   <https://plantgarden.jp/en/list/t3747/genome/t3747.G002>
	print "\t";
	print ":marker_type\t";
	print "$species\t";
	print "\;\n";	

#  :reference_seq_name   "v1.0.a1"
	print "\t";
	print ":reference_seq_name\t";
	print "\"$refseqname\"\t";
	print "\;\n";	

#  :chr   "Fvb6-1"
	print "\t";
	print ":chr\t";
	print "\"$chr\"\t";
	print "\;\n";		

# fwd_primer_seq  
	print "\t";
	print ":fwd_primer_seq\t";
	print "\"$fwprimer\"\t";
	print "\;\n";		

# fwd_primer_start_pos
	print "\t";
	print ":fwd_primer_start_pos\t";
	print "$fwprimerstart\t";
	print "\;\n";		

# fwd_primer_end_pos
	print "\t";
	print ":fwd_primer_end_pos\t";
	print "$fwprimerend\t";
	print "\;\n";		

# rv_primer_seq  
	print "\t";
	print ":rv_primer_seq\t";
	print "\"$rvprimer\"\t";
	print "\;\n";		

# rv_primer_start_pos
	print "\t";
	print ":rv_primer_start_pos\t";
	print "$rvprimerstart\t";
	print "\;\n";		

# rv_primer_end_pos
	print "\t";
	print ":rv_primer_end_pos\t";
	print "$rvprimerend\t";
	print "\;\n";		

# :target_seq   "NA"
	print "\t";
	print ":target_seq\t";
	print "\"$targetseq\"\t";
	print "\;\n";		

# :allele   "NA"
	print "\t";
	print ":allele\t";
	print "\"$allele\"\t";
	print "\;\n";		

# :allele   "NA"
	print "\t";
	print ":enzyme\t";
	print "\"$enzyme\"\t";
	print "\;\n";		

# rdfs:comment  "<i>F. x ananassa</i> EST-SSR" 
	print "\t";
	print "rdfs:comment\t";
	print "\"$sp $comment\"\t";
	print "\;\n";		

# :doi   "NA"
	print "\t";
	print ":doi\t";
	print "\"$doi\"\t";
	print "\;\n";		

# :pubmed   "NA"
	print "\t";
	print "dc:references\t";
	print "$pmd\t";
	print "\;\n";		

# :f_active   "1"
	print "\t";
	print ":f_active\t";
	print "$act\t";
	print "\;\n";		

##### primer information #####

# :has_forword_primer  <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099-22027118:primer>
	print "\t";
	print ":has_forword_primer\t";
#	print "<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099-22027118:primer>\t";
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$fwprimerstart-$fwprimerend:primer>\t";
	print "\;\n";		

# :has_reverse_primer<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027216-22027197:primer>
	print "\t";
	print ":has_reverse_primer\t";
#	print "<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099-22027118:primer>\t";
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$rvprimerstart-$rvprimerend:primer>\t";
	print "\;\n";		

# <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099-22027118:primer>faldo:location<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099-22027118>
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$rvprimerstart-$rvprimerend:primer>\t";
	print "faldo:location\t";
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$fwprimerstart-$fwprimerend>\t";
	print "\;\n";		

# <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027216-22027197:primer>faldo:location<https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027216-22027197>
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$rvprimerstart-$rvprimerend:primer>\t";
	print "faldo:location\t";
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$rvprimerstart-$rvprimerend>\t";
	print "\;\n";		

# rdf:typeobo:SO_0000121
	print "\t";
	print "rdf:type\t";
	print "obo:SO_0000121\t";
	print "\;\n";		

# rdfs:label"t3747.M000001.1:fwd"
	print "\t";
	print "rdfs:label\t";
	print "\"$markerid:fwd\"\t";
	print "\;\n";		

# :sequence"GCAACAACAGCTCTCGCATA"
	print "\t";
	print ":sequence\t";
	print "\"$fwprimer\"\t";
	print "\;\n";		

#  faldo:begin  <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099>
	print "\t";
	print "faldo:begin\t";
	print "<https://plantgarden.jp/en/list/t3747/marker/$markerid#$chr:$fwstartpos>\t";
	print "\;\n";		

    }
    $cnt++;
}



#  faldo:end <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027118>
#    <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027099>faldo:position"22027099"
#  faldo:reference<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>
#  rdf:type faldo:ExactPosition
#  rdf:type faldo:ForwardStrandPosition
#    <https://plantgarden.jp/en/list/t3747/marker/t3747.M000001.1#Fvb6-1:22027118>faldo:position"22027118"
#  faldo:reference<https://plantgarden.jp/en/list/t3747/sequence/Fvb6-1>
#  rdf:type faldo:ExactPosition
#  rdf:type faldo:ForwardStrandPosition

