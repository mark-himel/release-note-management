require 'rails_helper'

RSpec.describe JiraTextParser, type: :model do
  let(:jira_text) { '*Hello World*' }
  let(:result) do
    VCR.use_cassette 'jira/parse_text' do
      described_class.call(jira_text)
    end
  end

  describe '.call' do
    it 'parses the jira formatted text into html' do
      expect(result). to eq('<p><b>Hello World</b></p>')
    end
  end
end
