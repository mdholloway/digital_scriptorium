# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # An item representing a Digital Scriptorium record (instance of Q3)
  class Record < WikibaseRepresentable::Model::Item
    include PropertyId
    include StatementHelper

    def described_manuscript_id
      described_manuscript_claim = get_first_claim_by_property_id DESCRIBED_MANUSCRIPT # P3
      return nil unless described_manuscript_claim

      described_manuscript_claim.main_snak&.data_value&.value
    end

    def title_as_recorded_claims
      get_claims_by_property_id TITLE_AS_RECORDED # P10
    end

    def uniform_title_as_recorded_claims
      get_claims_by_property_id UNIFORM_TITLE_AS_RECORDED # P12
    end

    def associated_name_as_recorded_claims
      get_claims_by_property_id ASSOCIATED_NAME_AS_RECORDED # P14
    end

    def genre_as_recorded_claims
      get_claims_by_property_id GENRE_AS_RECORDED # P18
    end

    def language_as_recorded_claims
      get_claims_by_property_id LANGUAGE_AS_RECORDED # P21
    end

    def production_date_as_recorded_claims
      get_claims_by_property_id PRODUCTION_DATE_AS_RECORDED # P23
    end

    def dated_claims
      get_claims_by_property_id DATED # P26
    end

    def production_place_as_recorded_claims
      get_claims_by_property_id PRODUCTION_PLACE_AS_RECORDED # P27
    end

    def physical_description_claims
      get_claims_by_property_id PHYSICAL_DESCRIPTION # P29
    end

    def material_as_recorded_claims
      get_claims_by_property_id MATERIAL_AS_RECORDED # P30
    end

    def note_claims
      get_claims_by_property_id NOTE # P32
    end

    def acknowledgements_claims
      get_claims_by_property_id ACKNOWLEDGEMENTS # P33
    end

    def date_added_claims
      get_claims_by_property_id DATE_ADDED # P34
    end

    def date_last_updated_claims
      get_claims_by_property_id DATE_LAST_UPDATED # P35
    end

    def iiif_manifest_claims
      get_claims_by_property_id IIIF_MANIFEST # P41
    end
  end
end
