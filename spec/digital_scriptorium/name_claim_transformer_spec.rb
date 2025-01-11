# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe NameClaimTransformer do
    let(:export_hash) do
      {
        'Q18' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/author.json')),
        'Q21' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/former_owner.json')),
        'Q383' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/schoenberg.json')),
        'Q394' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/dioscorides.json')),
        'Q1105' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/deste.json')),
        'Q1106' => ItemRepresenter.new(Item.new).from_json(read_fixture('items/llangattock.json'))
      }
    end

    context 'with a single qualifier' do
      json = read_fixture('claims/qualified/name.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'owner_display' => ['{"recorded_value":"Schoenberg, Lawrence J","linked_terms":[{"label":"Lawrence J. Schoenberg","source_url":"https://www.wikidata.org/wiki/Q107542788"}]}'],
        'owner_search' => ['Schoenberg, Lawrence J', 'Lawrence J. Schoenberg'],
        'owner_facet' => ['Lawrence J. Schoenberg']
      }

      it 'includes the qualifier data in all fields' do
        solr_item = described_class.transform(claim, export_hash)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with multiple qualifiers' do
      json = read_fixture('claims/qualified/name_multiple_qualifier_values.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
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

      it 'includes the data from all qualifiers in the display, search, and facet fields' do
        solr_item = described_class.transform(claim, export_hash)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with an original script qualifier' do
      json = read_fixture('claims/qualified/name_original_script.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'author_display' => ['{"recorded_value":"Dioscorides Pedanius, of Anazarbos","original_script":"ديسقوريدس. of Anazarbos","linked_terms":[{"label":"Pedanius Dioscorides","source_url":"https://www.wikidata.org/wiki/Q297776"}]}'],
        'author_search'  => ['Dioscorides Pedanius, of Anazarbos', 'ديسقوريدس. of Anazarbos', 'Pedanius Dioscorides'],
        'author_facet'   => ['Pedanius Dioscorides']
      }

      it 'includes the original script value in the display and search fields' do
        solr_item = described_class.transform(claim, export_hash)
        expect(solr_item).to eq(expected)
      end
    end
  end
end
