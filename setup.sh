#!/bin/bash

set -e  # Exit on any error

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [[ $EUID -eq 0 ]]; then
        log_warning "Running as root user"
        return 0
    else
        return 1
    fi
}

# Function to select PC configuration
select_pc_config() {
    log_info "Select PC configuration:"
    echo "1) Main"
    echo "2) Lat"
    read -p "Enter choice (1 or 2): " choice

    case $choice in
        1)
            PC_CONFIG="main"
            ;;
        2)
            PC_CONFIG="Lat"
            ;;
        *)
            log_error "Invalid choice. Using Main PC as default."
            PC_CONFIG="main"
            ;;
    esac

    log_success "Selected configuration: $PC_CONFIG"
}

# Function to verify and install yay if needed
setup_yay() {
    if command -v yay &> /dev/null; then
        log_success "yay is already installed"
        return 0
    fi

    log_info "yay not found. Installing yay..."

    # Check if running as root for initial setup
    if check_root; then
        log_error "Cannot install yay as root. Please run as regular user."
        return 1
    fi

    # Create temporary directory for yay installation
    local temp_dir=$(mktemp -d)
    cd "$temp_dir"

    log_info "Cloning yay repository..."
    git clone https://aur.archlinux.org/yay.git
    cd yay

    log_info "Building and installing yay..."
    makepkg -si --noconfirm

    # Cleanup
    cd /
    rm -rf "$temp_dir"

    if command -v yay &> /dev/null; then
        log_success "yay installed successfully"
        return 0
    else
        log_error "Failed to install yay"
        return 1
    fi
}

# Function to install pacman packages
install_pacman_packages() {
    local package_file="packages/packages-${PC_CONFIG}-list"

    if [[ ! -f "$package_file" ]]; then
        log_error "Pacman package file $package_file not found!"
        return 1
    fi

    # Check if file is empty
    if [[ ! -s "$package_file" ]]; then
        log_warning "Pacman package file $package_file is empty, skipping..."
        return 0
    fi

    log_info "Installing pacman packages from $package_file..."

    # Read packages and filter out comments and empty lines
    local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | tr '\n' ' ')

    if [[ -z "$packages" ]]; then
        log_warning "No packages found in $package_file after filtering comments"
        return 0
    fi

    log_info "Packages to install: $packages"

    # Check if running as root for pacman
    if check_root; then
        pacman -Sy --needed --noconfirm $packages
    else
        log_warning "Need root privileges for pacman package installation"
        sudo pacman -Sy --needed --noconfirm $packages
    fi

    if [[ $? -eq 0 ]]; then
        log_success "Pacman packages installed successfully"
    else
        log_error "Failed to install some pacman packages"
        return 1
    fi
}

# Function to install AUR packages with yay
install_aur_packages() {
    local package_file="packages/packages-${PC_CONFIG}-list-yay"

    if [[ ! -f "$package_file" ]]; then
        log_warning "AUR package file $package_file not found, skipping AUR packages..."
        return 0
    fi

    # Check if file is empty
    if [[ ! -s "$package_file" ]]; then
        log_warning "AUR package file $package_file is empty, skipping..."
        return 0
    fi

    # Ensure yay is available
    if ! command -v yay &> /dev/null; then
        log_warning "yay not available, skipping AUR packages..."
        return 0
    fi

    log_info "Installing AUR packages from $package_file..."

    # Read packages and filter out comments and empty lines
    local packages=$(grep -v '^#' "$package_file" | grep -v '^$' | tr '\n' ' ')

    if [[ -z "$packages" ]]; then
        log_warning "No packages found in $package_file after filtering comments"
        return 0
    fi

    log_info "AUR packages to install: $packages"

    # Install AUR packages
    yay -Sy --needed $packages

    if [[ $? -eq 0 ]]; then
        log_success "AUR packages installed successfully"
    else
        log_error "Failed to install some AUR packages"
        return 1
    fi
}

# Function to stow home directory
stow_home() {
    if [[ ! -d "home" ]]; then
        log_error "home directory not found!"
        return 1
    fi

    log_info "Setting up home directory symlinks with stow..."

    # Navigate to home directory and stow all packages
    cd home

    # Find all directories and stow them
    for dir in */; do
        if [[ -d "$dir" ]]; then
            log_info "Stowing ${dir%/}"
            stow --target="$HOME" --restow "${dir%/}"
        fi
    done

    cd ..

    log_success "Home directory symlinks created"
}

# Function to run custom scripts
run_scripts() {
    if [[ ! -d "scripts" ]]; then
        log_warning "scripts directory not found, skipping..."
        return 0
    fi

    log_info "Running custom scripts..."

    cd scripts

    # Make all scripts executable
    find . -type f -name "*.sh" -exec chmod +x {} \;

    # Run scripts in alphabetical order
    for script in *.sh; do
        if [[ -f "$script" && -x "$script" ]]; then
            log_info "Executing script: $script"
            ./"$script"

            if [[ $? -eq 0 ]]; then
                log_success "Script $script completed successfully"
            else
                log_error "Script $script failed with exit code $?"
            fi
        fi
    done

    cd ..

    log_success "All scripts executed"
}

# Function to verify stow is installed
verify_stow() {
    if ! command -v stow &> /dev/null; then
        log_info "Installing stow..."
        if check_root; then
            pacman -Sy stow --noconfirm
        else
            sudo pacman -Sy stow --noconfirm
        fi
    fi
}

# Main execution function
main() {
    log_info "Starting dotfiles setup..."

    # Select PC configuration
    select_pc_config

    # Verify stow is installed
    verify_stow

    # Install pacman packages
    install_pacman_packages

    # Install AUR packages (only if not running as root)
    if ! check_root; then
        setup_yay
        install_aur_packages
    else
        log_warning "Running as root, skipping AUR packages (yay requires regular user)"
    fi

    # Setup home directory with stow
    stow_home

    # Setup root directory
    # TODO: Create setup-root script

    # Run custom scripts
    run_scripts

    log_success "Dotfiles setup completed!"
    log_info "You may need to restart your shell or source your shell configuration"
}

# Run main function
main "$@"
