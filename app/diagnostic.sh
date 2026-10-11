#!/bin/bash

case $1 in
    system)
        echo "This is your system information"
        echo "hostname: $(hostname)"
        echo "current-user: $(id -un)"
        echo "OS name: $(grep PRETTY_NAME /etc/os-release | awk -F = '{print $2}' | tr -d '"')"
        echo "Kernel version: $(uname -r)"
        echo "Uptime: $(uptime)"
        echo "CPU cores: $(nproc)"
        echo "memory:"
        free -m
        echo "current directory: $(pwd)"
        echo "date and time: $(date)"
        ;;
    disk)
        echo "Disk Information"
        echo "Root (/) usage: $(df -P / | awk 'NR==2 {print $5}')"
        echo
        df -h
        ;;
    network)
        host=$2
        if [[ -z $host ]]; then
            echo "Error: no host given. Usage: diagnostic network <host>" >&2
            exit 2
        fi
        echo "Network check for $host"
        ip_address=$(getent hosts "$host" | awk '{print $1}' | head -1)
        if [[ -z $ip_address ]]; then
            echo "Could not resolve $host" >&2
            exit 1
        fi
        echo "Resolved IP: $ip_address"
        if timeout 3 bash -c "</dev/tcp/$host/443" 2>/dev/null; then
            echo "Status: $host is reachable on port 443"
        else
            echo "Status: $host is unreachable on port 443" >&2
            exit 1
        fi
        ;;
    help)
        echo "Usage: diagnostic <command>"
        echo
        echo "Commands:"
        echo "  system           Show system information"
        echo "  disk             Show disk information"
        echo "  network <host>   Check connectivity to a host"
        echo "  help             Show this help message"
        ;;
    *)
        echo "Error: unknown command '$1'" >&2
        echo "Run 'diagnostic help' to see available commands" >&2
        exit 2
        ;;
esac

exit 0
