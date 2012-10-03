DeliveryExample::Application.routes.draw do
  resource :import, only: [:create]
end
