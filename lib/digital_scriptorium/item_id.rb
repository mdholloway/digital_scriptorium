# frozen_string_literal: true

module DigitalScriptorium
  # Constants for core model item IDs.
  module ItemId
    MANUSCRIPT = 'Q1'
    HOLDING    = 'Q2'
    RECORD     = 'Q3'

    CORE_MODEL_ITEMS = Set[MANUSCRIPT, HOLDING, RECORD]
  end
end
