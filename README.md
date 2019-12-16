# Weechat Docker File

Up to date Weechat Docker file

## Usage

By default you should mount your `.weechat` or equivalent under `/weechat`
and weechat should start in headless mode.

## Cheat snippet

You most likely want to have `relay.conf` under your `/weechat` in order
to connect to it remotely.

Here's sample, feel free to build something from it.

```bash
[look]
auto_open_buffer = on
raw_messages = 256

[color]
client = cyan
status_active = lightblue
status_auth_failed = lightred
status_connecting = yellow
status_disconnected = lightred
status_waiting_auth = brown
text = default
text_bg = default
text_selected = white

[network]
allow_empty_password = on
allowed_ips = ""
bind_address = ""
clients_purge_delay = 0
compression_level = 6
ipv6 = on
max_clients = 5
password = ""
ssl_cert_key = "%h/ssl/relay.pem"
ssl_priorities = "NONE"
totp_secret = ""
totp_window = 0
websocket_allowed_origins = ""

[irc]
backlog_max_minutes = 1440
backlog_max_number = 256
backlog_since_last_disconnect = on
backlog_since_last_message = off
backlog_tags = "irc_privmsg"
backlog_time_format = "[%H:%M] "

[weechat]
commands = ""

[port]
weechat = 9001

[path]

```
