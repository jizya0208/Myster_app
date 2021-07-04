Rails.application.routes.draw do
  root 'homes#top'
  get 'homes/about'
  #「会員」
  devise_for :members
  resources :members, only: [:show, :edit, :update]
  
  #「口座」「口座履歴」「取引」
  resources :accounts, only: [:create] do
    resources :account_histories, only: [:new, :create, :index]
  end
  resources :transactions, only: [:create]
  
  #「投稿」とそれに紐づく「お気に入り」「コメント」「星評価」
  get 'articles/confirm' => "articles#confirm"
  resources :articles, except: [:edit] do
    resource  :favorites, only: [:create, :destroy]
    resources  :article_comments, only: [:create, :destroy] do
      resource :ratings, only: [:create, :update]
    end
  end
end
