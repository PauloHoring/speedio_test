# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1 do
      post 'register', to: 'users#register'
      post 'login', to: 'users#login'
      post 'auth', to: 'users#auth'
      post 'config', to: 'users#config'

      post 'automations/requestconfigurationlink', to: 'automations#request_configuration_link'

      post 'companies/sendmail', to: 'companies#send_email'
      post 'companies/sendinvite', to: 'companies#send_invite'
      post 'companies/sendmessage', to: 'companies#send_message'
    end
  end
end
