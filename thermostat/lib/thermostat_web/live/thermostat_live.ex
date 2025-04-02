defmodule ThermostatWeb.ThermostatLive do
  use ThermostatWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Thermostat</h1>
      <p>Current Temperature: {@current_temperature}°C</p>
      <p>Desired Temperature: {@desired_temperature}°C</p>
      <div class="text-4xl">
        <button phx-click="increase" class="px-4 py-2 bg-red-500 text-white rounded">+</button>
        <button phx-click="decrease" class="px-4 py-2 bg-blue-500 text-white rounded">-</button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)

    state =
      {:ok, assign(socket, current_temperature: 18.0, desired_temperature: 18.0)}
  end

  def handle_info(:tick, socket) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()

    current_temperature =
      cond do
        socket.assigns.current_temperature < socket.assigns.desired_temperature ->
          socket.assigns.current_temperature + 0.1

        socket.assigns.current_temperature > socket.assigns.desired_temperature ->
          socket.assigns.current_temperature - 0.1

        true ->
          socket.assigns.current_temperature
      end

    {:noreply, assign(socket, current_temperature: Float.round(current_temperature, 1))}
  end

  def handle_event("increase", _params, socket) do
    new_temperature = socket.assigns.desired_temperature + 1.0
    {:noreply, assign(socket, desired_temperature: new_temperature)}
  end

  def handle_event("decrease", _params, socket) do
    new_temperature = socket.assigns.desired_temperature - 1.0
    {:noreply, assign(socket, desired_temperature: new_temperature)}
  end
end
