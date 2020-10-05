require 'rails_helper'

RSpec.describe ProjectsController, type: :controller do
  let(:team) { FactoryBot.create(:team) }
  let(:project) { FactoryBot.create(:project, team: team) }
  let(:user) { FactoryBot.create(:user, :github, role: :deployer) }

  before do
    sign_in_as(user)
  end

  describe 'GET #Index' do
    before do
      get :index, params: { team_id: team.id }
    end

    it 'returns http success' do
      expect(response.status).to eq 200
    end

    it 'renders the :index' do
      expect(response).to render_template(:index)
    end

    it 'assigns @projects to project' do
      expect(assigns(:projects)).to eq([project])
    end
  end

  describe 'GET #show' do
    context 'when valid attributes' do
      before do
        get :show, params: { team_id: project.team.id, id: project.id }
      end
      it 'assigns the requested project to @project' do
        expect(assigns(:project)).to eq(project)
      end

      it 'renders templete :show' do
        expect(response).to render_template :show
      end
    end
  end

  describe 'GET #new' do
    before do
      get :new, params: { team_id: team.id }
    end
    it 'assigns new project to @project' do
      expect(assigns(:project)).to be_a_new(Project)
    end
    it 'renders the :new template' do
      expect(response).to render_template :new
    end
  end

  describe 'Post #create' do
    context 'with valid attributes' do
      let(:valid_params) { FactoryBot.attributes_for(:project, team_id: team.id) }

      it 'creates project' do
        expect { post :create, params: { team_id: team.id, project: valid_params } }.
          to change(Project, :count).by(1)
      end

      it 'creates a settings for the project' do
        expect { post :create, params: { team_id: team.id, project: valid_params } }.
          to change(ProjectSetting, :count).by(1)
      end

      it 'then redirects to the project page' do
        post :create, params: { team_id: team.id, project: valid_params }
        expect(response).to redirect_to team_project_path(team, team.projects.last)
      end
      it 'flash msg if successfully created' do
        post :create, params: { team_id: team.id, project: valid_params }
        expect(flash[:notice]).to match 'Project has been created successfully'
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { FactoryBot.attributes_for(:project, name: nil, team_id: team.id) }

      it 'fails to create' do
        expect {
          post :create, params: { team_id: team.id, project: invalid_params }
        }.to change(Project, :count).by(0)
      end
      it 'then renders the new template' do
        post :create, params: { team_id: team.id, project: invalid_params }
        expect(response).to render_template :new
      end
      it 'flash msg if not successfully created' do
        post :create, params: { team_id: team.id, project: invalid_params }
        expect(flash[:error]).to match 'Project has not been created successfully'
      end
    end

  end

  describe 'Patch #Update' do
    context 'with valid attributes' do
      let(:valid_params) { FactoryBot.attributes_for(:project,name:'Java', team_id: team.id) }

      before do
        patch :update, params: { team_id: team.id, id: project.id, project: valid_params }
      end

      it 'changes projects attributes' do
        project.reload
        expect(project.name).to eq('Java')
      end

      it 'then redirects to the show' do
        expect(response).to redirect_to(team_project_path(team, project))
      end
      it 'flash msg if successfully updated' do
        expect(flash[:notice]).to match 'Project has been updated successfully'
      end
    end

    context 'with invalid attributes' do
      let(:invalid_params) { FactoryBot.attributes_for(:project, name:nil , team_id: team.id) }

      before do
        patch :update, params: { team_id: team.id, id: project.id, project: invalid_params }
      end

      it 'fails to update projects attributes' do
        project.reload
        expect(project.name).to eq('Agent')
      end
      it 'then renders to the edit' do
        expect(response).to render_template :edit
      end
      it 'flash msg if successfully not updated' do
        expect(flash[:error]).to match 'Project has not been updated successfully'
      end
     end
  end

  describe 'DELETE #destroy' do
    context 'when id exists' do
      before do
        delete :destroy, params: { team_id: team.id, id: project.id }
      end

      it 'deletes the project' do
        expect change(Project, :count).by(-1)
      end

      it 'deletes the settings associated with the project' do
        expect change(ProjectSetting, :count).by(-1)
      end

      it 'redirect to the index' do
        expect(response).to redirect_to(team_projects_path(team))
      end

      it 'flash msg if successfully deleted ' do
        expect(flash[:notice]).to match 'Project has been deleted successfully'
      end
    end

    context 'when id does not exist' do
      it 'does not delete anything' do
        expect { delete :destroy, params: { team_id: team.id, id: -1 } }.to_not change(Project, :count)
      end

      it 'reports to rollbar' do
        expect(ErrorReporter).to receive(:call)
        delete :destroy, params: { team_id: team.id, id: -1 }
      end

      it 'renders error template' do
        delete :destroy, params: { team_id: team.id, id: -1 }
        expect(JSON.parse(response.body)['status']).to eq(404)
      end
    end
  end
end
