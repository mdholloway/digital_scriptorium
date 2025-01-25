# frozen_string_literal: true

require 'wikibase_representable'

module DigitalScriptorium
  # An item representing a Digital Scriptorium record (instance of Q3)
  class Record < WikibaseRepresentable::Model::Item
    include PropertyId

    def described_manuscript_id
      claims_by_property_id(DESCRIBED_MANUSCRIPT)&.first&.entity_id_value # P3
    end
  end
end
