# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for extracting links from relevant Digital Scriptorium claims.
  class IiifManifestClaimTransformer < LinkClaimTransformer
    PREFIX = 'iiif_manifest'

    def initialize(claim, _)
      super(claim, prefix: PREFIX)
    end

    def solr_props
      super.merge({ 'images_facet' => ['Yes'] })
    end
  end
end
