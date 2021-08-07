Rails.application.routes.draw do
  get 'contact/index'
  get 'contact/confirm'
  get 'contact/thanks'
  root 'homes#top'
  get 'article/tag/:name' => 'articles#tag'

  # 「会員」
  devise_scope :member do # ゲストログイン
    post 'members/guest_sign_in' => 'members/sessions#guest_login'
  end
  get 'members/unsubscribe' => 'members#unsubscribe', as: 'confirm_unsubscribe'
  patch 'members/withdraw' => 'members#withdraw', as: 'withdraw_member'

  devise_for :members, controllers: {
    sessions: 'members/sessions',
    registrations: 'members/registrations'
  }
  resources :members, only: %i[show edit update] do
    resource :relationships, only: %i[create destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end

  # 「口座」「口座履歴」「取引」
  resources :accounts, only: [:create] do
    resources :account_histories, only: %i[new create index]
    post '/accounts/account_histories/charge' => 'account_histories#charge', as: 'charge'
  end
  resources :transactions, only: [:create]

  # 「投稿」とそれに紐づく「お気に入り」「コメント」「星評価」
  get 'articles/questions' => 'articles#questions', as: 'questions'
  resources :articles, except: [:edit] do
    collection do
      get 'search'
    end
    resources :article_images
    resource  :favorites, only: %i[create destroy]
    resources :article_comments, only: %i[create destroy show] do
      resource :ratings, only: %i[create update]
    end
  end
  # 通知
  resources :notifications, only: :index
  delete 'destroy_all_members_notifications' => 'notifications#destroy_all'

  # 問合せ
  get   'contacts' => 'contact#index' # 入力画面
  post  'contact/confirm' => 'contact#confirm', as: 'confirm'   # 確認画面
  post  'contact/thanks'  => 'contact#thanks', as: 'thanks'    # 送信完了画面
end
