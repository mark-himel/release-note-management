require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:github_user) { FactoryBot.create :user, :github }
  let(:signed_up_user) { FactoryBot.create :user, :signed_up, role: :admin }

  describe 'GET#new' do
    before do
      get :new
    end

    it 'assigns a new object into @user' do
      expect(assigns(:user)).to be_an_instance_of(User)
    end

    it 'renders new template' do
      expect(response).to render_template :new
    end
  end

  describe 'POST#create' do
    context 'when valid user' do
      let(:valid_user) { FactoryBot.attributes_for :user, :signed_up }

      it 'creates new user and sends confirmation email' do
        post :create, params: { user: valid_user }
        expect(ActionMailer::Base.deliveries).not_to be_empty
        expect(response).to redirect_to(Clearance.configuration.redirect_url)
      end

      it 'saves new user in the database' do
        expect { post :create, params: { user: valid_user } }.to change(User, :count).by(1)
      end

      it 'gives a flash message for user creation' do
        post :create, params: { user: valid_user }
        expect(flash[:notice]).to eq('User profile of Mark has been created')
      end
    end

    context 'when user is invalid' do
      let(:invalid_user) { FactoryBot.attributes_for :user, :signed_up, name: nil }

      it 'does not save a invalid user to database' do
        expect { post :create, params: { user: invalid_user } }.to change(User, :count).by(0)
      end

      it 'gives a flash message for invalid attribute' do
        post :create, params: { user: invalid_user }
        expect(flash[:error]).to eq("Name can't be blank")
      end

      it 'renders :new' do
        post :create, params: { user: invalid_user }
        expect(response).to render_template :new
      end
    end
  end
end
