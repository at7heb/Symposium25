defmodule Thermostat.ReachAsymptote do
  defstruct t0: 0.0, v0: 0.0, vf: 1.0, r: 0.1, v: 0.0

  def new(start_value, asymptote, rate)
      when is_float(start_value) and is_float(asymptote) and is_float(rate) do
    {seconds, microseconds} = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()
    start_time = seconds + microseconds / 1_000_000.0
    %__MODULE__{t0: start_time, v0: start_value, vf: asymptote, r: rate, v: start_value}
  end

  def value_now(%__MODULE__{} = state) do
    {seconds, microseconds} = NaiveDateTime.utc_now() |> NaiveDateTime.to_gregorian_seconds()
    t = seconds + microseconds / 1_000_000.0
    v = state.vf - (state.vf - state.v0) * :math.exp(-state.r * (t - state.t0))
    %{state | v: v}
  end
end
