#!/bin/bash
# --- Font Configuration and Check Script ---
# This script checks for fontconfig installation, updates font cache,
# lists available fonts, checks font matches for common families,
# and tests multilingual/emoji output.
#
    # Usage:
    #   ./setup.sh                  - Runs all checks and configurations.
    #   ./setup.sh -i | --check-install  - Only checks fontconfig installation.
    #   ./setup.sh -u | --update-cache   - Only updates font cache.
    #   ./setup.sh -l | --list-fonts     - Only lists available fonts.
    #   ./setup.sh -m | --check-matches  - Only checks common font matches.
    #   ./setup.sh -t | --test-output    - Only tests multilingual and emoji output.
    #   ./setup.sh -h | --help           - Displays this help message.

# Function to check for fontconfig installation
_check_fontconfig_installation() {
    echo "Checking for fontconfig installation..."
    if command -v fc-cache &> /dev/null; then
        echo "fontconfig is installed."
    else
        echo "fontconfig is not installed. Please install it (e.g., sudo apt install fontconfig or sudo pacman -S fontconfig)."
        exit 1
    fi
}

# Function to update font cache
_update_font_cache() {
    echo -e "\nUpdating font cache..."
    fc-cache -fv
}

# Function to list available fonts
_list_available_fonts() {
    echo -e "\nListing first 10 available fonts:"
    fc-list | head -n 10
}

# Function to list available font families
_list_font_families() {
    echo -e "\nListing available font families:"
    fc-list : family | sort -u
}

# Function to check font matches for common families
_check_common_font_matches() {
    echo -e "\nChecking font matches for common families:"
    echo "Sans-serif font:"
    fc-match sans
    echo "Serif font:"
    fc-match serif
    echo "Monospace font:"
    fc-match monospace
    echo "Noto Color Emoji font:"
    fc-match "Noto Color Emoji"
}

# Function to test emoji and multilingual output
_test_multilingual_emoji() {
    echo -e "\nTesting emoji and multilingual output:"
    echo -e "English 中文 عربى हिंदी 😄 🧠 ⛩️ 🎵"
}

# Function to link the font configuration file
_link_config_file() {
    local source_path="$(dirname "$0")/fonts.conf"
    local target_dir="${HOME}/.config/fontconfig"
    local target_path="${target_dir}/fonts.conf"

    echo -e "\nAttempting to link font configuration file..."

    if [ ! -f "$source_path" ]; then
        echo "Error: Source font configuration file not found at '$source_path'."
        echo "Please ensure 'font.config' exists in the same directory as this script."
        exit 1
    fi

    if [ ! -d "$target_dir" ]; then
        echo "Creating target directory: '$target_dir'"
        mkdir -p "$target_dir"
    fi

    echo "Linking '$source_path' to '$target_path'..."
    ln -sf "$source_path" "$target_path"

    if [ $? -eq 0 ]; then
        echo "Font configuration file linked successfully."
    else
        echo "Error: Failed to link font configuration file."
        exit 1
    fi
}

# Function to print usage information
_print_usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Options:"
    echo "  -i, --check-install   Check for fontconfig installation."
    echo "  -u, --update-cache    Update font cache."
    echo "  -l, --list-fonts      List first 10 available fonts."
    echo "  -m, --check-matches   Check font matches for common families."
    echo "  -t, --test-output     Test multilingual and emoji output."
    echo "  -f, --list-families   List all available font families."
    echo "  -k, --link-config     Link font.config to ~/.config/fontconfig/."
    echo "  -h, --help            Display this help message."
    echo "If no options are provided, all checks and configurations will be performed."
}

# Main function to orchestrate the script
main() {
    local run_all=true
    local check_install=false
    local update_cache=false
    local list_fonts=false
    local check_matches=false
    local test_output=false
    local list_families=false
    local link_config=false

    # Parse arguments
    for arg in "$@"; do
        case $arg in
            -i|--check-install)
                check_install=true
                run_all=false
                ;;
            -u|--update-cache)
                update_cache=true
                run_all=false
                ;;
            -l|--list-fonts)
                list_fonts=true
                run_all=false
                ;;
            -m|--check-matches)
                check_matches=true
                run_all=false
                ;;
            -t|--test-output)
                test_output=true
                run_all=false
                ;;
            -f|--list-families)
                list_families=true
                run_all=false
                ;;
            -k|--link-config)
                link_config=true
                run_all=false
                ;;
            -h|--help)
                _print_usage
                exit 0
                ;;
            *)
                echo "Unknown option: $arg"
                _print_usage
                exit 1
                ;;
        esac
    done

    if $run_all; then
        _check_fontconfig_installation
        _update_font_cache
        _list_available_fonts
        _check_common_font_matches
        _test_multilingual_emoji
        _list_font_families
        _link_config_file
    else
        if $check_install; then
            _check_fontconfig_installation
        fi
        if $update_cache; then
            _update_font_cache
        fi
        if $list_fonts; then
            _list_available_fonts
        fi
        if $check_matches; then
            _check_common_font_matches
        fi
        if $test_output; then
            _test_multilingual_emoji
        fi
        if $list_families; then
            _list_font_families
        fi
        if $link_config; then
            _link_config_file
        fi
    fi

    echo -e "\nFont configuration and check script completed."
}

# Call the main function with all arguments passed to the script
main "$@"

