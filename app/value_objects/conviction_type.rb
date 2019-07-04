class ConvictionType < ValueObject
  attr_reader :parent, :skip_length, :compensation, :calculator_class

  def initialize(raw_value, params = {})
    @parent = params.fetch(:parent, nil)
    @skip_length = params.fetch(:skip_length, false)
    @compensation = params.fetch(:compensation, false)
    @calculator_class = params.fetch(:calculator_class, nil)

    super(raw_value)
  end

  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  alias skip_length? skip_length
  alias compensation? compensation

  VALUES = [
    PARENT_TYPES = [
      ARMED_FORCES          = new(:armed_forces),
      COMMUNITY_ORDER       = new(:community_order),
      CUSTODIAL_SENTENCE    = new(:custodial_sentence),
      DISCHARGE             = new(:discharge),
      FINANCIAL             = new(:financial),
      HOSPITAL_GUARD_ORDER  = new(:hospital_guard_order),
    ].freeze,

    DISMISSAL                          = new(:dismissal,                        parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    SERVICE_DETENTION                  = new(:service_detention,                parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    SERVICE_COMMUNITY_ORDER            = new(:service_community_order,          parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    OVERSEAS_COMMUNITY_ORDER           = new(:overseas_community_order,         parent: ARMED_FORCES, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),

    ALCOHOL_ABSTINENCE_TREATMENT       = new(:alcohol_abstinence_treatment,     parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    ATTENDANCE_CENTRE_ORDER            = new(:attendance_centre_order,          parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    BEHAVIOURAL_CHANGE_PROG            = new(:behavioural_change_prog,          parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    BIND_OVER                          = new(:bind_over,                        parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    CURFEW                             = new(:curfew,                           parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    DRUG_REHABILITATION                = new(:drug_rehabilitation,              parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    EXCLUSION_REQUIREMENT              = new(:exclusion_requirement,            parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    INTOXICATING_SUBSTANCE_TREATMENT   = new(:intoxicating_substance_treatment, parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    MENTAL_HEALTH_TREATMENT            = new(:mental_health_treatment,          parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    PROHIBITION                        = new(:prohibition,                      parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    REFERRAL_ORDER                     = new(:referral_order,                   parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    REHAB_ACTIVITY_REQUIREMENT         = new(:rehab_activity_requirement,       parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),
    REPARATION_ORDER                   = new(:reparation_order,                 parent: COMMUNITY_ORDER, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    RESIDENCE_REQUIREMENT              = new(:residence_requirement,            parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    RESTRAINING_ORDER                  = new(:restraining_order,                parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SEXUAL_HARM_PREVENTION_ORDER       = new(:sexual_harm_prevention_order,     parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    SUPERVISION_ORDER                  = new(:supervision_order,                parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    UNPAID_WORK                        = new(:unpaid_work,                      parent: COMMUNITY_ORDER, calculator_class: Calculators::AdditionCalculator::PlusSixMonths),

    DETENTION_TRAINING_ORDER           = new(:detention_training_order,         parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::DetentionCalculator),
    DETENTION                          = new(:detention,                        parent: CUSTODIAL_SENTENCE, calculator_class: Calculators::DetentionCalculator),

    ABSOLUTE_DISCHARGE                 = new(:absolute_discharge,               parent: DISCHARGE, skip_length: true, calculator_class: Calculators::ImmediatelyCalculator),
    CONDITIONAL_DISCHARGE              = new(:conditional_discharge,            parent: DISCHARGE, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),

    FINE                               = new(:fine,                             parent: FINANCIAL, skip_length: true, calculator_class: Calculators::AdditionCalculator::StartPlusSixMonths),
    COMPENSATION_TO_A_VICTIM           = new(:compensation_to_a_victim,         parent: FINANCIAL, compensation: true, calculator_class: Calculators::CompensationCalculator),

    HOSPITAL_ORDER                     = new(:hospital_order,                   parent: HOSPITAL_GUARD_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
    GUARDIANSHIP_ORDER                 = new(:guardianship_order,               parent: HOSPITAL_GUARD_ORDER, calculator_class: Calculators::AdditionCalculator::PlusZeroMonths),
  ].flatten.freeze

  # :nocov:
  def self.values
    VALUES
  end
  # :nocov:

  def children
    VALUES.select { |value| value.parent.eql?(self) }
  end
end
