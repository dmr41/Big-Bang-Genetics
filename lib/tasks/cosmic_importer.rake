
namespace :cosmic_importer do
  desc "imports single mutations from COSMIC selector"
  task :consensus_import=> :environment do |t, args|
    file = "COSMIC/consensus.csv"
    options = {chunk_size: 50, keep_original_headers: true}
    log_counter = 0
    ConsensusCancerGene.delete_all
    puts file
    SmarterCSV.process(file, options) do |chunk|
      log_counter += 5
      puts "#{log_counter} --------------------" + Time.now.strftime("%I:%M:%S %z")
      chunk.each do |data_hash|
        unless data_hash["mutation_types"].nil?
          data_hash["mutation_types"].gsub!(/[ADFNOST]/, 'A' => 'Amplification', 'D' => 'Deletion(Large)', 'F' => 'Frameshift', 'N' => 'Nonsense', 'O' => 'Other', 'S' => 'Splice-site', 'T' => 'Translocation')
          data_hash["mutation_types"].gsub!(/Mis/, 'Missense')
        end
        ConsensusCancerGene.create!(data_hash)
        # ConsensusCancerGene.new(
        # :gene_symbol => data_hash["gene_symbol"],
        # :name => data_hash["name"],
        # :entrez_geneid => data_hash["entrez_geneid"],
        # :chr => data_hash["chr"],
        # :chr_band => data_hash["chr_band"],
        # :somatic => data_hash["somatic"],
        # :germline => data_hash["germline"],
        # :tumour_types_somatic => data_hash["tumour_types_somatic"],
        # :tumour_types_germline => data_hash["tumour_types_germline"],
        # :cancer_syndrome => data_hash["cancer_syndrome"],
        # :tissue_type => data_hash["tissue_type"],
        # :molecular_genetics => data_hash["molecular_genetics"],
        # :mutation_types => data_hash["mutation_types"],
        # :translocation_partner => data_hash["translocation_partner"] ,
        # :other_germline_mut => data_hash["other_germline_mut"],
        # :other_syndrome => data_hash["other_syndrome"],
        # :synonyms => data_hash["synonyms"]
        # ).save!
      end
    end
  end

  desc "imports single mutations from COSMIC selector"
  task :disease_import => :environment do
    file_array = ["COSMIC/mutations1.csv", "COSMIC/mutations2.csv","COSMIC/mutations3.csv","COSMIC/mutations4.csv"]
    Disease.delete_all
    log_counter = 0
    file_array.each do |file|
      puts "File: " + file + " started!"
      options = {chunk_size: 100000, keep_original_headers: true}
      puts "Disease import time started: " + Time.now.strftime("%I:%M:%S")
      SmarterCSV.process(file, options) do |chunk|
        chunk.each do |data_hash|
          log_counter += 1
          Disease.create!(data_hash)
        end
        puts "--------#{log_counter}--------" + Time.now.strftime("%I:%M:%S")
      end
      puts "Disease import time ended: " + Time.now.strftime("%I:%M:%S")
    end
  end

  desc "imports single mutations from COSMIC selector"
  task :clear_diseases => :environment do
    Disease.delete_all
  end
end
