GoogleSignIn::Engine.routes.draw do
  resource :authorization, only: :create
  resource :callback, only: :show
end
