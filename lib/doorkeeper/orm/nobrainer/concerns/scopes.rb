module Doorkeeper
  module Models
    module Nobrainer
      module Scopes
        extend ActiveSupport::Concern

        included do
          field :scope, type: String
        end

        def scopes=(value)
          write_attribute :scope, value if value.present?
        end

        def scopes
          scope
        end

      end
    end
  end
end
