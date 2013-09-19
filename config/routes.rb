Earthquakes::Application.routes.draw do
  root :to => 'earthquakes#index'
  match 'quakes' => 'earthquakes#index'
end
