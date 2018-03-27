defmodule Pelican.GSX.Client do
  @modeuldoc """
  This module defines an explicit contract to which all modules
  that act as consumers of the GSX API should adhere to.
  """

  @callback fetch(document_id :: String.t()) :: {:ok, String.t()} | {:error, term()}
end
