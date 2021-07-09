Rails.application.routes.draw do
  root 'homes#top'
  get 'homes/about'
  get "search_in_shares" => "homes#search_in_shares"
  get "search_in_inquiries" => "homes#search_in_inquiries"

  #「会員」
  devise_for :members, controllers: {
    sessions: 'members/sessions',
    registrations: 'members/registrations'
  }
  resources :members, only: [:show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  #「口座」「口座履歴」「取引」
  resources :accounts, only: [:create] do
    resources :account_histories, only: [:new, :create, :index]
  end
  resources :transactions, only: [:create]

  #「投稿」とそれに紐づく「お気に入り」「コメント」「星評価」
  get 'articles/inquirings' => "articles#inquire", as: 'inquire'
  resources :articles, except: [:edit] do
    resources :article_images
    resource  :favorites, only: [:create, :destroy]
    resources :article_comments, only: [:create, :destroy, :show] do
      resource :ratings, only: [:create, :update]
    end
  end
end
