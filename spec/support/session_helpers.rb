module SessionHelpers
  def log_in_as(user)
    # リクエストスペック用のログインヘルパー
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    allow_any_instance_of(ApplicationController).to receive(:logged_in?).and_return(true)
  end
end

RSpec.configure do |config|
  config.include SessionHelpers, type: :request
end