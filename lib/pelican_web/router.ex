defmodule PelicanWeb.Router do
  use PelicanWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", PelicanWeb do
    pipe_through :api

    get "/cache", GSXController, :read_cache
  end
end
