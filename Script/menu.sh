#!/bin/bash

header() {
clear
echo "============================================================"
echo "                 Linux User & System Management Tool"
echo "------------------------------------------------------------"
echo " Host    : $(hostname)"
echo " User    : $USER"
echo " Date    : $(date)"
echo "============================================================"
echo ""
}

while true; do
header

echo "===================== USER & GROUP MANAGEMENT ====================="
echo "[1] Create User        [2] Create Group        [3] Add User to Group"
echo "[4] List Users         [5] List Groups         [6] Remove User From ALL Groups"
echo "[7] Delete User        [8] Delete Group"
echo "[9] Lock User          [10] Unlock User"
echo ""

echo "===================== ADMIN / SUDO MANAGEMENT ====================="
echo "[11] Make Admin        [12] Remove Admin       [13] Check Admin"
echo ""

echo "===================== SYSTEM MONITORING ============================"
echo "[14] CPU Usage         [15] Memory Usage       [16] Disk Usage"
echo "[17] Running Processes [18] Heavy CPU Proc     [19] Heavy MEM Proc"
echo "[20] htop (UI)         [21] top (UI)"
echo ""

echo "===================== FILE OPERATIONS =============================="
echo "[22] Check File        [23] View File Content  [24] Execute File"
echo ""

echo "===================== APPLICATION ACCESS CONTROL ==================="
echo "[25] Folder Access     [26] Allow Service Restart"
echo "[27] Allow Script Exec [28] Remove App Access"
echo ""

echo "===================== NETWORK TOOLS ================================"
echo "[29] Show IP Address   [30] Ping Host          [31] Traceroute"
echo "[32] Check Open Ports"
echo ""

echo "===================== SERVICE MANAGEMENT ==========================="
echo "[33] Start Service     [34] Stop Service       [35] Restart Service"
echo "[36] Service Status"
echo ""

echo "===================== BACKUP & RESTORE ============================="
echo "[37] Backup Folder     [38] Restore Backup"
echo ""

echo "[Type 'exit', 'quit', or 'bye' to exit]"
echo ""

read -p "Enter your choice: " ch

# Exit by typing keyword
if [[ "$ch" == "exit" || "$ch" == "quit" || "$ch" == "bye" ]]; then
    echo "Exiting..."
    exit
fi

case "$ch" in

# ================= USER & GROUP MANAGEMENT =================

1)
   read -p "Enter username: " user
   sudo useradd "$user"
   echo "Set password:"
   sudo passwd "$user"
   read -p "Press Enter..." ;;

2)
   read -p "Enter group name: " grp
   sudo groupadd "$grp"
   read -p "Press Enter..." ;;

3)
   read -p "Enter username: " user
   read -p "Enter group name: " grp
   sudo usermod -aG "$grp" "$user"
   read -p "Press Enter..." ;;

4)
   cut -d: -f1 /etc/passwd
   read -p "Press Enter..." ;;

5)
   getent group
   read -p "Press Enter..." ;;

6)
   read -p "Enter username: " user
   sudo usermod -G "" "$user"
   sudo rm -f /etc/sudoers.d/$user*
   read -p "Press Enter..." ;;

7)
   read -p "Enter username to delete: " user
   sudo userdel -r "$user"
   read -p "Press Enter..." ;;

8)
   read -p "Enter group name to delete: " grp
   sudo groupdel "$grp"
   read -p "Press Enter..." ;;

9)
   read -p "Enter username to lock: " user
   sudo passwd -l "$user"
   read -p "Press Enter..." ;;

10)
   read -p "Enter username to unlock: " user
   sudo passwd -u "$user"
   read -p "Press Enter..." ;;

# ================= ADMIN / SUDO MANAGEMENT =================

11)
   read -p "Enter username: " user
   sudo usermod -aG sudo "$user"
   echo "$user ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/$user >/dev/null
   read -p "Press Enter..." ;;

12)
   read -p "Enter username: " user
   sudo gpasswd -d "$user" sudo >/dev/null
   sudo rm -f /etc/sudoers.d/$user
   read -p "Press Enter..." ;;

13)
   read -p "Enter username: " user
   groups "$user"
   read -p "Press Enter..." ;;

