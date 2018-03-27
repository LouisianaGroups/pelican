defmodule PelicanWeb.GSXController do
  use PelicanWeb, :controller

  alias Pelican.GSX.Cache

  def read_cache(conn, _params) do
    conn
    |> put_status(:ok)
    |> json(Cache.read())
  end
end
