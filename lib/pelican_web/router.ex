defmodule PelicanWeb.Router do
  use PelicanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", PelicanWeb do
    pipe_through :api
  end
end
