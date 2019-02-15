module Steps
  module Check
    class CautionDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :caution_date, Date

      acts_as_gov_uk_date :caution_date

      validates_presence_of :caution_date

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          caution_date: caution_date
        )
      end
    end
  end
end
