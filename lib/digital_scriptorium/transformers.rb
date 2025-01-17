# frozen_string_literal: true

require_relative 'transformers/base_claim_transformer'
require_relative 'transformers/link_claim_transformer'
require_relative 'transformers/qualified_claim_transformer'
require_relative 'transformers/qualified_claim_transformer_with_facet_fallback'

require_relative 'transformers/acknowledgements_claim_transformer'
require_relative 'transformers/date_claim_transformer'
require_relative 'transformers/dated_claim_transformer'
require_relative 'transformers/iiif_manifest_claim_transformer'
require_relative 'transformers/name_claim_transformer'
require_relative 'transformers/note_claim_transformer'
require_relative 'transformers/physical_description_claim_transformer'
require_relative 'transformers/shelfmark_claim_transformer'
require_relative 'transformers/uniform_title_claim_transformer'

module DigitalScriptorium
  # Factory for creating claim transformers
  module Transformers
    include PropertyId

    TRANSFORMERS = {
      HOLDING_INSTITUTION_AS_RECORDED => QualifiedClaimTransformer,
      SHELFMARK                       => ShelfmarkClaimTransformer,
      LINK_TO_INSTITUTIONAL_RECORD    => LinkClaimTransformer,
      TITLE_AS_RECORDED               => QualifiedClaimTransformerWithFacetFallback,
      UNIFORM_TITLE_AS_RECORDED       => UniformTitleClaimTransformer,
      ASSOCIATED_NAME_AS_RECORDED     => NameClaimTransformer,
      GENRE_AS_RECORDED               => QualifiedClaimTransformerWithFacetFallback,
      SUBJECT_AS_RECORDED             => QualifiedClaimTransformerWithFacetFallback,
      LANGUAGE_AS_RECORDED            => QualifiedClaimTransformer,
      PRODUCTION_DATE_AS_RECORDED     => DateClaimTransformer,
      DATED                           => DatedClaimTransformer,
      PRODUCTION_PLACE_AS_RECORDED    => QualifiedClaimTransformer,
      PHYSICAL_DESCRIPTION            => PhysicalDescriptionClaimTransformer,
      MATERIAL_AS_RECORDED            => QualifiedClaimTransformer,
      NOTE                            => NoteClaimTransformer,
      ACKNOWLEDGEMENTS                => AcknowledgementsClaimTransformer,
      IIIF_MANIFEST                   => IiifManifestClaimTransformer
    }.freeze

    AUTHORITY_IDS = {
      HOLDING_INSTITUTION_AS_RECORDED => HOLDING_INSTITUTION_IN_AUTHORITY_FILE,
      TITLE_AS_RECORDED               => STANDARD_TITLE,
      ASSOCIATED_NAME_AS_RECORDED     => NAME_IN_AUTHORITY_FILE,
      GENRE_AS_RECORDED               => TERM_IN_AUTHORITY_FILE,
      SUBJECT_AS_RECORDED             => TERM_IN_AUTHORITY_FILE,
      LANGUAGE_AS_RECORDED            => LANGUAGE_IN_AUTHORITY_FILE,
      PRODUCTION_DATE_AS_RECORDED     => PRODUCTION_CENTURY_IN_AUTHORITY_FILE,
      PRODUCTION_PLACE_AS_RECORDED    => PLACE_IN_AUTHORITY_FILE,
      MATERIAL_AS_RECORDED            => MATERIAL_IN_AUTHORITY_FILE
    }.freeze

    PREFIXES = {
      HOLDING_INSTITUTION_AS_RECORDED => 'institution',
      SHELFMARK                       => 'shelfmark',
      LINK_TO_INSTITUTIONAL_RECORD    => 'institutional_record',
      TITLE_AS_RECORDED               => 'title',
      UNIFORM_TITLE_AS_RECORDED       => 'uniform_title',
      ASSOCIATED_NAME_AS_RECORDED     => 'name',
      GENRE_AS_RECORDED               => 'term',
      SUBJECT_AS_RECORDED             => 'term',
      LANGUAGE_AS_RECORDED            => 'language',
      PRODUCTION_DATE_AS_RECORDED     => 'date',
      DATED                           => 'dated',
      PRODUCTION_PLACE_AS_RECORDED    => 'place',
      PHYSICAL_DESCRIPTION            => 'physical_description',
      MATERIAL_AS_RECORDED            => 'material',
      NOTE                            => 'note',
      ACKNOWLEDGEMENTS                => 'acknowledgements',
      IIIF_MANIFEST                   => 'iiif_manifest'
    }.freeze

    def self.transformer(property_id)
      TRANSFORMERS[property_id]
    end

    def self.authority_id(property_id)
      AUTHORITY_IDS[property_id]
    end

    def self.prefix(property_id)
      PREFIXES[property_id]
    end

    def self.create(property_id, claim, export_hash)
      transformer_class = TRANSFORMERS[property_id]
      authority_id = AUTHORITY_IDS[property_id]
      prefix = PREFIXES[property_id]
      return unless transformer && prefix

      transformer_class.new(claim, export_hash, prefix: prefix, authority_id: authority_id)
    end
  end
end
