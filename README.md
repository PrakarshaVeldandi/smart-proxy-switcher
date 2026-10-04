# Smart Proxy Switcher

A lightweight Linux utility for quickly switching between network proxy configurations using a keyboard shortcut.

The project is designed for Ubuntu/GNOME systems where different proxy configurations are required depending on the time of day.

## Features

* Toggle network proxy using a keyboard shortcut
* Automatically select the appropriate proxy based on time
* Daytime proxy: `hostelinternet.rgukt.ac.in:3128`
* Night-time proxy: `staffnet.rgukt.ac.in:3128`
* Disable the proxy when needed
* Uses GNOME `gsettings`
* Desktop notifications using `notify-send`
* No administrator/root privileges required

## How It Works

The shortcut runs the Bash script, which checks the current GNOME proxy state.

### When the proxy is disabled

The script enables the appropriate proxy:

| Time        | Proxy                             |
| ----------- | --------------------------------- |
| 06:00–23:59 | `hostelinternet.rgukt.ac.in:3128` |
| 00:00–05:59 | `staffnet.rgukt.ac.in:3128`       |

### When the proxy is enabled

The script disables the proxy.

Therefore, one keyboard shortcut can be used as:

```text
Proxy OFF
    ↓
    F9
    ↓
Correct proxy selected based on time
    ↓
    F9
    ↓
Proxy OFF
```

## Requirements

* Ubuntu 22.04 or a compatible GNOME desktop
* GNOME Settings / `gsettings`
* Bash
* `notify-send`
* A configured network proxy

## Installation

Clone the repository:

```bash
git clone https://github.com/<your-username>/smart-proxy-switcher.git
cd smart-proxy-switcher
```

Make the script executable:

```bash
chmod +x scripts/toggle-proxy.sh
```

Test it manually:

```bash
./scripts/toggle-proxy.sh
```

## Keyboard Shortcut

The script can be assigned to a GNOME custom keyboard shortcut.

For example:

```text
F9
```

Command:

```bash
/bin/bash /path/to/smart-proxy-switcher/scripts/toggle-proxy.sh
```

On the author's Ubuntu 22.04 system, the shortcut is configured through GNOME's custom keyboard shortcut settings.

## Manual Configuration

The proxy can still be changed normally through:

```text
Settings → Network → Network Proxy
```

The script does not prevent manual configuration.

## Important: Proxy Credentials

This project does **not** store proxy usernames or passwords.

Do not put credentials in:

* `README.md`
* Shell scripts
* Git commits
* GitHub Issues
* `.env` files that are committed
* Configuration files uploaded publicly

Authentication should be configured separately on the local machine.

## Current Design

```text
                 F9
                  │
                  ▼
        Check GNOME proxy state
                  │
          ┌───────┴───────┐
          │               │
       Disabled         Enabled
          │               │
          ▼               ▼
    Check current       Disable
        time             proxy
          │
     ┌────┴────┐
     │         │
  06–23      00–05
     │         │
     ▼         ▼
 Hostel      Staffnet
 Proxy        Proxy
```

## Project Goals

This project is also a practical exercise in:

* Linux command-line tools
* Bash scripting
* GNOME configuration
* Environment-aware automation
* Keyboard shortcut integration
* Git and GitHub
* Secure handling of credentials

## Future Improvements

Possible future versions could include:

* Automatic Wi-Fi/SSID detection
* Multiple configurable proxy profiles
* Configuration through a YAML/JSON file
* CLI commands such as `status`, `enable`, and `disable`
* Automatic proxy switching when connecting to specific networks
* Systemd user-service integration
* Better error handling and connectivity testing
* Support for other desktop environments

## License

This project is licensed under the MIT License.

