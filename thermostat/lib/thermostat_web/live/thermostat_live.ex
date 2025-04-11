defmodule ThermostatWeb.ThermostatLive do
  use ThermostatWeb, :live_view

  def render(assigns) do
    ~H"""
    <div>
      <h1>Thermostat</h1>
      <h2>Current Temperature: {Float.round(@state.v, 1)}°C</h2>
      <h2>Desired Temperature: {@state.vf}°C</h2>
      <div class="text-6xl">
        <button phx-click="increase" class="px-4 py-2 bg-red-500 text-white rounded">+</button>
        <div class="text-3xl">Target: {@state.vf}°C. Now: {Float.round(@state.v, 1)}°C.</div>
        <button phx-click="decrease" class="px-5 py-2 bg-blue-500 text-white rounded">-</button>
        <p>Count: {@count}</p>
        <p>Count/s: {Float.round(@count / @tocks, 0)}</p>
        <p>Tocks: {@tocks}</p>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    if connected?(socket), do: :timer.send_interval(100, self(), :tick)
    if connected?(socket), do: :timer.send_interval(1000, self(), :tock)
    state = Thermostat.ReachAsymptote.new(30.0, 22.0, 0.075)
    {:ok, assign(socket, state: state, count: 1, tocks: 1)}
  end

  def handle_info(:tick, socket) do
    # now = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()
    new_state = Thermostat.ReachAsymptote.value_now(socket.assigns.state)
    {:noreply, assign(socket, state: new_state, count: socket.assigns.count + 1)}
  end

  def handle_info(:tock, socket) do
    # now = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()
    new_state = Thermostat.ReachAsymptote.value_now(socket.assigns.state)
    {:noreply, assign(socket, state: new_state, tocks: socket.assigns.tocks + 1)}
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