# ================= SYSTEM MONITORING =================

14)
   uptime
   sudo apt install -y sysstat >/dev/null 2>&1
   mpstat 1 1
   read -p "Press Enter..." ;;

15)
   free -h
   read -p "Press Enter..." ;;

16)
   df -h
   read -p "Press Enter..." ;;

17)
   ps -ef | head -20
   read -p "Press Enter..." ;;

18)
   ps -eo pid,ppid,cmd,%cpu,%mem --sort=-%cpu | head
   read -p "Press Enter..." ;;

19)
   ps -eo pid,ppid,cmd,%mem,%cpu --sort=-%mem | head
   read -p "Press Enter..." ;;

20)
   sudo apt install -y htop >/dev/null 2>&1
   htop ;;

21)
   top ;;

# ================= FILE OPERATIONS =================

22)
   read -p "Enter file path: " file
   if [[ -e "$file" ]]; then ls -lh "$file"; else echo "File not found"; fi
   read -p "Press Enter..." ;;

23)
   read -p "Enter file path: " file
   if [[ -f "$file" ]]; then cat "$file"; else echo "File not found"; fi
   read -p "Press Enter..." ;;

24)
   read -p "Enter script to execute: " runf
   if [[ -x "$runf" ]]; then "$runf"; else echo "Not executable"; fi
   read -p "Press Enter..." ;;

# ================= APPLICATION ACCESS CONTROL =================

25)
   read -p "Enter username: " user
   read -p "Enter folder path: " folder
   read -p "Access (r or rw)? " mode
   if [[ "$mode" == "r" ]]; then
      sudo setfacl -m u:$user:r "$folder"
   else
      sudo setfacl -m u:$user:rw "$folder"
   fi
   read -p "Press Enter..." ;;

26)
   read -p "Enter username: " user
   read -p "Enter service name: " service
   echo "$user ALL=NOPASSWD: /bin/systemctl restart $service" | sudo tee /etc/sudoers.d/${user}-${service} >/dev/null
   read -p "Press Enter..." ;;

27)
   read -p "Enter username: " user
   read -p "Enter script path: " script
   echo "$user ALL=NOPASSWD: $script" | sudo tee /etc/sudoers.d/${user}-script >/dev/null
   read -p "Press Enter..." ;;

28)
   read -p "Enter username: " user
   sudo rm -f /etc/sudoers.d/${user}-*
   read -p "Press Enter..." ;;

# ================= NETWORK TOOLS =================

29)
   ip a
   read -p "Press Enter..." ;;

30)
   read -p "Enter host to ping: " host
   ping -c 4 "$host"
   read -p "Press Enter..." ;;

31)
   read -p "Enter host for traceroute: " host
   sudo apt install -y traceroute >/dev/null 2>&1
   traceroute "$host"
   read -p "Press Enter..." ;;

32)
   sudo apt install -y net-tools >/dev/null 2>&1
   sudo netstat -tulnp
   read -p "Press Enter..." ;;

# ================= SERVICE MANAGEMENT =================

33)
   read -p "Service name to start: " svc
   sudo systemctl start "$svc"
   read -p "Press Enter..." ;;

34)
   read -p "Service name to stop: " svc
   sudo systemctl stop "$svc"
   read -p "Press Enter..." ;;

35)
   read -p "Service name to restart: " svc
   sudo systemctl restart "$svc"
   read -p "Press Enter..." ;;

36)
   read -p "Service name to check status: " svc
   sudo systemctl status "$svc"
   read -p "Press Enter..." ;;

# ================= BACKUP & RESTORE =================

37)
   read -p "Enter folder to backup: " src
   read -p "Enter backup file name (example: backup.tar.gz): " dest
   sudo tar -czvf "$dest" "$src"
   echo "Backup saved as $dest"
   read -p "Press Enter..." ;;

38)
   read -p "Enter backup file to restore: " file
   read -p "Enter restore destination folder: " dest
   sudo tar -xzvf "$file" -C "$dest"
   echo "Backup restored."
   read -p "Press Enter..." ;;

# ================= EXIT =================

*)
   echo "Invalid option."
   read -p "Press Enter..." ;;
esac
done
