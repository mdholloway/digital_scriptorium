# frozen_string_literal: true

require 'json'
require 'wikibase_representable'
require 'yaml'

module DigitalScriptorium
  RSpec.describe DateClaimTransformer do
    let(:date_json) { File.read(File.expand_path('../fixtures/claims/qualified/date.json', __dir__)) }
    let(:date_claim) { StatementRepresenter.new(Statement.new).from_json(date_json) }
    let(:fourteenth_c_json) { File.read(File.expand_path('../fixtures/items/14c.json', __dir__)) }
    let(:export_hash) { { 'Q96' => ItemRepresenter.new(Item.new).from_json(fourteenth_c_json) } }
    let(:config) { YAML.load_file(File.expand_path('../../property_config.yml', __dir__)) }

    it 'transforms a qualified date claim' do
      solr_item = described_class.transform(date_claim, export_hash, config[PropertyId::PRODUCTION_DATE_AS_RECORDED])
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => ['{"PV":"1358.","QL":"fourteenth century (dates CE)","QU":"http://vocab.getty.edu/aat/300404506"}'],
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
