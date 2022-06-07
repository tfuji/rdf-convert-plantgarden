#!/usr/bin/env ruby

require 'json'
require 'pp'
    
file_path = ARGV.shift || "pg_pubtator-test.json"
file = File.open "pg_pubtator-test.json"
data = JSON.load file

data.each do |item|
    uri_prefix = ""
    id = item["id"] || ""
    taxonomy_id = item["taxonomy_id"].gsub("t","").gsub("*","")
    case item["bio_concepts"]
    when "Strain", "Species", "Genus"
        uri_prefix = "http://identifiers.org/taxonomy/"
    when "Gene"
        uri_prefix = "http://identifiers.org/ncbigene/"
    when "Chemical"
        uri_prefix = "http://id.nlm.nih.gov/mesh/"
        id = id.gsub("MESH:","")
    when "Disease"
        uri_prefix = "http://id.nlm.nih.gov/mesh/"
        id = id.gsub("MESH:","")
    when "SNP"
        next
    when "DNAMutation"
        next     
    when "ProteinMutation"
        next
    when "CellLine"
        next   
    when null
        next
    else
        next
    end


    puts "
<http://togodb.org/entry/pg_pubtator/10030630#abstract-164-171>

    pg_pubtator:pmid \"#{item['pmid']}\" ;
    pg_pubtator:start \"#{item["start"]}\" ;      
    pg_pubtator:end \"#{item["end"]}\" ;
    pg_pubtator:id \"#{item["id"]}\" ;
    pg_pubtator:organism \"#{item["organism"]}\" ;
    pg_pubtator:sentence \"#{item["sentence"]}\" ;
    pg_pubtator:pg_species \"#{item["taxonomy_id"]}\" ;
    pg_pubtator:term \"#{item["term"]}\" ;
    rdfs:label \"#{item["term"]}\" ;
    pg_pubtator:bio_concepts \"#{item["bio_concepts"]}\" ;
    pg_pubtator:uri <#{uri_prefix}#{id}> ;
    pg_pubtator:pubmed <http://identifiers.org/pubmed/#{item['pmid']}>;
    rdfs:seeAlso <http://identifiers.org/pubmed/#{item['pmid']}>;
    pg_pubtator:taxon <http://identifiers.org/taxonomy/#{taxonomy_id}>;
    rdfs:seeAlso <http://identifiers.org/taxonomy/#{taxonomy_id}>;
    rdf:type <http://togodb.org/pg_pubtator> .   
    " 
end


 #        "bio_concepts": null,
 #        "bio_concepts": "Strain",
 #    "id": "674470"
 #        "bio_concepts": "Species",
 #    "id": "3747"
 #        "bio_concepts": "SNP",
 #    "id": "rs12934922",
 #        "bio_concepts": "ProteinMutation",
 #    "id": "p.C118Y"
 #        "bio_concepts": "Genus",
 #    "id": "*3702",
 #        "bio_concepts": "Gene",
 #    "id": "843974",
 #        "bio_concepts": "Disease",
 #    "id": "MESH:D021081"
 #        "bio_concepts": "DNAMutation",
 #    "id": "c.76UGT>C"
 #        "bio_concepts": "Chemical",
 #    "id": "MESH:D059808"
 #        "bio_concepts": "CellLine",
 #    "id": "CVCL:0027"
