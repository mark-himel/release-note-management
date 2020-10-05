require 'rails_helper'
require 'cancan/matchers'
RSpec.describe Ability, type: :model do
  describe 'Abilities' do
    subject(:ability) { described_class.new(user) }

    context 'when user is admin' do
      let!(:user) do
        FactoryBot.create(:user, role: :admin)
      end

      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'when user is deployer' do
      let!(:user) do
        FactoryBot.create(:user, role: :deployer)
      end

      it { is_expected.to be_able_to(:manage, :all) }
    end

    context 'when user is viewer' do
      let!(:user) do
        FactoryBot.create :user
      end

      it { is_expected.not_to be_able_to(:manage, Team) }
      it { is_expected.not_to be_able_to(:manage, Release) }
      it { is_expected.not_to be_able_to(:manage, Project) }
      it { is_expected.not_to be_able_to(:manage, ProjectSetting) }
      it { is_expected.to be_able_to(:read, :all) }
    end
  end
end
