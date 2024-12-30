# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # An item representing a Digital Scriptorium holding (instance of Q2)
  class Holding < WikibaseRepresentable::Model::Item
    def institution_as_recorded_claims
      get_claims_by_property_id HOLDING_INSTITUTION_AS_RECORDED # P5
    end

    def status_claims
      get_claims_by_property_id HOLDING_STATUS # P6
    end

    def institutional_id_claims
      get_claims_by_property_id INSTITUTIONAL_ID # P7
    end

    def shelfmark_claims
      get_claims_by_property_id SHELFMARK # P8
    end

    def link_to_institutional_record_claims
      get_claims_by_property_id LINK_TO_INSTITUTIONAL_RECORD # P9
    end

    def start_time_claims
      get_claims_by_property_id START_TIME # P38
    end

    def end_time_claims
      get_claims_by_property_id END_TIME # P39
    end
  end
end
