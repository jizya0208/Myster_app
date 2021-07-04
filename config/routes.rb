Rails.application.routes.draw do
  get 'account_histories/new'
  get 'account_histories/index'
  get 'articles/confirm'
  get 'articles/index'
  get 'articles/new'
  get 'articles/show'
  get 'members/show'
  get 'members/edit'
  devise_for :members
  get 'homes/top'
  get 'homes/about'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
