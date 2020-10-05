require 'rails_helper'

RSpec.describe ProjectSetting, type: :model do
  it { is_expected.to belong_to :project }

  let(:setting) { FactoryBot.build :project_setting }

  describe 'jira username validation' do
    context 'when it is not an email' do
      before do
        setting.jira_username = 'mark'
      end
      it 'returns as invalid' do
        expect(setting.valid?).to eq(false)
      end
    end

    context 'when it is an email' do
      it 'returns as valid' do
        expect(setting.valid?).to eq(true)
      end
    end

    context 'when it is not provided' do
      before do
        setting.jira_username = nil
      end
      it 'avoids validation thus is valid' do
        expect(setting.valid?).to eq(true)
      end
    end
  end

  describe 'url validations' do
    context 'when url is valid' do
      it 'does not add any errors' do
        setting.valid?
        expect(setting.errors.messages).to eq({})
      end
    end

    context 'when url is invalid' do
      let(:error_hash) do
        {
          git_repo_url: ['invalid url'],
          jira_site: ['invalid url'],
        }
      end
      before do
        setting.git_repo_url = 'a.com'
        setting.jira_site = 'b.com'
      end

      it 'adds error messages' do
        setting.valid?
        expect(setting.errors.messages).to eq(error_hash)
      end
    end
  end
end
