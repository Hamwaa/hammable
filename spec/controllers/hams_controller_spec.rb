require 'rails_helper'

RSpec.describe HamsController, type: :controller do

  describe "hams#destroy action" do
    it "shouldn't allow users who did not create teh ham to destroy it" do
      ham = FactoryBot.create(:ham)
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: ham.id }
      expect(response).to have_http_status(:forbidden)  
    end

    it "shouldn't let unauthenticated users destroy a ham" do
      ham = FactoryBot.create(:ham)
      delete :destroy, params: { id: ham.id }
      expect(response).to redirect_to new_user_session_path
    end


    it "should allow a user to destroy hams" do
      ham = FactoryBot.create(:ham)
      sign_in ham.user
      delete :destroy, params: { id: ham.id }
      expect(response).to redirect_to root_path
      ham = Ham.find_by_id(ham.id)
      expect(ham).to eq nil
    end

    it "should return a 404 message if we cannot find a ham with the id that is specified" do |variable|
      user = FactoryBot.create(:user)
      sign_in user
      delete :destroy, params: { id: 'Murph' }
      expect(response).to have_http_status(:not_found)
    end
  end



  describe "hams#update action" do
    it "shouldn't let users who didn't create teh ham to update the ham" do
      ham = FactoryBot.create(:ham)
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: ham.id, ham: { message: 'Wahoo' } }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users update a ham" do
      ham = FactoryBot.create(:ham)
      patch :update, params: { id: ham.id, ham: { message: "Hello" } }
      expect(response).to redirect_to new_user_session_path
    end


    it "should allow users to succeslly update hams" do
      ham = FactoryBot.create(:ham, message: "Initail Value")
      sign_in ham.user
      patch :update, params: { id: ham.id, ham: { message: 'Changed' } }
      expect(response).to redirect_to root_path
      ham.reload
      expect(ham.message).to eq "Changed"
    end

    it "should have http 404 error if the ham cannot be found" do
      user = FactoryBot.create(:user)
      sign_in user
      patch :update, params: { id: "YOLOSWAG", ham: { message: 'Changed' } }
      expect(response).to have_http_status(:not_found)
      
    end

    it "should render the edit form with an http status of unprocessable_entity" do 
      ham = FactoryBot.create(:ham, message: "Initial Value")
      sign_in ham.user

      patch :update, params: { id: ham.id, ham: { message: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      ham.reload
      expect(ham.message).to eq "Initial Value"
    end
  end



  describe "hams#edit action" do
    it "shouldn't let a user who did not create the ham edit the ham" do
      ham = FactoryBot.create(:ham)
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: ham.id }
      expect(response).to have_http_status(:forbidden)
    end

    it "shouldn't let unauthenticated users edit a ham" do
      ham = FactoryBot.create(:ham)
      get :edit, params: { id: ham.id }
      expect(response).to redirect_to new_user_session_path
    end

    it "should successfully show the edit form if the has is found" do
      ham = FactoryBot.create(:ham)
      sign_in ham.user
      get :edit, params: { id: ham.id}
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error message if the ham is not found" do 
      user = FactoryBot.create(:user)
      sign_in user
      get :edit, params: { id: 'SWAG'}
      expect(response).to have_http_status(:not_found)
    end
  end


  describe "hams#show action" do
    it "should successfully show the page if the ham is found" do
      ham = FactoryBot.create(:ham)
      get :show, params: { id: ham.id }
      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the ham is not found" do
      get :show, params: { id: 'TACOCAT' }
      expect(response).to have_http_status(:not_found)
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

      post :create, params: { 
        ham: {
          message: 'Hello!',
          picture: fixture_file_upload("/picture.png", 'image/png')
        } 
      }


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
