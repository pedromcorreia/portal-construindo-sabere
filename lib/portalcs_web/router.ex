defmodule PortalcsWeb.Router do
  use PortalcsWeb, :router
  use Coherence.Router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session
  end

  pipeline :protected do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug Coherence.Authentication.Session, protected: true
  end

  scope "/" do
    pipe_through :browser
    coherence_routes()
  end
  scope "/" do
    pipe_through :protected
    coherence_routes :protected
  end

  scope "/", PortalcsWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
  end

  scope "/", PortalcsWeb do
    pipe_through :protected

    resources "/post", PostController
    resources "/privates", PortalcsWeb.PrivateController
  end
end
