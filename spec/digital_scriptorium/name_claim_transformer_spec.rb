# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe NameClaimTransformer do
    let(:author_json) { File.read(File.expand_path('../fixtures/items/author.json', __dir__)) }
    let(:owner_json) { File.read(File.expand_path('../fixtures/items/former_owner.json', __dir__)) }

    let(:name_json) { File.read(File.expand_path('../fixtures/claims/qualified/name.json', __dir__)) }
    let(:name_claim) { StatementRepresenter.new(Statement.new).from_json(name_json) }
    let(:name_multiple_qualifier_values_json) { File.read(File.expand_path('../fixtures/claims/qualified/name_multiple_qualifier_values.json', __dir__)) }
    let(:name_multiple_qualifier_values_claim) { StatementRepresenter.new(Statement.new).from_json(name_multiple_qualifier_values_json) }
    let(:name_original_script_json) { File.read(File.expand_path('../fixtures/claims/qualified/name_original_script.json', __dir__)) }
    let(:name_original_script_claim) { StatementRepresenter.new(Statement.new).from_json(name_original_script_json) }

    let(:schoenberg_json) { File.read(File.expand_path('../fixtures/items/schoenberg.json', __dir__)) }
    let(:dioscorides_json) { File.read(File.expand_path('../fixtures/items/dioscorides.json', __dir__)) }
    let(:deste_json) { File.read(File.expand_path('../fixtures/items/deste.json', __dir__)) }
    let(:llangattock_json) { File.read(File.expand_path('../fixtures/items/llangattock.json', __dir__)) }

    let(:export_hash) do
      {
        'Q18' => ItemRepresenter.new(Item.new).from_json(author_json),
        'Q21' => ItemRepresenter.new(Item.new).from_json(owner_json),
        'Q383' => ItemRepresenter.new(Item.new).from_json(schoenberg_json),
        'Q394' => ItemRepresenter.new(Item.new).from_json(dioscorides_json),
        'Q1105' => ItemRepresenter.new(Item.new).from_json(deste_json),
        'Q1106' => ItemRepresenter.new(Item.new).from_json(llangattock_json)
      }
    end

    it 'transforms a name claim' do
      solr_item = described_class.transform(name_claim, export_hash)
      expected = {
        'owner_display' => ['{"recorded_value":"Schoenberg, Lawrence J","linked_terms":[{"label":"Lawrence J. Schoenberg","source_url":"https://www.wikidata.org/wiki/Q107542788"}]}'],
        'owner_search' => ['Schoenberg, Lawrence J', 'Lawrence J. Schoenberg'],
        'owner_facet' => ['Lawrence J. Schoenberg']
      }
      expect(solr_item).to eq(expected)
    end

    it 'transforms a name claim with multiple values for a qualifier' do
      solr_item = described_class.transform(name_multiple_qualifier_values_claim, export_hash)
      expected = {
        'owner_display' => [
          '{"recorded_value":"From the codex made for Leonello d\'Este. Brought to Wales as war booty by 1813, already in a damaged state, by the Rolls family, later enobled as Barons Llangattock, of The Hendre, Monmouth (Llangattock sale, London, Christie\'s, 8 December 1958, lot 190);","linked_terms":[{"label":"Leonello d\'Este, Marquis of Ferrara","source_url":"https://www.wikidata.org/wiki/Q1379797"},{"label":"Baron Llangattock","source_url":"https://www.wikidata.org/wiki/Q4862572"}]}'
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

    it 'transforms a name claim with original script qualifier' do
      solr_item = described_class.transform(name_original_script_claim, export_hash)
      expected = {
        'author_display' => ['{"recorded_value":"Dioscorides Pedanius, of Anazarbos","original_script":"ديسقوريدس. of Anazarbos","linked_terms":[{"label":"Pedanius Dioscorides","source_url":"https://www.wikidata.org/wiki/Q297776"}]}'],
        'author_search' => ['Dioscorides Pedanius, of Anazarbos', 'ديسقوريدس. of Anazarbos', 'Pedanius Dioscorides'],
        'author_facet' => ['Pedanius Dioscorides']
      }
      expect(solr_item).to eq(expected)
    end
  end
end
