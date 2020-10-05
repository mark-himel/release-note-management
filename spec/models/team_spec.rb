require 'rails_helper'

RSpec.describe Team, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to have_many :projects }

  describe 'uniqueness' do
    let(:team) { FactoryBot.build :team }
    let(:duplicate_team) { FactoryBot.build :team }

    it 'allows names those are not duplicated' do
      expect(team.valid?).to eq(true)
      team.save!
      expect(duplicate_team.valid?).to eq(false)
    end
  end
end
