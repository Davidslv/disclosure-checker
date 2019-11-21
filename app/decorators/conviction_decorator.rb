module ConvictionDecorator
  def compensation?
    [
      ConvictionType::COMPENSATION_TO_A_VICTIM,
      ConvictionType::ADULT_COMPENSATION_TO_A_VICTIM,
    ].include?(self)
  end

  def custodial_sentence?
    [
      ConvictionType::CUSTODIAL_SENTENCE,
      ConvictionType::ADULT_CUSTODIAL_SENTENCE,
    ].include?(self)
  end

  def motoring?
    ConvictionType::ADULT_MOTORING.eql?(self)
  end

  def bailable_offense?
    [
      ConvictionType::DETENTION,
      ConvictionType::DETENTION_TRAINING_ORDER,
      ConvictionType::ADULT_PRISON_SENTENCE,
      ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ].include?(self)
  end
end
