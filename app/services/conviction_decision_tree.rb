class ConvictionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :known_conviction_date
      after_known_conviction_date
    when :under_age_conviction
      edit(:conviction_type)
    when :conviction_date
      edit(:under_age_conviction)
    when :conviction_type
      after_conviction_type
    when :community_order
      show(:exit)
    when :custodial_sentence
      show(:exit)
    when :exit
      show(:exit)
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_known_conviction_date
    return edit(:conviction_date) if GenericYesNo.new(disclosure_check.known_conviction_date).yes?

    edit(:under_age_conviction)
  end

  def after_conviction_type
    return edit(:community_order) if selected?(:conviction_type, value: 'community_sentence')
    return edit(:custodial_sentence) if selected?(:conviction_type, value: 'custodial_sentence')

    show(:exit)
  end
end
