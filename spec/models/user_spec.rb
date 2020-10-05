require 'rails_helper'

RSpec.describe User, type: :model do
  it { is_expected.to define_enum_for(:role).with_values(%i(admin deployer viewer)) }
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to validate_presence_of :email }
  it { is_expected.to validate_presence_of :role }

  describe 'validation of github' do
    context 'when the username is valid' do
      let(:valid_git_username) { FactoryBot.build(:user, github_username: 'mmo-wtag') }

      it 'validates the user valid' do
        expect(valid_git_username.valid?).to eq true
      end
    end

    context 'when the username is invalid' do
      let(:invalid_git_username) { FactoryBot.build(:user, github_username: 'mmo_wtag') }

      it 'validates the user valid' do
        expect(invalid_git_username.valid?).to eq false
      end
    end
  end
end
