Rails.application.routes.draw do

  # ルートページ
  root "static_pages#top"
  
  # 静的ページ
  get "static_pages/top"
  
  # ユーザー関連
  get '/signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  
   # ログイン機能
  get    '/login', to: 'sessions#new'
  post   '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # システム関連
  # ヘルスチェック用エンドポイント（本番環境・監視システム用）
  get "up" => "rails/health#show", as: :rails_health_check
end
