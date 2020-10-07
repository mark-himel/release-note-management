require 'rails_helper'

RSpec.describe ProjectSettingsController, type: :controller do
  let(:user) { FactoryBot.create :user, :github, role: :deployer }
  let(:team) { FactoryBot.create :team }
  let(:project) { FactoryBot.create :project, team: team }

  before do
    sign_in_as user
  end

  describe '#edit' do
    before do
      get :edit, params: {
        team_id: team,
        project_id: project,
        id: project.settings.id
      }
    end

    it 'assigns team and project' do
      expect(assigns(:team)).to eq(team)
      expect(assigns(:project)).to eq(project)
    end

    it 'renders edit page' do
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    let(:common_params) do
      {
        team_id: team.id,
        project_id: project.id,
        id: project.settings.id
      }
    end
    let(:valid_params) do
      { project_setting: { git_repo_url: 'https://github.com/updated', jira_site: 'https://atlassian.net' } }
    end

    let(:invalid_params) do
      { project_setting: { git_repo_url: 'invalid_url', jira_site: 'invalid_url' } }
    end

    context 'when parameters are valid' do
      subject { patch :update, params: common_params.merge(valid_params) }

      it 'successfully updates the attributes' do
        expect { subject }.
          to change { project.settings.reload.git_repo_url }.
          from(nil).to('https://github.com/updated')
      end

      it 'updates and redirects to edit page again' do
        subject
        expect(response).
          to redirect_to edit_team_project_project_settings_path(team, project)
      end
    end

    context 'when parameters are invalid' do
      subject { patch :update, params: common_params.merge(invalid_params) }

      it 'does not update any attribute' do
        expect { subject }.to_not change { project.settings.reload.git_repo_url }
      end

      it 'fails update and renders edit page' do
        subject
        expect(response).to render_template :edit
      end
    end
  end
end
