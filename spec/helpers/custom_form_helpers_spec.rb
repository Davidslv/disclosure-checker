require 'rails_helper'

RSpec.describe CustomFormHelpers, type: :helper do
  let(:form_object) { double('FormObject') }

  let(:builder) do
    GOVUKDesignSystemFormBuilder::FormBuilder.new(
      :disclosure_check,
      form_object,
      self,
      {}
    )
  end

  describe '#continue_button' do
    let(:expected_markup) { '<input type="submit" name="commit" value="Continue" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true" data-disable-with="Continue" />' }
    let(:template) { double('template', params: params) }

    before do
      allow(builder).to receive(:template).and_return(template)
    end

    context 'when there is no next step param' do
      let(:params) { {} }

      it 'outputs the govuk continue button without the next step hidden tag' do
        expect(
          builder.continue_button
        ).to eq(expected_markup)
      end
    end

    context 'when the next step param is not recognised' do
      let(:params) { {next_step: 'foobar'} }

      it 'outputs the govuk continue button without the next step hidden tag' do
        expect(
          builder.continue_button
        ).to eq(expected_markup)
      end
    end

    context 'where there is a valid next step param' do
      let(:params) { {next_step: 'cya'} }

      it 'outputs the govuk continue button with the next step hidden tag' do
        expect(
          template
        ).to receive(:hidden_field_tag).with(
          :next_step, '/steps/check/check_your_answers'
        ).and_return('<hidden_tag_here>'.html_safe)

        expect(
          builder.continue_button
        ).to eq('<hidden_tag_here>' + expected_markup)
      end
    end
  end

  describe '#i18n_caption' do
    before do
      allow(form_object).to receive(:conviction_subtype).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        :foobar, scope: [:helpers, :caption, :disclosure_check]
      )

      builder.i18n_caption
    end
  end

  describe '#i18n_legend' do
    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        :foobar, scope: [:helpers, :legend, :disclosure_check], default: :default
      )

      builder.i18n_legend
    end
  end

  describe '#i18n_hint' do
    let(:found_locale) { double('locale') }

    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        'foobar_html', scope: [:helpers, :hint, :disclosure_check], default: :default_html
      ).and_return(found_locale)

      expect(found_locale).to receive(:html_safe)

      builder.i18n_hint
    end
  end

  describe '#i18n_lead_text' do
    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it 'seeks the expected locale key' do
      expect(I18n).to receive(:t).with(
        :foobar, scope: [:helpers, :lead_text, :disclosure_check], default: :default
      )

      builder.i18n_lead_text
    end
  end
end
