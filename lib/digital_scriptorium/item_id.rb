# frozen_string_literal: true

require 'set'

module DigitalScriptorium
  # Constants for core model item IDs.
  module ItemId
    MANUSCRIPT             = 'Q1'
    HOLDING                = 'Q2'
    RECORD                 = 'Q3'
    HOLDING_STATUS_CURRENT = 'Q4'

    CORE_MODEL_ITEMS = Set[MANUSCRIPT, HOLDING, RECORD]
  end
end
