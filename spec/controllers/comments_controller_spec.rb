require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "comments#create action" do
    it "should allow users to create comments on hams" do
      ham = FactoryBot.create(:ham)

      user = FactoryBot.create(:user)
      sign_in user

      post :create, params: { ham_id: ham.id, comment: { message: 'awesome ham' } }
    
      expect(response).to redirect_to root_path
      expect(ham.comments.length).to eq 1
      expect(ham.comments.first.message).to eq "awesome ham"
    end

    it "should require a user to be logged in to comment on a ham" do
      ham = FactoryBot.create(:ham)
      post :create, params: { ham_id: ham.id, comment: { message: 'awesome ham' } }
      expect(response).to redirect_to new_user_session_path
    end

    it "should return http status code of not found if the ham isn't found" do
      user = FactoryBot.create(:user)
      sign_in user
      post :create, params: { ham_id: 'YOLOSWAG', comment: { message: 'awesome ham' } }
      expect(response).to have_http_status :not_found
    end
  end
end
