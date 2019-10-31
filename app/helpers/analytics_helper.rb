module AnalyticsHelper
  CUSTOM_DIMENSIONS_MAP ||= {
    spent: :dimension1,
  }.freeze

  def analytics_tracking_id
    ENV['GA_TRACKING_ID']
  end

  def track_transaction(attributes)
    return unless current_disclosure_check.present?

    dimensions = custom_dimensions(
      attributes.delete(:dimensions)
    )

    content_for :transaction_data, {
      id: current_disclosure_check.id,
      sku: transaction_sku,
      quantity: 1,
    }.merge(
      attributes
    ).merge(
      dimensions
    ).to_json.html_safe
  end

  # We try to be as accurate as possible, but some transactions might
  # trigger before having reached the subtype step.
  def transaction_sku
    return 'unknown' unless current_disclosure_check&.kind

    current_disclosure_check.conviction_subtype ||
      current_disclosure_check.conviction_type ||
      current_disclosure_check.caution_type ||
      current_disclosure_check.kind
  end

  # Used for surveys, we return 'yes' or 'no' depending if we know
  # the current check is for under 18s or over 18s.
  def youth_check
    current_disclosure_check&.under_age.presence || 'unknown'
  end

  private

  # Custom dimensions on Google Analytics are named `dimensionX` where X
  # is an index from 1 to 20 (there is a limit of 20 per GA property).
  # https://support.google.com/analytics/answer/2709828?hl=en
  #
  def custom_dimensions(hash)
    dimensions = hash || {}

    CUSTOM_DIMENSIONS_MAP.each do |key, name|
      dimensions[name] = dimensions.delete(key) if dimensions.key?(key)
    end

    dimensions
  end
end
