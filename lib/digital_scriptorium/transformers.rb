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
    TRANSFORMERS = {
      PropertyId::HOLDING_INSTITUTION_AS_RECORDED => QualifiedClaimTransformer,
      PropertyId::SHELFMARK                       => ShelfmarkClaimTransformer,
      PropertyId::LINK_TO_INSTITUTIONAL_RECORD    => LinkClaimTransformer,
      PropertyId::TITLE_AS_RECORDED               => QualifiedClaimTransformerWithFacetFallback,
      PropertyId::UNIFORM_TITLE_AS_RECORDED       => UniformTitleClaimTransformer,
      PropertyId::ASSOCIATED_NAME_AS_RECORDED     => NameClaimTransformer,
      PropertyId::GENRE_AS_RECORDED               => QualifiedClaimTransformerWithFacetFallback,
      PropertyId::SUBJECT_AS_RECORDED             => QualifiedClaimTransformerWithFacetFallback,
      PropertyId::LANGUAGE_AS_RECORDED            => QualifiedClaimTransformer,
      PropertyId::PRODUCTION_DATE_AS_RECORDED     => DateClaimTransformer,
      PropertyId::DATED                           => DatedClaimTransformer,
      PropertyId::PRODUCTION_PLACE_AS_RECORDED    => QualifiedClaimTransformer,
      PropertyId::PHYSICAL_DESCRIPTION            => PhysicalDescriptionClaimTransformer,
      PropertyId::MATERIAL_AS_RECORDED            => QualifiedClaimTransformer,
      PropertyId::NOTE                            => NoteClaimTransformer,
      PropertyId::ACKNOWLEDGEMENTS                => AcknowledgementsClaimTransformer,
      PropertyId::IIIF_MANIFEST                   => IiifManifestClaimTransformer
    }.freeze

    AUTHORITY_IDS = {
      PropertyId::HOLDING_INSTITUTION_AS_RECORDED => PropertyId::HOLDING_INSTITUTION_IN_AUTHORITY_FILE,
      PropertyId::TITLE_AS_RECORDED               => PropertyId::STANDARD_TITLE,
      PropertyId::ASSOCIATED_NAME_AS_RECORDED     => PropertyId::NAME_IN_AUTHORITY_FILE,
      PropertyId::GENRE_AS_RECORDED               => PropertyId::TERM_IN_AUTHORITY_FILE,
      PropertyId::SUBJECT_AS_RECORDED             => PropertyId::TERM_IN_AUTHORITY_FILE,
      PropertyId::LANGUAGE_AS_RECORDED            => PropertyId::LANGUAGE_IN_AUTHORITY_FILE,
      PropertyId::PRODUCTION_DATE_AS_RECORDED     => PropertyId::PRODUCTION_CENTURY_IN_AUTHORITY_FILE,
      PropertyId::PRODUCTION_PLACE_AS_RECORDED    => PropertyId::PLACE_IN_AUTHORITY_FILE,
      PropertyId::MATERIAL_AS_RECORDED            => PropertyId::MATERIAL_IN_AUTHORITY_FILE
    }.freeze

    PREFIXES = {
      PropertyId::HOLDING_INSTITUTION_AS_RECORDED => 'institution',
      PropertyId::SHELFMARK                       => 'shelfmark',
      PropertyId::LINK_TO_INSTITUTIONAL_RECORD    => 'institutional_record',
      PropertyId::TITLE_AS_RECORDED               => 'title',
      PropertyId::UNIFORM_TITLE_AS_RECORDED       => 'uniform_title',
      PropertyId::ASSOCIATED_NAME_AS_RECORDED     => 'name',
      PropertyId::GENRE_AS_RECORDED               => 'term',
      PropertyId::SUBJECT_AS_RECORDED             => 'term',
      PropertyId::LANGUAGE_AS_RECORDED            => 'language',
      PropertyId::PRODUCTION_DATE_AS_RECORDED     => 'date',
      PropertyId::DATED                           => 'dated',
      PropertyId::PRODUCTION_PLACE_AS_RECORDED    => 'place',
      PropertyId::PHYSICAL_DESCRIPTION            => 'physical_description',
      PropertyId::MATERIAL_AS_RECORDED            => 'material',
      PropertyId::NOTE                            => 'note',
      PropertyId::ACKNOWLEDGEMENTS                => 'acknowledgements',
      PropertyId::IIIF_MANIFEST                   => 'iiif_manifest'
    }.freeze

    def self.defined?(property_id)
      TRANSFORMERS.include?(property_id)
    end

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
      return unless transformer_class && prefix

      transformer_class.new(claim, export_hash, prefix: prefix, authority_id: authority_id)
    end
  end
end
