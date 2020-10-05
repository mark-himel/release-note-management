require 'rails_helper'

RSpec.describe StoreGitMergeInformation, type: :model do
  let(:team) { FactoryBot.create :team }
  let!(:user) { FactoryBot.create :user, :github }
  let!(:project) { FactoryBot.create :project, team: team, name: 'University' }
  let(:project_settings_attributes) do
    {
      git_repo_url: 'https://github.com/wtag/university',
      git_repo_identifier: 'university',
      git_release_branch: 'master',
      jira_username: 'mark.mondol@welldev.io',
      jira_api_token: ENV['JIRA_API_TOKEN'],
      jira_site: 'https://welltravel.atlassian.net',
      jira_project_slug: 'UM'
    }
  end
  let(:information_hash) do
    {
      pull_request: {
        merged_at: DateTime.now,
        head: {
          repo: {
            owner: {
              login: 'wtag'
            },
            name: 'university'
          },
          ref: 'UM-10-guinea-pig-experiment'
        },
        html_url: 'https://github.com/wtag/release-note-management/pull/9',
        body: '[Story](https://welltravel.atlassian.net/browse/UM-10)',
        title: 'Story to test Webhooks for our Release App',
        number: '9',
        user: {
          login: 'mmo-wtag'
        }
      }
    }.with_indifferent_access
  end

  before do
    project.settings.update!(project_settings_attributes)
    allow(JiraTextParser).to receive(:call).and_return('Got it!')
  end

  subject do
    VCR.use_cassette 'jira/fetch_story_details' do
      described_class.call(information_hash)
    end
  end

  context 'when pull request event is merged' do
    it 'creates a new release' do
      expect { subject }.to change { Release.count }.from(0).to(1)
    end
  end

  context 'when pull request event is not merged' do
    before do
      information_hash['pull_request']['merged_at'] = nil
    end

    it 'does not create any release' do
      expect { subject }.to_not change { Release.count }
    end
  end

  context 'when release already in the system' do
    before do
      subject
    end

    it 'does not create another release' do
      expect_any_instance_of(described_class).to_not receive(:create_release)
      subject
      expect(Release.count).to eq(1)
      expect(Release.last.story_reference).
        to eq('https://welltravel.atlassian.net/browse/UM-10')
      expect(Release.last.pr_title).
        to eq('Story to test Webhooks for our Release App')
    end
  end
end
