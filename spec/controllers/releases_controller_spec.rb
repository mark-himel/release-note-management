require 'rails_helper'

RSpec.describe ReleasesController, type: :controller do
  let(:team) { FactoryBot.create(:team) }
  let(:project) { FactoryBot.create(:project, team: team) }
  let(:user) { FactoryBot.create(:user, :github, role: :deployer) }
  let!(:release) { FactoryBot.create :release, project: project, assignee: user }

  before do
    sign_in_as(user)
  end

  describe '#index' do
    it 'lists all the releases under a project' do
      get :index, params: { team_id: team.id, project_id: project.id }
      expect(assigns(:releases)).to eq([release])
    end
  end

  describe '#edit' do
    it 'assigns the release into the variable' do
      get :edit, params: { team_id: team.id, project_id: project.id, id: release.id }
      expect(assigns(:release)).to eq(release)
    end
  end

  describe '#update' do
    let(:valid_params) do
      {
        team_id: team.id,
        project_id: project.id,
        id: release.id,
        release: { description: 'Changed release' }
      }
    end
    let(:invalid_params) do
      {
        team_id: team.id,
        project_id: project.id,
        id: release.id,
        release: { story_reference: 'invalid/link' }
      }
    end

    context 'when it is only the description' do
      it 'successfully updates the description' do
        expect do
          post :update, params: valid_params
        end.to change { release.reload.description }.from('This is a release').to('Changed release')
      end
    end

    context 'when it is other than description' do
      it 'does not update anything' do
        expect do
          post :update, params: invalid_params
        end.to_not change { release.reload.story_reference }
      end
    end
  end
end
