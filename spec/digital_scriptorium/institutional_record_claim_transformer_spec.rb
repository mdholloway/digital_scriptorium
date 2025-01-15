# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe InstitutionalRecordClaimTransformer do
    context 'with an institutional record (P9) claim' do
      json = read_fixture('claims/P9_institutional_record.json')
      expected = {
        'institutional_record_link' => ['https://franklin.library.upenn.edu/catalog/FRANKLIN_9949945603503681']
      }

      it 'provides the link to the institutional record' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
