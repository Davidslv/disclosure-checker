module Steps
  module Conviction
    class ConvictionTypeForm < BaseForm
      attribute :conviction_type, String

      def self.choices
        ConvictionType.string_values
      end

      validates_inclusion_of :conviction_type, in: choices

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conviction_type: conviction_type
        )
      end
    end
  end
end
