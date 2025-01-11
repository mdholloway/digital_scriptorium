# frozen_string_literal: true

require 'json'
require 'wikibase_representable'

module DigitalScriptorium
  RSpec.describe NameClaimTransformer do
    context 'with a single name in authority file (P17) qualifier' do
      json = read_fixture('claims/qualified/P14_name.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'owner_display' => [{
          'recorded_value' => 'Schoenberg, Lawrence J',
          'linked_terms' => [{
            'label' => 'Lawrence J. Schoenberg',
            'source_url' => 'https://www.wikidata.org/wiki/Q107542788'
          }]
        }.to_json],
        'owner_search' => ['Schoenberg, Lawrence J', 'Lawrence J. Schoenberg'],
        'owner_facet' => ['Lawrence J. Schoenberg']
      }

      it 'includes the qualifier data in all fields' do
        solr_item = described_class.transform(claim, export_hash)
        expect(solr_item).to eq(expected)
      end
    end

    context 'with multiple name in authority file (P17) qualifiers' do
      json = read_fixture('claims/qualified/P14_name_multiple_qualifier_values.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)

      recorded_value = 'From the codex made for Leonello d\'Este. ' \
        'Brought to Wales as war booty by 1813, already in a damaged state, by the Rolls family, ' \
        'later enobled as Barons Llangattock, of The Hendre, Monmouth ' \
        '(Llangattock sale, London, Christie\'s, 8 December 1958, lot 190);'

      expected = {
        'owner_display' => [{
          'recorded_value' => recorded_value,
          'linked_terms' => [
            { 'label' => 'Leonello d\'Este, Marquis of Ferrara',
              'source_url' => 'https://www.wikidata.org/wiki/Q1379797' },
            { 'label' => 'Baron Llangattock', 'source_url' => 'https://www.wikidata.org/wiki/Q4862572' }
          ]
        }.to_json],
        'owner_search' => [
          recorded_value,
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

    context 'with an original script (P13) qualifier' do
      json = read_fixture('claims/qualified/P14_name_original_script.json')
      claim = StatementRepresenter.new(Statement.new).from_json(json)
      expected = {
        'author_display' => [{
          'recorded_value' => 'Dioscorides Pedanius, of Anazarbos',
          'original_script' => 'ديسقوريدس. of Anazarbos',
          'linked_terms' => [{
            'label' => 'Pedanius Dioscorides',
            'source_url' => 'https://www.wikidata.org/wiki/Q297776'
          }]
        }.to_json],
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
