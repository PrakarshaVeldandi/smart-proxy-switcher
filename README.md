# Smart Proxy Switcher

A lightweight Linux utility that lets you quickly enable or disable a hostel network proxy using a single keyboard shortcut.

The project is designed for Ubuntu/GNOME systems where proxy settings need to be changed depending on the time of day.

## Features

* Toggle the GNOME network proxy using **F9**
* Automatically selects the appropriate hostel proxy based on the time
* Disables the proxy with the same key
* No root/sudo access required
* Uses GNOME's `gsettings` interface
* Shows desktop notifications when the proxy changes
* Includes an installation script
* Detects existing GNOME custom shortcuts
* Does not overwrite an existing shortcut using F9
* Keeps proxy credentials outside the project

## How It Works

The shortcut follows this logic:

```text
                    Press F9
                       │
                       ▼
                Is proxy enabled?
                  /           \
                Yes            No
                 │              │
                 ▼              ▼
          Disable proxy    Check current time
                                │
                         ┌──────┴──────┐
                         │             │
                      06:00–23:59   00:00–05:59
                         │             │
                         ▼             ▼
                  hostelinternet   staffnet
                  .rgukt.ac.in     .rgukt.ac.in
                         │             │
                         └──────┬──────┘
                                ▼
                         Enable proxy
```

### Proxy schedule

| Time          | Proxy                             |
| ------------- | --------------------------------- |
| 06:00 – 23:59 | `hostelinternet.rgukt.ac.in:3128` |
| 00:00 – 05:59 | `staffnet.rgukt.ac.in:3128`       |

The proxy is enabled only when requested by pressing F9. The script does not continuously run in the background.

## Project Structure

```text
smart-proxy-switcher/
├── README.md
├── LICENSE
├── .gitignore
├── scripts/
│   ├── toggle-proxy.sh
│   └── install.sh
└── docs/
    └── setup.md
```

### `toggle-proxy.sh`

Contains the main proxy switching logic.

It:

1. Checks the current GNOME proxy state.
2. If the proxy is enabled, disables it.
3. If the proxy is disabled, checks the current time.
4. Selects the appropriate hostel proxy.
5. Configures HTTP and HTTPS proxy settings.
6. Enables the proxy.
7. Displays a desktop notification.

### `install.sh`

Automates the setup process.

The installer:

* Copies the proxy script to `~/bin`
* Makes it executable
* Detects existing GNOME custom shortcuts
* Reuses an existing **Smart Proxy Switcher** shortcut if present
* Finds an unused GNOME shortcut slot for a new installation
* Checks whether F9 is already being used
* Does not overwrite an existing F9 shortcut
* Configures F9 for the proxy switcher

## Requirements

* Ubuntu/Linux with GNOME
* `gsettings`
* Bash
* `notify-send` for desktop notifications

Most Ubuntu GNOME installations already provide `gsettings`.

If `notify-send` is not available, the proxy functionality still works, but desktop notifications will not be displayed.

## Installation

Clone the repository:

```bash
git clone https://github.com/PrakarshaVeldandi/smart-proxy-switcher.git
cd smart-proxy-switcher
```

Run the installer:

```bash
chmod +x scripts/install.sh
./scripts/install.sh
```

After installation, press:

```text
F9
```

to toggle the proxy.

The installer is designed to be safe to run again. It detects the existing Smart Proxy Switcher configuration instead of creating duplicate shortcuts.

## Manual Usage

The proxy script can also be executed directly:

```bash
~/bin/toggle-proxy.sh
```

Check the current proxy state:

```bash
gsettings get org.gnome.system.proxy mode
```

Possible values include:

```text
'none'
'manual'
```

`'none'` means the proxy is disabled.

`'manual'` means the GNOME manual proxy configuration is enabled.

## Security

This project does **not** store proxy usernames or passwords.

Do not put credentials directly into:

* `toggle-proxy.sh`
* `install.sh`
* `.env` files committed to Git
* GitHub repositories
* shell history

The proxy configuration is managed through GNOME's existing network settings.

## Why This Project?

Changing network proxy settings manually every time can be inconvenient, especially when the required proxy changes according to the time of day.

This project explores a simple Linux automation approach using:

* Bash scripting
* GNOME settings
* Keyboard shortcuts
* Time-based decision making
* Basic system automation
* Git and GitHub

It is intentionally small and focused rather than being a large application.

## Future Improvements

Possible extensions include:

* Detecting the connected Wi-Fi network automatically
* Supporting multiple proxy profiles
* Allowing proxy settings to be configured through a config file
* Adding a command-line interface
* Supporting more desktop environments
* Providing status information through the terminal
* Adding automatic proxy switching based on network conditions

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.

