# frozen_string_literal: true

require 'set'

module DigitalScriptorium
  # Constants for core model item IDs.
  module ItemId
    MANUSCRIPT                 = 'Q1'
    HOLDING                    = 'Q2'
    RECORD                     = 'Q3'
    HOLDING_STATUS_CURRENT     = 'Q4'
    HOLDING_STATUS_NON_CURRENT = 'Q5'
    STANDARD_TITLE             = 'Q6'
    ACTOR                      = 'Q7'
    PERSONAL_NAME              = 'Q8'
    CORPORATE_NAME             = 'Q9'
    ROLE                       = 'Q10'
    TERM                       = 'Q11'
    LANGUAGE                   = 'Q12'
    CENTURY                    = 'Q13'
    DATED                      = 'Q14'
    UNDATED                    = 'Q15'
    PLACE                      = 'Q16'
    MATERIAL                   = 'Q17'

    CORE_MODEL_ITEMS = Set[MANUSCRIPT, HOLDING, DS_20_RECORD]
  end
end
