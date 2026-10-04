# Ubuntu Setup Guide

## 1. Copy the script

Clone the repository:

```bash
git clone https://github.com/<your-username>/smart-proxy-switcher.git
```

Enter the directory:

```bash
cd smart-proxy-switcher
```

## 2. Make the script executable

```bash
chmod +x scripts/toggle-proxy.sh
```

## 3. Test the script

Check the current proxy mode:

```bash
gsettings get org.gnome.system.proxy mode
```

Run:

```bash
./scripts/toggle-proxy.sh
```

Check again:

```bash
gsettings get org.gnome.system.proxy mode
```

## 4. Configure the keyboard shortcut

Open:

```text
Settings → Keyboard → Keyboard Shortcuts
```

Add a custom shortcut.

Example:

```text
Name:
Smart Proxy Switcher

Command:
/bin/bash /path/to/smart-proxy-switcher/scripts/toggle-proxy.sh

Shortcut:
F9
```

## 5. Verify the proxy

HTTP proxy:

```bash
gsettings get org.gnome.system.proxy.http host
gsettings get org.gnome.system.proxy.http port
```

HTTPS proxy:

```bash
gsettings get org.gnome.system.proxy.https host
gsettings get org.gnome.system.proxy.https port
```

Proxy mode:

```bash
gsettings get org.gnome.system.proxy mode
```

## Security

Never commit proxy usernames or passwords.

The script only changes the proxy host, port, and enabled/disabled state.
