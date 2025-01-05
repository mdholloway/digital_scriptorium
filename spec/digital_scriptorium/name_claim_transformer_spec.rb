# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe NameClaimTransformer do
    let(:name_json) { File.read(File.expand_path('../fixtures/claims/qualified/name.json', __dir__)) }
    let(:name_claim) { StatementRepresenter.new(Statement.new).from_json(name_json) }
    let(:schoenberg_json) { File.read(File.expand_path('../fixtures/items/schoenberg.json', __dir__)) }
    let(:owner_json) { File.read(File.expand_path('../fixtures/items/former_owner.json', __dir__)) }
    let(:export_hash) do
      {
        'Q21' => ItemRepresenter.new(Item.new).from_json(owner_json),
        'Q383' => ItemRepresenter.new(Item.new).from_json(schoenberg_json)
      }
    end

    it 'transforms a name claim' do
      solr_item = described_class.transform(name_claim, export_hash)
      expected = {
        'owner_display' => ['{"PV":"Schoenberg, Lawrence J","QL":"Lawrence J. Schoenberg","QU":"https://www.wikidata.org/wiki/Q107542788"}'],
        'owner_search' => ['Schoenberg, Lawrence J', 'Lawrence J. Schoenberg'],
        'owner_facet' => ['Lawrence J. Schoenberg']
      }
      expect(solr_item).to eq(expected)
    end
  end
end
