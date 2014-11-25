SS::Application.routes.draw do

  Blog::Initializer

  concern :deletion do
    get :delete, on: :member
  end

  content "blog" do
    get "/" => redirect { |p, req| "#{req.path}/pages" }, as: :main
    resources :pages, concerns: :deletion
  end

  page "blog" do
    get "page/:filename.:format" => "public#index", cell: "pages/page"
  end

end
