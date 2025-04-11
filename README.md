# Symposium25
thermostat for Symposium
## talk Directory
The PDF for the talk given at the Engineering Symposium 2025 in Rochester NY 4/10/2025
## Livebook Directory
The Livebook I was going to demonstrate, except that the projector did not synchronize with my MacBook and the borrowed computer did not have Livebook installed.
## thermostat Directory
The thermostat web app.
Find the call that schedules the `tick` event and change the interval -- at least 1 ms.
The readme file in that directory gives instructions for starting the web server. See the talk for URL to get started with Elixir if it isn't installed on your computer.
go to http://localhost:4000/thermostat to start the web app.
I found the Apple Safari web browser to be unreliable when the `tick` interval was 1 ms. The chrome browser was stable at that rate. I started 15 tabs all using the thermostat app.
