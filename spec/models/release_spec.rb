require 'rails_helper'

RSpec.describe Release, type: :model do
  it { is_expected.to validate_presence_of :pr_reference }
  it { is_expected.to validate_presence_of :pr_title }
  it { is_expected.to validate_presence_of :pr_identifier }
  it { is_expected.to validate_presence_of :story_reference }
  it { is_expected.to validate_presence_of :story_number }
  it { is_expected.to validate_presence_of :description }
  it { is_expected.to validate_presence_of :date }
  it { is_expected.to belong_to :project }
  it { is_expected.to belong_to :assignee }

  let(:release) { FactoryBot.create :release }

  describe '#pull_request_information' do
    it 'concats the pull request identifier and the title' do
      expect(release.pull_request_information).to eq('#1 Hello World')
    end
  end
end
