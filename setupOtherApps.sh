#!/bin/bash

# Function to check if an application is already in /Applications
is_installed_app() {
    [ -d "/Applications/$1.app" ]
}

# Function to check if a cask is installed
is_installed_cask() {
    brew list --cask "$1" &> /dev/null
}

# Function to check if an app store app is installed
is_installed_mas() {
    mas list | grep "$1" &> /dev/null
}


# Install mas if not installed
if ! brew list mas &> /dev/null; then
    echo "Installing mas..."
    brew install mas
fi

# Install applications if not already installed
# App Store IDs for the applications (replace with actual IDs if available)
wps_office_id=""
slack_id="803453959"  # example: Slack app store id
whatsapp_id="1147396723"  # example: WhatsApp app store id
brave_browser_id=""
inkscape_id=""
tayasui_sketches_id=""
ncalc_id=""
tor_browser_id=""
zoom_id=""
capcut_id=""
llm_studio_id=""
android_studio_id=""

# WPS Office
if is_installed_app "WPS Office"; then
    echo "WPS Office is already installed."
elif [ ! -z "$wps_office_id" ] && is_installed_mas "$wps_office_id"; then
    echo "WPS Office is already installed through App Store."
elif is_installed_cask "wpsoffice"; then
    echo "WPS Office is already installed through Homebrew."
else
    if [ ! -z "$wps_office_id" ]; then
        echo "Installing WPS Office from App Store..."
        mas install $wps_office_id
    else
        echo "Installing WPS Office from Homebrew..."
        brew install --cask wpsoffice
    fi
fi

# Slack
if is_installed_app "Slack"; then
    echo "Slack is already installed."
elif is_installed_mas "$slack_id"; then
    echo "Slack is already installed through App Store."
elif is_installed_cask "slack"; then
    echo "Slack is already installed through Homebrew."
else
    echo "Installing Slack from App Store..."
    mas install $slack_id
fi

# WhatsApp
if is_installed_app "WhatsApp"; then
    echo "WhatsApp is already installed."
elif is_installed_mas "$whatsapp_id"; then
    echo "WhatsApp is already installed through App Store."
elif is_installed_cask "whatsapp"; then
    echo "WhatsApp is already installed through Homebrew."
else
    echo "Installing WhatsApp from App Store..."
    mas install $whatsapp_id
fi

# Brave Browser
if is_installed_app "Brave Browser"; then
    echo "Brave Browser is already installed."
elif [ ! -z "$brave_browser_id" ] && is_installed_mas "$brave_browser_id"; then
    echo "Brave Browser is already installed through App Store."
elif is_installed_cask "brave-browser"; then
    echo "Brave Browser is already installed through Homebrew."
else
    if [ ! -z "$brave_browser_id" ]; then
        echo "Installing Brave Browser from App Store..."
        mas install $brave_browser_id
    else
        echo "Installing Brave Browser from Homebrew..."
        brew install --cask brave-browser
    fi
fi

# Inkscape
if is_installed_app "Inkscape"; then
    echo "Inkscape is already installed."
elif [ ! -z "$inkscape_id" ] && is_installed_mas "$inkscape_id"; then
    echo "Inkscape is already installed through App Store."
elif is_installed_cask "inkscape"; then
    echo "Inkscape is already installed through Homebrew."
else
    if [ ! -z "$inkscape_id" ]; then
        echo "Installing Inkscape from App Store..."
        mas install $inkscape_id
    else
        echo "Installing Inkscape from Homebrew..."
        brew install --cask inkscape
    fi
fi

# Tayasui Sketches
if is_installed_app "Tayasui Sketches"; then
    echo "Tayasui Sketches is already installed."
elif [ ! -z "$tayasui_sketches_id" ] && is_installed_mas "$tayasui_sketches_id"; then
    echo "Tayasui Sketches is already installed through App Store."
else
    if [ ! -z "$tayasui_sketches_id" ]; then
        echo "Installing Tayasui Sketches from App Store..."
        mas install $tayasui_sketches_id
    fi
fi

# NCalc
if is_installed_app "NCalc"; then
    echo "NCalc is already installed."
elif [ ! -z "$ncalc_id" ] && is_installed_mas "$ncalc_id"; then
    echo "NCalc is already installed through App Store."
else
    if [ ! -z "$ncalc_id" ]; then
        echo "Installing NCalc from App Store..."
        mas install $ncalc_id
    fi
fi

# Tor Browser
if is_installed_app "Tor Browser"; then
    echo "Tor Browser is already installed."
elif [ ! -z "$tor_browser_id" ] && is_installed_mas "$tor_browser_id"; then
    echo "Tor Browser is already installed through App Store."
elif is_installed_cask "tor-browser"; then
    echo "Tor Browser is already installed through Homebrew."
else
    if [ ! -z "$tor_browser_id" ]; then
        echo "Installing Tor Browser from App Store..."
        mas install $tor_browser_id
    else
        echo "Installing Tor Browser from Homebrew..."
        brew install --cask tor-browser
    fi
fi

# Zoom.us
if is_installed_app "zoom.us"; then
    echo "Zoom.us is already installed."
elif [ ! -z "$zoom_id" ] && is_installed_mas "$zoom_id"; then
    echo "Zoom.us is already installed through App Store."
elif is_installed_cask "zoom"; then
    echo "Zoom.us is already installed through Homebrew."
else
    if [ ! -z "$zoom_id" ]; then
        echo "Installing Zoom.us from App Store..."
        mas install $zoom_id
    else
        echo "Installing Zoom.us from Homebrew..."
        brew install --cask zoom
    fi
fi

# Capcut
if is_installed_app "Capcut"; then
    echo "Capcut is already installed."
elif [ ! -z "$capcut_id" ] && is_installed_mas "$capcut_id"; then
    echo "Capcut is already installed through App Store."
elif is_installed_cask "capcut"; then
    echo "Capcut is already installed through Homebrew."
else
    if [ ! -z "$capcut_id" ]; then
        echo "Installing Capcut from App Store..."
        mas install $capcut_id
    else
        echo "Installing Capcut from Homebrew..."
        brew install --cask capcut
    fi
fi

# LLM Studio
if is_installed_app "LLM Studio"; then
    echo "LLM Studio is already installed."
elif [ ! -z "$llm_studio_id" ] && is_installed_mas "$llm_studio_id"; then
    echo "LLM Studio is already installed through App Store."
else
    if [ ! -z "$llm_studio_id" ]; then
        echo "Installing LLM Studio from App Store..."
        mas install $llm_studio_id
    fi
fi

# Android Studio
if is_installed_app "Android Studio"; then
    echo "Android Studio is already installed."
elif [ ! -z "$android_studio_id" ] && is_installed_mas "$android_studio_id"; then
    echo "Android Studio is already installed through App Store."
elif is_installed_cask "android-studio"; then
    echo "Android Studio is already installed through Homebrew."
else
    if [ ! -z "$android_studio_id" ]; then
        echo "Installing Android Studio from App Store..."
        mas install $android_studio_id
    else
        echo "Installing Android Studio from Homebrew..."
        brew install --cask android-studio
    fi
fi

echo "Script execution complete."
