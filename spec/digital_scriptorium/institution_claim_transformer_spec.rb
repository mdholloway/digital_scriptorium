# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe InstitutionClaimTransformer do
    context 'with a qualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_qualified.json')
      expected = {
        'institution_display' => [{
          'recorded_value' => 'U. of Penna.',
          'linked_terms' => [{
            'label' => 'University of Pennsylvania',
            'source_url' => 'https://www.wikidata.org/wiki/Q49117'
          }]
        }.to_json],
        'institution_search' => ['U. of Penna.', 'University of Pennsylvania'],
        'institution_facet' => ['University of Pennsylvania']
      }

      it 'provides the qualifier label in the display, search, and facet fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_unqualified.json')
      expected = {
        'institution_display' => [{ 'recorded_value' => 'U. of Penna.' }.to_json],
        'institution_search' => ['U. of Penna.']
      }

      it 'provides the recorded value only in the search and display fields' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
