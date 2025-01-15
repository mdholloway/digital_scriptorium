# frozen_string_literal: true

require 'json'

module DigitalScriptorium
  RSpec.describe TitleClaimTransformer do
    context 'with a title (P10) claim with standard title (P11) and original script (P13) qualifiers' do
      json = read_fixture('claims/P10_title_qualified.json')
      expected = {
        'title_display' => [{
          'recorded_value' => 'Kitāb al-Majisṭī',
          'original_script' => 'كتاب المجسطي.',
          'linked_terms': [{ 'label' => 'Almagest' }]
        }.to_json],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.', 'Almagest'],
        'title_facet' => ['Almagest']
      }

      it 'provides all titles in the display and search fields and the standard title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a title (P10) claim with only an original script (P13) qualifier' do
      json = read_fixture('claims/P10_title_qualified_original_script_only.json')
      expected = {
        'title_display' => [{
          'recorded_value' => 'Kitāb al-Majisṭī',
          'original_script' => 'كتاب المجسطي.'
        }.to_json],
        'title_search' => ['Kitāb al-Majisṭī', 'كتاب المجسطي.'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'provides the original script title and falls back to the recorded title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified title (P10) claim' do
      json = read_fixture('claims/P10_title_unqualified.json')
      expected = {
        'title_display' => [{ 'recorded_value' => 'Kitāb al-Majisṭī' }.to_json],
        'title_search' => ['Kitāb al-Majisṭī'],
        'title_facet' => ['Kitāb al-Majisṭī']
      }

      it 'falls back to the recorded title in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
