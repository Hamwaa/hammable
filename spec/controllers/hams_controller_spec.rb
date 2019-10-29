require 'rails_helper'

RSpec.describe HamsController, type: :controller do
  describe "hams#show action" do
    it "should successfully show the page if the ham is found" do
      ham = FactoryBot.create(:ham)
      get :show, params: { id: ham.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the ham is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_stuts(:not_found)
    end
  end

  describe "hams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "hams#new action" do
    it "shoud require users to be logged in" do
      post :create, params: { ham: { message: "Hello!" } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the new form" do
      user = FactoryBot.create(:user)
      sign_in user
      
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "hams#create action" do
    it "should successfully create a new ham in our database" do
      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { ham: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      ham = Ham.last
      expect(ham.message).to eq("Hello!")
      expect(ham.user).to eq(user)
    end
  end

  it "should properly deal with validation errors" do
      user = FactoryBot.create(:user)
      sign_in user

    ham_count = Ham.count 
    post :create, params: { ham: { message: '' } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(ham_count).to eq Ham.count
  end


end
