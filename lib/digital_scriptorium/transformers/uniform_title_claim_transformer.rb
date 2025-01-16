# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for uniform title (P12) claims.
  class UniformTitleClaimTransformer < BaseClaimTransformer
    PREFIX = 'uniform_title'

    def initialize(claim, _)
      super(claim, prefix: PREFIX)
    end

    def search_values
      [claim.data_value]
    end
  end
end
