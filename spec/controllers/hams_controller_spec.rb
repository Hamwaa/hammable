require 'rails_helper'

RSpec.describe HamsController, type: :controller do
  describe "hams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end


  describe "hams#new action" do
    it "should successfully show the new form" do
      get :new
      expect(response).to have_http_status(:success)
    end
  end

  describe "hams#create action" do
    it "should successfully create a new ham in our database" do
      post :create, params: { ham: { message: 'Hello!' } }
      expect(response).to redirect_to root_path

      ham = Ham.last
      expect(ham.message).to eq("Hello!")
    end
  end

  it "should properly deal with validation errors" do
    post :create, params: { ham: { message: '' } }
    expect(response).to have_http_status(:unprocessable_entity)
    expect(Gram.count).to eq 0
  end


end
