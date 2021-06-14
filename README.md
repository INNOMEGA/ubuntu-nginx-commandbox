# Install script for bringing up and securing an nginx + commandbox server

## NOTE: THIS IS FOR BRINGING UP A CUSTOM EXAMPLE SITE FOR OUR OWN PURPOSES - MODIFY/USE AT YOUR OWN RISK. PLEASE SEE letskillowen and foundeo's scripts for up to date repos!

After bringing a new server online, run the following commands (with sudo or as root) to kick things off

```bash
cd /root
git clone https://github.com/innomega/ubuntu-nginx-commandbox.git
cd ./ubuntu-nginx-commandbox
chmod +x ./install.sh
./install.sh
```

---
Thanks for the inspiration letskillowen/ubuntu-nginx-commandbox and [foundeo/ubuntu-nginx-lucee](https://github.com/foundeo/ubuntu-nginx-lucee) and the early interest and contributions by [Kevin](https://github.com/websolete) and [Little Bobby Two Hands](https://github.com/bhartsfield).
