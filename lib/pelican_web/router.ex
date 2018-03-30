defmodule PelicanWeb.Router do
  use PelicanWeb, :router

  pipeline :api do
    plug(:accepts, ["json"])
  end

  scope "/api", PelicanWeb do
    pipe_through(:api)
  end

  scope "/" do
    pipe_through(:api)

    forward("/graphiql", Absinthe.Plug.GraphiQL, schema: PelicanWeb.Schema)

    forward("/graphql", Absinthe.Plug, schema: PelicanWeb.Schema)
  end
end
