# Nginx Reverse Proxy Lab

This lab demonstrates setting up Nginx as a reverse proxy on an AWS EC2 instance.

## Features
- Routes `/app1/` → backend on port 3000
- Routes `/app2/` → backend on port 4000
- Uses `127.0.0.1` for internal communication
- Config tested on Amazon Linux 2023 (EC2)
