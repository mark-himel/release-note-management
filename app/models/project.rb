class Project < ApplicationRecord
  validates :name, presence: true, uniqueness: { scope: :team_id }

  belongs_to :team
  has_many :releases
  has_one :settings, class_name: 'ProjectSetting', dependent: :destroy

  after_create :create_settings

  private

  def create_settings
    ProjectSetting.create!(project: self)
  end
end
