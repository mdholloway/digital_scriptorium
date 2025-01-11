# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe SolrFieldFilter do
    let(:solr_item) do
      {
        'date_meta' => ['1358.'],
        'date_display' => ['{"recorded_value":"1358.","linked_terms":[{"label":"fourteenth century (dates CE)","source_url":"http://vocab.getty.edu/aat/300404506"}]}'],
        'date_search' => ['1358.', 'fourteenth century (dates CE)'],
        'date_facet' => ['fourteenth century (dates CE)'],
        'century_int' => [1301],
        'earliest_int' => [1358],
        'latest_int' => [1358]
      }
    end

    it 'filters out non-requested filterable fields' do
      property_config = { 'fields' => ['display'] }

      expect(described_class.filter(solr_item, property_config)).to eq(
        {
          'date_meta' => ['1358.'],
          'date_display' => ['{"recorded_value":"1358.","linked_terms":[{"label":"fourteenth century (dates CE)","source_url":"http://vocab.getty.edu/aat/300404506"}]}'],
          'century_int' => [1301],
          'earliest_int' => [1358],
          'latest_int' => [1358]
        }
      )
    end
  end
end
