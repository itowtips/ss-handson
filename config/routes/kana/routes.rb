SS::Application.routes.draw do

  Kana::Initializer

  concern :deletion do
    get :delete, on: :member
  end

  namespace("kana", as: "kana", path: ".:site/kana", module: "kana") do
    get "dictionaries/build_confirmation" => "dictionaries#build_confirmation"
    post "dictionaries/build" => "dictionaries#build"
    resources :dictionaries, concerns: :deletion
  end
end
