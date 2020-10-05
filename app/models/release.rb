class Release < ApplicationRecord
  validates :pr_reference, :pr_identifier, :pr_title,
            :story_reference, :story_number,
            :description,
            :date, presence: true
  enum state: { pending: 0, ready: 1, approved: 2, rejected: 3, deployed: 4 }

  belongs_to :project
  belongs_to :assignee,
             class_name: 'User',
             foreign_key: :user_id

  def pull_request_information
    "##{pr_identifier} #{pr_title}"
  end
end
