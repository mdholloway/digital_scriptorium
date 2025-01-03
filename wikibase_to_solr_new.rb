# frozen_string_literal: true

require 'digital_scriptorium'
require 'json'
require 'optparse'
require 'wikibase_representable'
require 'yaml'
require 'zlib'

include DigitalScriptorium

def merge(solr_item, new_props)
  solr_item.merge(new_props) do |_, old_val, new_val|
    old_val.nil? ? new_val : (old_val + new_val).uniq
  end
end

dir = File.dirname __FILE__

input_file = File.expand_path 'wikibase_export.json.gz', dir
output_file = File.expand_path 'solr_import.json', dir

OptionParser.new do |opts|
  opts.banner = 'Usage: wikibase_to_solr.rb [options]'

  opts.on('-i', '--in FILE', 'The file path to the gzipped Wikibase JSON export file.') do |f|
    input_file = File.expand_path f, dir
  end

  opts.on('-o', '--out FILE', 'The file path to output the formatted Solr JSON file.') do |f|
    output_file = File.expand_path f, dir
  end
end.parse!

config = YAML.load_file(File.join(dir, 'prop_solr_config.yml'))

export_hash = ExportRepresenter.new(Export.new).from_json(Zlib::GzipReader.open(input_file).read).to_hash
solr_items = []

export_hash.each do |_, entity|
  if entity.is_a?(DsItem) && entity.has_instance_of_claims? && entity.record?
    meta = DsMeta.new(entity, export_hash)
    solr_item = { 'qid_meta' => [meta.holding.id, meta.manuscript.id, meta.record.id] }

    [meta.holding, meta.manuscript, meta.record].each do |item|
      item.claims.each do |property_id, claims|
        claims.each do |claim|
          next unless property_config = config[property_id]

          if property_id == PropertyId::ASSOCIATED_NAME_AS_RECORDED
            solr_item = merge(solr_item, NameStatementConverter.convert(claim, export_hash))
          elsif property_id == PropertyId::PRODUCTION_DATE_AS_RECORDED
            solr_item = merge(solr_item, DateStatementConverter.convert(claim, export_hash, property_config))
          else
            solr_item = merge(solr_item, StatementConverter.convert(claim, export_hash, property_config))
          end
        end
      end
    end

    solr_items << solr_item
  end
end

File.write(output_file, JSON.pretty_generate(solr_items))
