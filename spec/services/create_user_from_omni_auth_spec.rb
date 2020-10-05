require 'rails_helper'

RSpec.describe CreateUserFromOmniAuth do
  describe '.call' do
    let(:auth_hash) { OmniAuth.config.mock_auth[:github] }
    subject { described_class.call(auth_hash) }

    before do
      allow_any_instance_of(GithubAuthorization).to receive(:role).and_return(0)
    end

    context 'when authentication is valid' do
      it 'finds or creates the user from a given auth hash' do
        expect { subject }.to change { User.count }.by(1)
      end
    end

    context 'when authentication is not valid' do
      let(:error) { RuntimeError.new('Ooops') }
      before do
        allow_any_instance_of(User).to receive(:save!).and_raise(error)
      end

      it 'rescues and returns nil' do
        expect(subject).to eq(nil)
      end

      it 'reports to rollbar' do
        expect(ErrorReporter).to receive(:error).with(error, github_username: 'mark-himel')
        subject
      end
    end
  end
end
