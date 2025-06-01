# Spotify Stats

## Usage

1. Request your data at [spotify.com/account/privacy](https://www.spotify.com/us/account/privacy/)
2. Wait until you receive an email with `my_spotify_data.zip`
3. Start the server and visit [localhost:3000/imports/new](http://localhost:3000/imports/new)
4. Upload all `Streaming_History_Audio_*.json` files (not the video history)

## Local Setup

1. Install [Ruby](https://www.ruby-lang.org/en/downloads/)
2. Clone this repo and cd into it
3. Run `bin/setup` to install dependencies and set up the SQLite database
4. Start the Rails server with `bundle exec rails s`

## License

Copyright (c) 2025-present hunchr.\
Released under the terms of the [MIT License](https://github.com/hunchr/spotify-stats/blob/main/LICENSE).
