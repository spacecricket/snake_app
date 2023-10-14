defmodule SnakeAppWeb.GameLive do
  use SnakeAppWeb, :live_view

  def mount(_params, _session, socket) do
    size = 17
    board = for row <- 1..size, col <- 1..size, into: %{}, do: {{row, col}, " "}

    mid = div(size, 2) + 1
    snake = [{mid, 2}, {mid, 3}, {mid, 4}]
    board = for position <- snake, into: board, do: {position, "S"}

    Process.send_after(self(), :move, 1500)

    {
      :ok,
      socket
      |> assign(:size, size)
      |> assign(:board, place_food(board, size))
      |> assign(:snake, snake)
      |> assign(:direction, {0, 1})
      |> assign(:direction_used, {0, 1})
      |> assign(:delay, 250)
      |> assign(:game_over, false)
    }
  end

  def render(assigns) do
    ~H"""
    <div id="game" class="game" phx-window-keyup="move">
      <div>Feed me!</div>
      <div>Frogs: <%= length(@snake) - 3 %></div>
       <div
        class={"board #{if(@game_over, do: "game-over")}"}
       >
        <%= for row <- 1..@size do %>
          <div class="row">
            <%= for col <- 1..@size do %>
              <div
               class={"slot #{if(Map.get(@board, {row, col}) == "S", do: "snake")} #{if(Map.get(@board, {row, col}) == "F", do: "frog")}"}
              >
                <%= if Map.get(@board, {row, col}) == "F", do: "🐸" %>
              </div>
            <%  end %>
          </div>
        <%  end %>
      </div>
    </div>
    """
  end

  def handle_event("move", %{"key" => key}, socket) do
    {
      :noreply,
      socket
      |> assign(
          :direction,
          case key do
            "ArrowUp" -> {-1, 0}
            "ArrowDown" -> {1, 0}
            "ArrowLeft" -> {0, -1}
            "ArrowRight" -> {0, 1}
            _ -> socket.assigns.direction
          end
        )
    }
  end

  def handle_info(:move, socket) do
    if socket.assigns.game_over do
      {:noreply, socket}
    else
      Process.send_after(self(), :move, socket.assigns.delay)

      # figure out direction
      direction = case socket.assigns.direction do
        {-1, 0} -> if socket.assigns.direction_used == {1, 0}, do: {1, 0}, else: {-1, 0}
        {1, 0} -> if socket.assigns.direction_used == {-1, 0}, do: {-1, 0}, else: {1, 0}
        {0, -1} -> if socket.assigns.direction_used == {0, 1}, do: {0, 1}, else: {0, -1}
        {0, 1} -> if socket.assigns.direction_used == {0, -1}, do: {0, -1}, else: {0, 1}
      end

      # IO.inspect(direction)
      socket = assign(socket, :direction_used, direction)

      snake = socket.assigns.snake
      [tail | rest] = snake
      head = Enum.at(snake, length(snake) - 1)

      head_row = elem(head, 0)
      next_row = head_row + elem(direction, 0)
      head_col = elem(head, 1)
      next_col = head_col + elem(direction, 1)
      next = {next_row, next_col}

      # out of bounds?
      if next_row == 0 || next_row > socket.assigns.size || next_col == 0 || next_col > socket.assigns.size do
        {
          :noreply,
          socket
          |> assign(:game_over, true)
        }
      else
        board = socket.assigns.board
        next_slot = Map.get(board, next)

        if next_slot == "S" do
          {
            :noreply,
            socket
            |> assign(:game_over, true)
          }
        else
          is_frog = if next_slot == "F", do: true, else: false

          board = if is_frog do
            place_food(board, socket.assigns.size)
          else
            Map.put(board, tail, " ")
          end

          snake = if is_frog do
            snake ++ [next]
          else
            rest ++ [next]
          end

          board = Map.put(board, next, "S")

          {
            :noreply,
            socket
            |> assign(:snake, snake)
            |> assign(:board, board)
            |> assign(:delay, if(is_frog, do: socket.assigns.delay - 5, else: socket.assigns.delay))
          }
        end
      end
    end
  end

  defp place_food(board, size) do
    position = {Enum.random(1..size), Enum.random(1..size)}
    case Map.get(board, position) do
      " " -> Map.put(board, position, "F")
      "S" -> place_food(board, size)
    end
  end
end
