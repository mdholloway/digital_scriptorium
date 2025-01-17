# frozen_string_literal: true

module DigitalScriptorium
  # Transformer for uniform title (P12) claims.
  class UniformTitleClaimTransformer < BaseClaimTransformer
    def initialize(claim, _, **kwargs)
      super(claim, **kwargs)
    end

    def search_values
      [claim.data_value]
    end
  end
end
