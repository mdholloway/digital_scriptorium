# frozen_string_literal: true

module DigitalScriptorium
  RSpec.describe IiifManifestClaimTransformer do
    context 'with an IIIF manifest (P41) claim' do
      json = read_fixture('claims/P41_iiif_manifest.json')
      expected = {
        'iiif_manifest_link' => ['https://colenda.library.upenn.edu/phalt/iiif/2/81431-p33p8v/manifest'],
        'images_facet' => ['Yes']
      }

      it 'provides the link to the IIIF manifest in the link property and "Yes" in the facet property' do
        solr_props = described_class.new(build_claim(json), export_hash).solr_props
        expect(solr_props).to eq(expected)
      end
    end
  end
end
