FactoryBot.define do
  factory :release do
    project
    association :assignee, factory: :user
    state { 0 }
    pr_reference { 'https://github.com/a/b/pull/1' }
    pr_title { 'Hello World' }
    pr_identifier { '1' }
    story_reference { 'jira/link' }
    story_number { 'link-1' }
    description { 'This is a release' }
    date { Date.today }
  end
end
