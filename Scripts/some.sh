# #!/bin/zsh

# if ! $(which brew > /dev/null); then
#    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# fi

echo "#!/bin/sh\necho pre-commit started 🚀\nsh scripts/hook.sh\necho pre-commit finished 🎉"