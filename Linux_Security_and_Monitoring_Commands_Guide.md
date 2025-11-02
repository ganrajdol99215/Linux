Linux Security & Monitoring Commands Guide for SysAdmins

============================================================

1. User & Permission Security
------------------------------------------------------------
List all users:
    cut -d: -f1 /etc/passwd

Check groups:
    cat /etc/group

Check last logins:
    lastlog

Who is logged in:
    who
    w

Show user permissions and groups:
    id <username>

Find world-writable files (potentially insecure):
    find / -perm -002 -type f

Find SUID binaries (potential privilege escalation):
    find / -perm -4000 -type f

------------------------------------------------------------

2. Process & Resource Monitoring
------------------------------------------------------------
Real-time process monitor:
    top
    htop

List all running processes:
    ps aux

Sort by memory:
    ps aux --sort=-%mem | head

Sort by CPU:
    ps aux --sort=-%cpu | head

View process tree:
    pstree -p

Check uptime and load average:
    uptime
    cat /proc/loadavg

Check disk and memory usage:
    df -h
    du -sh /var/log
    free -h

------------------------------------------------------------

3. Network & Connection Monitoring
------------------------------------------------------------
Show IP and network interfaces:
    ip addr
    ifconfig

Show routing table:
    ip route

View active connections and listening ports:
    ss -tulpn
    netstat -tulpn

Ping and trace route:
    ping -c 4 8.8.8.8
    traceroute google.com

DNS test:
    dig google.com
    nslookup google.com

Monitor network traffic:
    sudo tcpdump -i eth0
    iftop
    nload

Check firewall:
    sudo ufw status verbose

List open ports:
    sudo lsof -i -P -n

------------------------------------------------------------

4. System & Service Logs
------------------------------------------------------------
View recent system logs:
    sudo journalctl -xe

View boot logs:
    sudo dmesg | less

Check SSH logs:
    sudo journalctl -u ssh

Last reboots:
    last reboot

View cron job logs:
    grep CRON /var/log/syslog

Authentication logs:
    sudo cat /var/log/auth.log

Tail system logs:
    sudo tail -f /var/log/syslog

------------------------------------------------------------

5. Security Hardening & Intrusion Detection
------------------------------------------------------------
Check failed SSH logins:
    sudo grep "Failed password" /var/log/auth.log

Check successful SSH logins:
    sudo grep "Accepted password" /var/log/auth.log

List users with sudo privileges:
    grep '^sudo' /etc/group

Monitor file integrity:
    sudo apt install aide -y && sudo aideinit

Check root command history:
    sudo cat /root/.bash_history

List running services:
    systemctl list-units --type=service --state=running

Disable unnecessary services:
    sudo systemctl disable <service>

Lock user accounts:
    sudo passwd -l <username>

Disable root login:
    sudo passwd -l root

------------------------------------------------------------

6. Real-time Monitoring Tools (Optional)
------------------------------------------------------------
Install htop:
    sudo apt install htop -y

Install glances:
    sudo apt install glances -y

Install nmon:
    sudo apt install nmon -y

Install iftop:
    sudo apt install iftop -y

Install iotop:
    sudo apt install iotop -y

Install netdata (web dashboard):
    bash <(curl -Ss https://my-netdata.io/kickstart.sh)

------------------------------------------------------------

7. Security Audit & Package Verification
------------------------------------------------------------
Verify package integrity:
    sudo apt install debsums -y
    debsums -s

Check installed packages:
    dpkg -l | less

List available updates:
    sudo apt update && sudo apt list --upgradable

Upgrade system:
    sudo apt upgrade -y

Find SUID binaries:
    find / -perm -4000 2>/dev/null

------------------------------------------------------------

8. Log Analysis & Automation
------------------------------------------------------------
Follow live logs:
    sudo tail -f /var/log/auth.log

View multiple logs simultaneously:
    sudo apt install multitail -y
    multitail /var/log/syslog /var/log/auth.log

Setup cron cleanup:
    sudo crontab -e

Backup logs:
    sudo tar czvf logs_backup.tar.gz /var/log

Search for errors or denied entries:
    grep -i "error|fail|denied" /var/log/*

------------------------------------------------------------

Summary:
------------------------------------------------------------
These commands collectively provide a complete toolkit for monitoring,
auditing, and securing Linux systems—ideal for system administrators,
DevOps engineers, and cloud operators (including AWS EC2 Ubuntu hosts).

Tip:
Enable auditd, secure SSH, and centralize logs to a remote server to
ensure accountability and resilience.
