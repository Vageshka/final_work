Rails.application.routes.draw do
  get 'session/new'
  post 'session/create'
  delete 'session/destroy'

  root 'main#index'

  get 'main/new'
  post 'main/create'

  get 'main/companies'
#  get 'main/comp_show'

  get 'main/students'
  get 'main/all_companies'
  post 'main/offer_to_company/:id', to: "main#offer_to_company"
  post 'main/all_companies/:id', to: "main#company_discibtion"
  get 'main/choosed_companies'
  post 'main/cancel_offer/:id', to: "main#cancel_offer"
#  get 'main/stud_show'

  get 'main/edit'
  post 'main/edit', to: "main#update"

  get 'main/files/:id', to: "main#get_file", as: 'files'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  get 'main/all_db'
end
