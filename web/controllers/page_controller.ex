defmodule Worldcup.PageController do
  use Worldcup.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
