# spec/requests/users_spec.rb
require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe 'FactoryBot動作確認' do
    let(:user) { create(:user) }
    
    it "ユーザーが正常に作成される" do
      expect(user.name).to include("Test User")
      expect(user.email).to include("@test.com")
      expect(user.password).to eq("password123")
    end
    
    it "複数のユーザーが作成される" do
      users = create_list(:user, 3)
      expect(users.length).to eq(3)
      expect(users.first.name).to include("Test User")
    end
  end

  describe 'FactoryBot高度なテスト' do
    it "5件のユーザーを正確に作成して属性を確認" do
      users = create_list(:user, 5)
      
      expect(users.length).to eq(5)
      
      # 全ユーザーの属性をチェック
      users.each do |user|
        expect(user.name).to include("Test User")
        expect(user.email).to include("@test.com")
        expect(user.password).to eq("password123")
        expect(user.department).to eq("技術部")
        expect(user.admin).to eq(false)
        expect(user).to be_valid
      end
    end
  end
end
