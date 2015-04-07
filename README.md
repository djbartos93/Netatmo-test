#This is only for testing. Main project is now in the repo Piatmometer

Netatmo API Test
======

Testing repo for a larger project

# TO DO:
- [ ] WORKING WITH API
  - [ ] token/access
    - [x] get access token
    - [x] save access token
    - [x] use renew token rather than getting new token when expired
    - [ ] fix error when .token.yaml file doesnt exist
    - [ ] fix check_token undefined variable
  - [ ] measurements/other calls
    - [x] get user info & save to file
    - [x] get temperature outdoor (saved to file)
    - [x] get temperature indoor
    - [x] get humidity (in and outdoor)
    - [x] get dB
    - [x] get CO2
    - [x] get pressure
    - [ ] get rain info
      - [ ] buy rain gauge first
    - [x] figure out if forecast is sent in api ( its not )
    - [x] figure out if weather warnings show up in api (yes as meto_alarms as far as i know.)
    - [ ] convert units to imperial units
    - [x] read temperature files (new plan no longer using files.)
- [ ] API FILE
  - [x] access token stuff
  - [ ] user info stuff
  - [ ] temp measure (outdoor)
    - [ ] min
    - [ ] max
    - [ ] day
    - [ ] day max/min
    - [ ] week
    - [ ] week max/min
    - [ ] month
    - [ ] month max/min
    - [ ] "maximum" max/min
  - [ ] temp measure (indoor)
    - [ ] min
    - [ ] max
    - [ ] day
    - [ ] day max/min
    - [ ] week
    - [ ] week max/min
    - [ ] month
    - [ ] month max/min
    - [ ] "maximum" max/min
  - [ ] Humidity (outdoor)
    - [ ] min
    - [ ] max
    - [ ] day
    - [ ] day max/min
    - [ ] week
    - [ ] week max/min
    - [ ] month
    - [ ] month max/min
    - [ ] "maximum" max/min
  - [ ] Humidity (outdoor)
    - [ ] min
    - [ ] max
    - [ ] day
    - [ ] day max/min
    - [ ] week
    - [ ] week max/min
    - [ ] month
    - [ ] month max/min
    - [ ] "maximum" max/min
  - [ ] CO2 measurements (maybe min max current?)
  - [ ] dB measurements (agan maybe min max?)
  - [ ] pressure (day min max?)
  - [ ] rain (day min max) (depending on buying rain gauge)
- [ ] OTHER SHIT
  for use in main repo


Notes
======
in device.yaml there is "dashboard_data" this is the most recent measurement taken by the weather station this will always show the most recent.

max and min temps found in the dashboard_data, quicker and easier than getting them via the API
