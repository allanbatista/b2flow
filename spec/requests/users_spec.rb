require 'rails_helper'

describe 'Users', :type => :request do
  before do
    @user = FactoryBot.create(:user)
  end

  context 'GET /me' do
    it 'should authentication fail' do
      get me_users_path

      expect(response.status).to eq(401)
    end

    it "should authenticate with success" do
      get me_users_path, headers: { 'x-auth-token' => @user.to_token }

      user = JSON.parse(response.body)

      expect(response.status).to eq(200)
      expect(user['id']).to eq(@user.id.to_s)
      expect(user['email']).to eq(@user.email)
      expect(user['created_at']).to eq(@user.created_at.strftime("%FT%T.%L%z"))
      expect(user['updated_at']).to eq(@user.updated_at.strftime("%FT%T.%L%z"))
    end
  end
end