require 'rails_helper'

RSpec.describe Project, type: :model do
  it { is_expected.to validate_presence_of :name }
  it { is_expected.to belong_to :team }
  it { is_expected.to have_many :releases }
  it { is_expected.to have_one :settings }

  describe 'unique scoped validation' do
    let(:project_1) { FactoryBot.create :project }
    let(:project_2) { FactoryBot.build :project, team: project_1.team }
    let(:project_3) { FactoryBot.build :project, team: project_1.team, name: 'New Project' }

    it 'will not allow to have same name if under same project' do
      expect(project_2.valid?).to eq(false)
      expect(project_3.valid?).to eq(true)
    end
  end
end
