# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe NameClaimTransformer do
    let(:owner_json) { File.read(File.expand_path('../fixtures/items/former_owner.json', __dir__)) }

    let(:name_json) { File.read(File.expand_path('../fixtures/claims/qualified/name.json', __dir__)) }
    let(:name_claim) { StatementRepresenter.new(Statement.new).from_json(name_json) }
    let(:schoenberg_json) { File.read(File.expand_path('../fixtures/items/schoenberg.json', __dir__)) }

    let(:name_multiple_qualifier_values_json) { File.read(File.expand_path('../fixtures/claims/qualified/name_multiple_qualifier_values.json', __dir__)) }
    let(:name_multiple_qualifier_values_claim) { StatementRepresenter.new(Statement.new).from_json(name_multiple_qualifier_values_json) }
    let(:deste_json) { File.read(File.expand_path('../fixtures/items/deste.json', __dir__)) }
    let(:llangattock_json) { File.read(File.expand_path('../fixtures/items/llangattock.json', __dir__)) }

    let(:export_hash) do
      {
        'Q21' => ItemRepresenter.new(Item.new).from_json(owner_json),
        'Q383' => ItemRepresenter.new(Item.new).from_json(schoenberg_json),
        'Q1105' => ItemRepresenter.new(Item.new).from_json(deste_json),
        'Q1106' => ItemRepresenter.new(Item.new).from_json(llangattock_json)
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

    it 'transforms a name claim with multiple values for a qualifier' do
      solr_item = described_class.transform(name_multiple_qualifier_values_claim, export_hash)
      expected = {
        'owner_display' => [
          '{"PV":"From the codex made for Leonello d\'Este. Brought to Wales as war booty by 1813, already in a damaged state, by the Rolls family, later enobled as Barons Llangattock, of The Hendre, Monmouth (Llangattock sale, London, Christie\'s, 8 December 1958, lot 190);","QL":"Leonello d\'Este, Marquis of Ferrara","QU":"https://www.wikidata.org/wiki/Q1379797"}',
          '{"PV":"From the codex made for Leonello d\'Este. Brought to Wales as war booty by 1813, already in a damaged state, by the Rolls family, later enobled as Barons Llangattock, of The Hendre, Monmouth (Llangattock sale, London, Christie\'s, 8 December 1958, lot 190);","QL":"Baron Llangattock","QU":"https://www.wikidata.org/wiki/Q4862572"}'
        ],
        'owner_search' => [
          'From the codex made for Leonello d\'Este. Brought to Wales as war booty by 1813, already in a damaged state, by the Rolls family, later enobled as Barons Llangattock, of The Hendre, Monmouth (Llangattock sale, London, Christie\'s, 8 December 1958, lot 190);',
          'Leonello d\'Este, Marquis of Ferrara',
          'Baron Llangattock'
        ],
        'owner_facet' => [
          'Leonello d\'Este, Marquis of Ferrara',
          'Baron Llangattock'
        ]
      }
      expect(solr_item).to eq(expected)
    end
  end
end
