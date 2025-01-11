# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for extracting links from relevant Digital Scriptorium items.
  class LinkClaimTransformer
    include PropertyId

    def self.transform(claim, config)
      solr_props = {}
      solr_props['images_facet'] = ['Yes'] if claim.data_value && claim.property_id == IIIF_MANIFEST
      solr_props["#{config['prefix']}_link"] = [claim.data_value]
      solr_props
    end
  end
end
