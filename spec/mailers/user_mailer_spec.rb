require 'rails_helper'

RSpec.describe UserMailer, type: :mailer do
  let!(:user) do
    FactoryBot.create(:user, :signed_up,
                      email: 'user105@example.com',
                      email_confirmation_token: 'valid_token',
                      email_confirmed_at: nil)
  end
  describe '#sign_up_confirmation' do
    let(:mail) { UserMailer.sign_up_confirmation(user) }

    it 'renders the subject' do
      expect(mail.subject).to eq('Registration Confirmation')
    end

    it 'renders the receiver email' do
      expect(mail.to).to eq([user.email])
    end
  end
end
