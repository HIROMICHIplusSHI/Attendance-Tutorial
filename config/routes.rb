# config/routes.rb
Rails.application.routes.draw do
  root 'static_pages#top'
  
  # 認証関連（後でDeviseに置き換え可能）
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  resources :users do
    member do
      get 'edit_basic_info'
      patch 'update_basic_info'
    end
    
    # 勤怠関連
    resources :attendances, only: [:update] do
      collection do
        get 'edit_one_month'
        patch 'update_one_month'
      end
    end
  end

  # システム関連
  # ヘルスチェック用エンドポイント（本番環境・監視システム用）
  get "up" => "rails/health#show", as: :rails_health_check
  
  # Railway用追加ヘルスチェック（DB非依存）
  get '/health', to: proc { [200, {'Content-Type' => 'text/plain'}, ['Railway Health Check OK']] }
end
