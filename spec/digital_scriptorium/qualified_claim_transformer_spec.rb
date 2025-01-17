# frozen_string_literal: true

module DigitalScriptorium
  include PropertyId

  RSpec.describe QualifiedClaimTransformer do
    context 'with a qualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_qualified.json')
      prefix = Transformers.prefix(HOLDING_INSTITUTION_AS_RECORDED)
      authority_id = Transformers.authority_id(HOLDING_INSTITUTION_AS_RECORDED)
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
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified institution (P5) claim' do
      json = read_fixture('claims/P5_institution_unqualified.json')
      prefix = Transformers.prefix(HOLDING_INSTITUTION_AS_RECORDED)
      authority_id = Transformers.authority_id(HOLDING_INSTITUTION_AS_RECORDED)
      expected = {
        'institution_display' => [{ 'recorded_value' => 'U. of Penna.' }.to_json],
        'institution_search' => ['U. of Penna.']
      }

      it 'provides the recorded value only in the search and display fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a qualified language (P21) claim' do
      json = read_fixture('claims/P21_language_qualified.json')
      prefix = Transformers.prefix(LANGUAGE_AS_RECORDED)
      authority_id = Transformers.authority_id(LANGUAGE_AS_RECORDED)
      expected = {
        'language_display' => [{
          'recorded_value' => 'In Latin',
          'linked_terms': [{ 'label' => 'Latin', 'source_url' => 'https://www.wikidata.org/wiki/Q397' }]
        }.to_json],
        'language_search' => ['In Latin', 'Latin'],
        'language_facet' => ['Latin']
      }

      it 'provides both values in display and search fields and authoritative value in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified language (P21) claim' do
      json = read_fixture('claims/P21_language_unqualified.json')
      prefix = Transformers.prefix(LANGUAGE_AS_RECORDED)
      authority_id = Transformers.authority_id(LANGUAGE_AS_RECORDED)
      expected = {
        'language_display' => [{ 'recorded_value' => 'In Latin' }.to_json],
        'language_search' => ['In Latin']
      }

      it 'provides the recorded value in the display and search fields only' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a qualified place (P27) claim with multi-valued qualifier' do
      json = read_fixture('claims/P27_place_multiple_qualifier_values.json')
      prefix = Transformers.prefix(PRODUCTION_PLACE_AS_RECORDED)
      authority_id = Transformers.authority_id(PRODUCTION_PLACE_AS_RECORDED)
      expected = {
        'place_display' => [{
          'recorded_value' => '[Provence or Spain],',
          'linked_terms' => [
            { 'label' => 'Provence', 'source_url' => 'http://vocab.getty.edu/tgn/7012209' },
            { 'label' => 'Spain', 'source_url' => 'http://vocab.getty.edu/tgn/1000095' }
          ]
        }.to_json],
        'place_search' => ['[Provence or Spain],', 'Provence', 'Spain'],
        'place_facet' => %w[Provence Spain]
      }

      it 'includes the data from all qualifiers in the display, search, and facet fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified place (P27) claim' do
      json = read_fixture('claims/P27_place_unqualified.json')
      prefix = Transformers.prefix(PRODUCTION_PLACE_AS_RECORDED)
      authority_id = Transformers.authority_id(PRODUCTION_PLACE_AS_RECORDED)
      expected = {
        'place_display' => [{ 'recorded_value' => '[Provence or Spain],' }.to_json],
        'place_search' => ['[Provence or Spain],']
      }

      it 'provides the recorded value in the search and facet fields only' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with a qualified material (P30) claim' do
      json = read_fixture('claims/P30_material_qualified.json')
      prefix = Transformers.prefix(MATERIAL_AS_RECORDED)
      authority_id = Transformers.authority_id(MATERIAL_AS_RECORDED)
      expected = {
        'material_display' => [{
          'recorded_value' => 'parchment',
          'linked_terms' => [{ 'label' => 'Parchment', 'source_url' => 'http://vocab.getty.edu/aat/300011851' }]
        }.to_json],
        'material_search' => %w[parchment Parchment],
        'material_facet' => ['Parchment']
      }

      it 'provides the authoritative label in the facet field' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end

    context 'with an unqualified material (P30) claim' do
      json = read_fixture('claims/P30_material_unqualified.json')
      prefix = Transformers.prefix(MATERIAL_AS_RECORDED)
      authority_id = Transformers.authority_id(MATERIAL_AS_RECORDED)
      expected = {
        'material_display' => [{ 'recorded_value' => 'parchment' }.to_json],
        'material_search' => ['parchment']
      }

      it 'provides the recorded value only in the search and display fields' do
        solr_props = described_class.new(build_claim(json), export_hash, prefix: prefix,
                                                                         authority_id: authority_id).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
