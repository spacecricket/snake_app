# SnakeApp

This is a hobby project where I build what ought to be a client side game using Elixir and Phoenix LiveView. Should we use these technologies? Of course not!

These technologies manage state on the server side and have a very fast state propagation to the client. The point of this project is to push the technologies
to see how it might perform with a game whose state management ought have zero network calls.

The result? You do see the lags, but I'm impressed by Elixir + Phoenix LiveView nonetheless.

Play it here: https://snake.fly.dev/

## To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
