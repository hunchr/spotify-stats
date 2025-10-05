# Spotify Stats

## Usage

1. Request your data at [spotify.com/account/privacy](https://www.spotify.com/us/account/privacy/).
2. Wait until you receive an email with `my_spotify_data.zip`.
3. Start the Rails server and visit [127.0.0.1:3000/imports/new](http://127.0.0.1:3000/imports/new).
4. Upload all `Streaming_History_Audio_*.json` files (not the video history).

### Connect to Spotify API (optional)

1. Create an app at [developer.spotify.com/dashboard/create](https://developer.spotify.com/dashboard/create).\
   Use `http://127.0.0.1:3000` as redirect URI and `Web API` as API.
2. Put the client ID and secret in the `.env` file.
3. Start the server and visit a song page (this should redirect you to Spotify).
4. Authorize the App.

## Demo Screenshots
<details>
   <summary>/stats</summary>
   <img alt="Stats page" width="150" src="https://github.com/user-attachments/assets/8f7585cf-43de-4ce1-905d-a32c0fcca5c1">
</details>
<details>
   <summary>/songs</summary>
   <img alt="Songs index page" width="700" src="https://github.com/user-attachments/assets/55525fca-6d81-4b90-a1e2-cef819406566">
</details>
<details>
   <summary>/songs/:id</summary>
   <img alt="Songs show page" width="400" src="https://github.com/user-attachments/assets/abbb3b4f-0544-4498-8ee6-9732dfafeb3a">
</details>

## Development

### Prerequisites

- Node.js
- Ruby
- SQLite

### Local Setup

Clone this repository, install the necessary dependencies, and set up the SQLite database:

```sh
git clone https://github.com/hunchr/spotify-stats
cd spotify-stats
bin/setup
```

Start the Rails server with `bin/dev`.

## License

Copyright (c) 2025-present hunchr.\
Released under the terms of the [MIT License](https://github.com/hunchr/spotify-stats/blob/main/LICENSE).
