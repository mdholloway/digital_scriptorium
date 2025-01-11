# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  include WikibaseRepresentable::Model
  include WikibaseRepresentable::Representers

  RSpec.describe DateClaimTransformer do
    export_hash = { 'Q96' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/14c.json')) }
    json = read_fixture('claims/qualified/date.json')
    claim = StatementRepresenter.new(Statement.new).from_json(json)
    config = YAML.load_file(File.expand_path('../../property_config.yml', __dir__))

    it 'transforms a date claim to solr fields' do
      solr_item = described_class.transform(claim, export_hash, config[PropertyId::PRODUCTION_DATE_AS_RECORDED])
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => ['{"recorded_value":"1358.","linked_terms":[{"label":"fourteenth century (dates CE)","source_url":"http://vocab.getty.edu/aat/300404506"}]}'],
        'date_search' => ['1358.', 'fourteenth century (dates CE)'],
        'date_facet' => ['fourteenth century (dates CE)'],
        'century_int' => [1301],
        'earliest_int' => [1358],
        'latest_int' => [1358]
      }
      expect(solr_item).to eq(expected)
    end
  end
end
