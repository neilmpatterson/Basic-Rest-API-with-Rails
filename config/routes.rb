Prettyquotes::Application.routes.draw do
	match '/', to: 'home#index', via: 'get'
	namespace :api, :defaults => {:format => :json} do
		namespace :v1 do
			resources :quotes, :authors
		end
	end
end
