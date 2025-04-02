defmodule ThermostatWeb.ThermostatLive do
  use ThermostatWeb, :live_view

  def mount(_params, _session, socket) do
    {:ok, assign(socket, current_temperature: 18.0, desired_temperature: 18.0)}
  end

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
end
