defmodule ThermostatWeb.ThermostatLive do
  use ThermostatWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Thermostat</h1>
      <h2>Current Temperature: {Float.round(@state.v, 1)}°C</h2>
      <h2>Desired Temperature: {@state.vf}°C</h2>
      <div class="text-4xl">
        <button phx-click="increase" class="px-4 py-2 bg-red-500 text-white rounded">+</button>
        Target: {@state.vf}°C. Now: {Float.round(@state.v, 1)}°C.
        <button phx-click="decrease" class="px-4 py-2 bg-blue-500 text-white rounded">-</button>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(500, self(), :tick)

    state = Thermostat.ReachAsymptote.new(30.0, 22.0, 0.3)
    {:ok, assign(socket, state: state)}
  end

  def handle_info(:tick, socket) do
    # now = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()
    new_state = Thermostat.ReachAsymptote.value_now(socket.assigns.state)

    {:noreply, assign(socket, state: new_state)}
  end

  def handle_event("increase", _params, socket) do
    {:noreply, assign(socket, state: update_state(socket.assigns.state, 1.0))}
  end

  def handle_event("decrease", _params, socket) do
    {:noreply, assign(socket, state: update_state(socket.assigns.state, -1.0))}
  end

  def update_state(%Thermostat.ReachAsymptote{} = state, delta) do
    new_vf = state.vf + delta
    Thermostat.ReachAsymptote.new(state.v, new_vf, state.r)
  end
end
