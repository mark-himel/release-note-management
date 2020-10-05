class User < ApplicationRecord
  include Clearance::User

  GITHUB_USERNAME_REGEX = /\A[a-z\d](?:[a-z\d]|-(?=[a-z\d])){0,38}\Z/i.freeze

  enum role: { admin: 0, deployer: 1, viewer: 2 }

  validates :github_username,
            uniqueness: { case_sensitive: false },
            format: GITHUB_USERNAME_REGEX, allow_blank: true
  validates :name, :email, :role, presence: true
  validates :email, presence: true, uniqueness: true
  validates_format_of :email, with: /\A[^@\s]+@([^@\s]+\.)+[^@\s]+\z/
  validates :password, length: { minimum: 6 }, allow_blank: true

  def password_optional?
    true
  end
end
