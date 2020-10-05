require 'rails_helper'
RSpec.describe EmailConfirmationsController, type: :controller do
  let!(:user) do
    FactoryBot.create(:user, :signed_up, email_confirmation_token: 'valid_token', email_confirmed_at: nil)
  end
  describe '#confirm' do
    context 'with valid confirmation token' do
      before do
        get :confirm, params: { id: user.id, token: user.email_confirmation_token }
      end

      it 'updates email_confirmed_at field' do
        expect(user.reload.email_confirmed_at).not_to be_nil
      end

      it 'sets confirmation token to be an empty string' do
        expect(user.reload.email_confirmation_token).to be_nil
      end

      it 'redirects to sign in path' do
        expect(response).to redirect_to sign_in_path
      end
    end
  end
end
