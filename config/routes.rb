EarthquakeChallenge::Application.routes.draw do
  root :to => 'earthquakes#index'
  match 'earthquakes' => 'earthquakes#index'
end
