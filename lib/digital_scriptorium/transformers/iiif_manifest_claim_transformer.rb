# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for IIIF Manifest (P41) claims.
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
