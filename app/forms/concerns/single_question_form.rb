module SingleQuestionForm
  extend ActiveSupport::Concern

  module ClassMethods
    attr_accessor :reset_attributes

    private

    def yes_no_attribute(name, reset_when_yes: [], reset_when_no: [])
      attribute name, YesNo
      validates_inclusion_of name, in: :choices

      self.reset_attributes = {
        GenericYesNo::YES => expand_attributes(reset_when_yes),
        GenericYesNo::NO  => expand_attributes(reset_when_no)
      }
    end

    def expand_attributes(attributes)
      attributes.map do |obj|
        obj.is_a?(Symbol) ? obj : obj.attribute_names
      end.flatten.uniq
    end
  end

  def choices
    GenericYesNo.values
  end

  private

  def answer
    attributes_map.values.first
  end

  def attributes_to_reset
    self.class.reset_attributes[answer].collect { |att| [att, nil] }.to_h
  end

  def persist!
    raise BaseForm::DisclosureCheckNotFound unless disclosure_check

    record_to_persist.update(
      attributes_map.merge(attributes_to_reset)
    )
  end
end
