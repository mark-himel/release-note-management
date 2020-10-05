require 'rails_helper'

RSpec.describe GithubAuthorization do
  subject do
    VCR.use_cassette 'github_authorization/valid' do
      described_class.new('mmo-wtag', Global.github.access_token).role
    end
  end

  describe '#role' do
    it 'returns the role of the github user' do
      expect(subject).to eq(2)
    end

    it 'requests github twice to fetch the team members list' do
      expect_any_instance_of(described_class).to receive(:team_member?).twice
      subject
    end

    it 'requests github once to fetch the organization members list' do
      expect_any_instance_of(described_class).to receive(:organization_member?).once
      subject
    end
  end
end
