require 'rails_helper'

RSpec.describe WebhooksController, type: :controller do
  before do
    basic_auth 'mark', '1234'
  end

  describe '#create' do
    let(:request_body) { { 'description': 'git pull request information', format: :json } }
    before do
      allow_any_instance_of(described_class).to receive(:verify_signature).and_return(true)
      allow(StoreGitMergeInformation).to receive(:call).and_return(true)
    end

    it 'returns an success response' do
      post :github, params: request_body, as: :json
      expect(response).to have_http_status(204)
    end

    it 'send the request body to the service to store info' do
      expect(StoreGitMergeInformation).to receive(:call)
      post :github, params: request_body, as: :json
    end
  end
end
