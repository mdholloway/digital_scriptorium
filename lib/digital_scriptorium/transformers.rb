# frozen_string_literal: true

require 'digital_scriptorium/transformers/base_claim_transformer'
require 'digital_scriptorium/transformers/link_claim_transformer'
require 'digital_scriptorium/transformers/qualified_claim_transformer'
require 'digital_scriptorium/transformers/qualified_claim_transformer_with_facet_fallback'

require 'digital_scriptorium/transformers/acknowledgements_claim_transformer'
require 'digital_scriptorium/transformers/date_claim_transformer'
require 'digital_scriptorium/transformers/dated_claim_transformer'
require 'digital_scriptorium/transformers/iiif_manifest_claim_transformer'
require 'digital_scriptorium/transformers/institution_claim_transformer'
require 'digital_scriptorium/transformers/institutional_record_claim_transformer'
require 'digital_scriptorium/transformers/language_claim_transformer'
require 'digital_scriptorium/transformers/material_claim_transformer'
require 'digital_scriptorium/transformers/name_claim_transformer'
require 'digital_scriptorium/transformers/note_claim_transformer'
require 'digital_scriptorium/transformers/physical_description_claim_transformer'
require 'digital_scriptorium/transformers/place_claim_transformer'
require 'digital_scriptorium/transformers/shelfmark_claim_transformer'
require 'digital_scriptorium/transformers/term_claim_transformer'
require 'digital_scriptorium/transformers/title_claim_transformer'
require 'digital_scriptorium/transformers/uniform_title_claim_transformer'

module DigitalScriptorium
  class Transformers
    include PropertyId

    TRANSFORMERS = {
      HOLDING_INSTITUTION_AS_RECORDED => InstitutionClaimTransformer,
      SHELFMARK => ShelfmarkClaimTransformer,
      LINK_TO_INSTITUTIONAL_RECORD => InstitutionalRecordClaimTransformer,
      TITLE_AS_RECORDED => TitleClaimTransformer,
      UNIFORM_TITLE_AS_RECORDED => UniformTitleClaimTransformer,
      ASSOCIATED_NAME_AS_RECORDED => NameClaimTransformer,
      GENRE_AS_RECORDED => TermClaimTransformer,
      SUBJECT_AS_RECORDED => TermClaimTransformer,
      LANGUAGE_AS_RECORDED => LanguageClaimTransformer,
      PRODUCTION_DATE_AS_RECORDED => DateClaimTransformer,
      DATED => DatedClaimTransformer,
      PRODUCTION_PLACE_AS_RECORDED => PlaceClaimTransformer,
      PHYSICAL_DESCRIPTION => PhysicalDescriptionClaimTransformer,
      MATERIAL_AS_RECORDED => MaterialClaimTransformer,
      NOTE => NoteClaimTransformer,
      ACKNOWLEDGEMENTS => AcknowledgementsClaimTransformer,
      IIIF_MANIFEST => IiifManifestClaimTransformer
    }.freeze

    def self.defined?(property_id)
      TRANSFORMERS[property_id]
    end

    def self.create(property_id, claim, export_hash)
      return unless self.defined?(property_id)

      TRANSFORMERS[property_id].new(claim, export_hash)
    end
  end
end
