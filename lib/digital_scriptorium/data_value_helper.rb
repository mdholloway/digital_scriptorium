# frozen_string_literal: true

include 'wikibase_representable'

module DigitalScriptorium
  module DataValueHelper
    include WikibaseRepresentable::Model

    def value_from(statement)
      value = statement&.main_snak&.data_value&.value
      return nil unless data_value

      if data_value is_a? EntityIdValue
        value.id
      elsif data_value is_a? TimeValue
        # TODO: Implement me
      else
        value
      end
    end

    def data_value_from(statement)
      statement&.main_snak&.data_value&.value
    end

    def entity_id_value_from(statement)
      statement&.main_snak&.data_value&.value&.id
    end

    def time_value_from(statement)
      # TODO: Implement me
    end
  end
end
