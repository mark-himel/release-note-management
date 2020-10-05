require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  before do
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:github]
  end

  describe '#github' do
    context 'when verified with github' do
      before do
        allow_any_instance_of(GithubAuthorization).to receive(:role).and_return(0)
      end

      it 'successfully creates a user' do
        expect { get :github }.to change { User.count }.by(1)
      end

      it 'successfully signs in the user' do
        expect(controller.__send__(:current_user)).not_to be_present
        get :github
        expect(controller.__send__(:current_user)).to be_present
      end

      it 'redirects to dashboard path after sign in' do
        get :github
        expect(response).to redirect_to dashboard_path
      end
    end

    context 'when github verification failed' do
      before do
        allow(CreateUserFromOmniAuth).to receive(:call).and_return(nil)
      end

      it 'fails to create a user' do
        expect { get :github }.not_to change { User.count }
      end

      it 'sign in fails' do
        get :github
        expect(controller.__send__(:current_user)).not_to be_present
      end

      it 'redirects to root path as sign in failed' do
        get :github
        expect(response).to redirect_to root_path
      end
    end
  end

  describe '#destroy' do
    let(:user) { FactoryBot.create :user, :signed_up }

    before do
      sign_in_as user
    end

    it 'successfully signs out the user' do
      expect(controller.__send__(:current_user)).to eq(user)
      delete :destroy
      expect(controller.__send__(:current_user)).not_to be_present
    end

    it 'updates the user last seen at time' do
      expect { delete :destroy }.to change(user, :last_seen_at)
    end

    it 'redirects to root path' do
      delete :destroy
      expect(response).to redirect_to root_path
    end
  end
end
