
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
  task :mutation_table_builder => :environment do
    @mutation_build = CancerImporter.new
    @mutation_build.mutations_join_table
  end

  desc "removes underscores from Mutation table data"
  task :clean_underscores => :environment do
    # @diseases = Disease.all
    # @diseases.each do |disease|

    # end
    @mutations = Mutation.all
    @mutations.each do |mutation|
      mutation.original_histology = mutation.original_histology.gsub(/_/, " ").capitalize
      mutation.save
    end
  end
end
