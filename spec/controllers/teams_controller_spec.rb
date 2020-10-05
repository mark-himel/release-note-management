require 'rails_helper'
RSpec.describe TeamsController, type: :controller do
  let!(:team) { FactoryBot.create(:team) }
  let(:user) { FactoryBot.create :user, :github, role: :deployer }

  before do
    sign_in_as user
  end

  describe "GET #index" do
    before do
      get :index
    end
    it 'returns http success' do
      expect(response.status).to eq 200
    end
    it "assigns @team to Team" do
      expect(assigns(:teams)).to eq([team])
    end
    it "renders the index template" do
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    before do
      get :show, params: { id: team.id }
    end
    it "renders the show template" do
      expect(response).to render_template :show
    end
    it 'assigns selected Team to @team' do
      expect(assigns(:team)).to eq (team)
    end
  end

  describe 'GET #new' do
    before do
      get :new
    end
    it "renders the new template" do
      expect(response).to render_template :new
    end
    it 'assigns new Team to @team' do
      expect(assigns(:team)).to be_a_new(Team)
    end
  end

  describe 'POST #create' do
    let(:team) { FactoryBot.build(:team) }

    context 'when attributes are valid' do
      let(:valid_params) { FactoryBot.attributes_for(:team) }
      it 'creates team' do
        expect {
          post :create, params: { team: valid_params }
        }.to change(Team, :count).by(1)
      end
      it 'then redirects to index' do
        post :create, params: { team: valid_params }
        expect(response).to redirect_to(teams_path(assigns(:team)))
      end
      it 'shows flash success message' do
        post :create, params: { team: valid_params }
        expect(flash[:notice]).to eq I18n.t('shared.created', resource: Team.model_name.human)
      end
    end

    context 'when attributes are invalid' do
      let(:invalid_params) { FactoryBot.attributes_for(:team, name: nil) }
      it 'fails to create team' do
        expect {
          post :create, params: { team: invalid_params }
        }.not_to change(Team, :count)
      end
      it 'then renders to new method' do
        post :create, params: { team: invalid_params }
        expect(response).to render_template :new
      end
      it 'shows flash error message' do
        post :create, params: { team: invalid_params }
        expect(flash[:error]).to eq I18n.t('shared.not_created', resource: Team.model_name.human)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when id is present' do
      before do
        delete :destroy, params: { id: team.id }
      end
      it 'decreases team count by -1' do
        expect change(Team, :count).by(-1)
      end
      it 'then redirects to index' do
        expect(response).to redirect_to teams_path
      end
      it 'shows flash success message' do
        expect(flash[:notice]).to eq I18n.t('shared.deleted', resource: Team.model_name.human)
      end
    end

    context 'when id does not exist' do
      it 'does not delete anything' do
        expect { delete :destroy, params: { id: -1 } }.to_not change(Project, :count)
      end

      it 'reports to rollbar' do
        expect(ErrorReporter).to receive(:call)
        delete :destroy, params: { id: -1 }
      end

      it 'renders error template' do
        delete :destroy, params: { id: -1 }
        expect(JSON.parse(response.body)['status']).to eq(404)
      end
    end
  end

  describe 'PATCH #update' do

    context 'when attributes are valid' do
      let(:valid_params) { FactoryBot.attributes_for(:team, name:'Java') }
      it 'updates Team information' do
        patch :update, params: { id: team.id, team: valid_params }
        team.reload
        expect(team.name).to eq('Java')
      end
      it 'then redirects to show' do
        patch :update, params: { id: team.id, team: valid_params }
        expect(response).to redirect_to(team_path)
      end
      it 'shows flash success message' do
        patch :update, params: { id: team.id, team: valid_params }
        expect(flash[:notice]).to eq I18n.t('shared.updated', resource: Team.model_name.human)
      end
    end

    context 'when attributes are invalid' do
      let(:invalid_params) { FactoryBot.attributes_for(:team, name: nil) }
      it 'fails to update projects attributes' do
        patch :update, params: { id: team.id, team: invalid_params }
        team.reload
        expect(team.name).to_not eq('WellTravel')
      end
      it 'then renders to edit' do
        patch :update, params: { id: team.id, team: { name: nil } }
        expect(response).to render_template :edit
      end
      it 'shows flash error message' do
        patch :update, params: { id: team.id, team: invalid_params }
        expect(flash[:error]).to eq I18n.t('shared.not_updated', resource: Team.model_name.human)
      end
    end
  end
end
