require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let!(:existing_disclosure_check) do
    DisclosureCheck.create(navigation_stack: navigation_stack)
  end

  before do
    allow(controller).to receive(:current_disclosure_check).and_return(existing_disclosure_check)
  end

  describe '#index' do
    context 'when an existing disclosure check in progress exists' do
      let(:status) { :in_progress }

      context 'with enough steps advanced' do
        let(:navigation_stack) { %w(/1 /2 /3) }

        context 'and user bypass the warning' do
          it 'responds with HTTP success' do
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }, params: {new: 'y'}
            expect(response).to be_successful
          end

          it 'resets the disclosure_check session data' do
            expect(session).to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).to receive(:delete).with(:last_seen).ordered
            expect(session).to receive(:delete) # any other deletes
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }, params: {new: 'y'}
          end
        end

        context 'and user do not bypass the warning' do
          it 'redirects to the warning page' do
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
            expect(response).to redirect_to(warning_reset_session_path)
          end

          it 'does not reset any application session data' do
            expect(session).not_to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).not_to receive(:delete).with(:last_seen).ordered
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
          end
        end
      end

      context 'with not enough steps advanced' do
        let(:navigation_stack) { %w(/1) }

        it 'responds with HTTP success' do
          get :index, session: { disclosure_check_id: existing_disclosure_check.id }
          expect(response).to be_successful
        end

        it 'resets the disclosure check session data' do
          expect(session).to receive(:delete).with(:disclosure_check_id).ordered
          expect(session).to receive(:delete).with(:last_seen).ordered
          expect(session).to receive(:delete) # any other deletes
          get :index
        end
      end
    end

    context 'when no disclosure check exists in session' do
      let!(:existing_disclosure_check) { nil }
      let(:navigation_stack) { [] }

      it 'responds with HTTP success' do
        get :index
        expect(response).to be_successful
      end

      it 'resets the disclosure_checker session data' do
        expect(session).to receive(:delete).with(:disclosure_check_id).ordered
        expect(session).to receive(:delete).with(:last_seen).ordered
        expect(session).to receive(:delete) # any other deletes
        get :index
      end
    end
  end
end
