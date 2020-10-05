require 'rails_helper'

RSpec.describe ProjectSettingsController, type: :controller do
  let(:user) { FactoryBot.create :user, :github, role: :deployer }
  let!(:setting) { FactoryBot.create :project_setting }

  before do
    sign_in_as user
  end

  describe '#edit' do
    before do
      get :edit, params: {
        team_id: setting.project.team,
        project_id: setting.project,
        id: setting.id
      }
    end

    it 'assigns team and project' do
      expect(assigns(:team)).to eq(setting.project.team)
      expect(assigns(:project)).to eq(setting.project)
    end

    it 'renders edit page' do
      expect(response).to render_template :edit
    end
  end

  describe '#update' do
    let(:common_params) do
      {
        team_id: setting.project.team,
        project_id: setting.project,
        id: setting
      }
    end
    let(:valid_params) do
      { project_setting: { git_repo_url: 'https://github.com/updated' } }
    end

    let(:invalid_params) do
      { project_setting: { git_repo_url: 'invalid_url' } }
    end

    context 'when parameters are valid' do
      subject { patch :update, params: common_params.merge(valid_params) }

      it 'successfully updates the attributes' do
        expect { subject }.
          to change { setting.reload.git_repo_url }.
          from('https://github.com').to('https://github.com/updated')
      end

      it 'updates and redirects to edit page again' do
        subject
        expect(response).
          to redirect_to edit_team_project_project_settings_path(setting.project.team, setting.project)
      end
    end

    context 'when parameters are invalid' do
      subject { patch :update, params: common_params.merge(invalid_params) }

      it 'does not update any attribute' do
        expect { subject }.to_not change { setting.reload.git_repo_url }
      end

      it 'fails update and renders edit page' do
        subject
        expect(response).to render_template :edit
      end
    end
  end
end
