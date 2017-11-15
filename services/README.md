# to make sure closing session for user "dev" won't kill services, run as root:
loginctl enable-linger dev

# then fix paths in services/nginx.service and run as dev
systemctl --user link services/nginx.service
systemctl --user enable nginx.service
systemctl --user start nginx.service
journalctl --user -xe
