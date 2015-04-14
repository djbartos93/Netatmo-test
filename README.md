Netatmo weather dashboard
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
- [ ] Admin interface
  - [ ]
- [ ] cleaner style
- [ ] gemfile
- [ ] make properly deployable

Running notes
======
This is not yet ready for proper delpoy. however you can still run it.

I have yet to add a gemfile

To configure put your netatmo info in the config.example.yaml and rename it to config.yaml

you may also want to change the title of the web page, located in views > main_page.erb
