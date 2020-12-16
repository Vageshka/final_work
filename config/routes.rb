Rails.application.routes.draw do
  scope '(:locale)', locale: /en|ru/ do
    get 'session/new'
    post 'session/create'
    delete 'session/destroy'

    root 'main#index'

    get 'main/new'
    post 'main/create'

    get 'main/companies'
    get 'main/all_applications'
    post 'main/all_applications/:id', to: 'main#student_description', as: 'student_description'
    post 'main/accept_offer/:id', to: 'main#accept_offer', as: 'accept_offer'
    get 'main/pending_confirmations'
    post 'main/cancel_acceptance/:id', to: 'main#cancel_acceptance', as: 'cancel_acceptance'
    get 'main/approved'

    get 'main/students'
    get 'main/all_companies'
    post 'main/offer_to_company/:id', to: 'main#offer_to_company', as: 'offer_to_company'
    post 'main/all_companies/:id', to: 'main#company_description', as: 'company_description'
    get 'main/choosed_companies'
    post 'main/cancel_offer/:id', to: 'main#cancel_offer', as: 'cancel_offer'
    get 'main/waiting_approval'
    post 'main/approve_company/:id', to: 'main#approve_company', as: 'approve'

    get 'main/edit'
    post 'main/edit', to: 'main#update'

    get 'main/files/:id', to: 'main#get_file', as: 'files'
    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

    get 'main/all_db'
  end
end
