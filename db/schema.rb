# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150111024732) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cancers", force: true do |t|
    t.string "name"
    t.string "genes"
    t.string "search_name"
    t.string "gene_search_name"
  end

  create_table "consensus_cancer_genes", force: true do |t|
    t.string "gene_symbol"
    t.string "name"
    t.string "entrez_geneid"
    t.string "chr"
    t.string "chr_band"
    t.string "somatic"
    t.string "germline"
    t.string "tumour_types_somatic",  default: false
    t.string "tumour_types_germline", default: false
    t.string "cancer_syndrome"
    t.string "tissue_type"
    t.string "molecular_genetics"
    t.string "mutation_types"
    t.string "translocation_partner"
    t.string "other_germline_mut"
    t.string "other_syndrome"
    t.string "synonyms"
  end

  create_table "diseases", force: true do |t|
    t.integer "cosmic_sample_id"
    t.string  "sample_name"
    t.string  "sample_source"
    t.string  "tumour_source"
    t.string  "gene_name"
    t.string  "accession_number"
    t.integer "cosmic_mutation_id"
    t.string  "cds_mutation_syntax"
    t.string  "aa_mutation_syntax"
    t.string  "zygosity"
    t.string  "primary_site"
    t.string  "primary_histology"
    t.integer "pubmed_id"
    t.integer "gene_id"
    t.string  "in_cancer_census"
  end

  create_table "mutations", force: true do |t|
    t.integer  "consensus_cancer_gene_id"
    t.integer  "disease_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "nuc_position1"
    t.integer  "nuc_position2"
    t.string   "ins_del_single"
    t.string   "nuc_change_from"
    t.string   "nuc_change_to"
    t.string   "original_mutation_string"
  end

  create_table "users", force: true do |t|
    t.string  "first_name"
    t.string  "last_name"
    t.integer "age"
    t.string  "email"
    t.string  "password_digest"
  end

end
