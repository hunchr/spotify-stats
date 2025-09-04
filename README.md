# Spotify Stats

## Usage

1. Request your data at [spotify.com/account/privacy](https://www.spotify.com/us/account/privacy/)
2. Wait until you receive an email with `my_spotify_data.zip`
3. Start the server and visit [127.0.0.1:3000/imports/new](http://127.0.0.1:3000/imports/new)
4. Upload all `Streaming_History_Audio_*.json` files (not the video history)

## Local Setup

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/)
2. Clone this repo and cd into it
3. Run `bin/setup` to install dependencies and set up the SQLite database
4. Start the Rails server with `bin/rails s`

## Connect to Spotify API (optional)

1. Create an app at [developer.spotify.com/dashboard/create](https://developer.spotify.com/dashboard/create)\
   Use `http://127.0.0.1:3000` as redirect URI and `Web API` as API
2. Put the client ID and secret in the `.env` file
3. Start the server and visit a song page (this should redirected you to Spotify)
4. Authorize the App

## License

Copyright (c) 2025-present hunchr.\
Released under the terms of the [MIT License](https://github.com/hunchr/spotify-stats/blob/main/LICENSE).
