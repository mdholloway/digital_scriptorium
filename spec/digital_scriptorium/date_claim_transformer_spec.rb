# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  include PropertyId

  RSpec.describe DateClaimTransformer do
    context 'with a qualified date (P23) claim' do
      json = read_fixture('claims/P23_date_qualified.json')
      prefix = Transformers.prefix(PRODUCTION_DATE_AS_RECORDED)
      authority_id = Transformers.authority_id(PRODUCTION_DATE_AS_RECORDED)
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => [{
          'recorded_value' => '1358.',
          'linked_terms' => [{
            'label' => 'fourteenth century (dates CE)',
            'facet_field' => 'century_int',
            'facet_value' => 1301,
            'source_url' => 'http://vocab.getty.edu/aat/300404506'
          }]
        }.to_json],
        'date_search' => ['1358.', 'fourteenth century (dates CE)'],
        'date_facet' => ['fourteenth century (dates CE)'],
        'century_int' => [1301]
      }

      it 'extracts display, search, facet and extra date fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified date (P23) claim' do
      json = read_fixture('claims/P23_date_unqualified.json')
      prefix = Transformers.prefix(PRODUCTION_DATE_AS_RECORDED)
      authority_id = Transformers.authority_id(PRODUCTION_DATE_AS_RECORDED)
      expected = {
        'date_meta' => ['1358.'],
        'date_display' => [{ 'recorded_value' => '1358.' }.to_json],
        'date_search' => ['1358.']
      }

      it 'provides the recorded value only in the display, search, and meta fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
