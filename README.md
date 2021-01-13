# There's nothing like `~`!

### Unlock GNOME Keyring at login

1. Create a new keyring named `login` and set it as default (via `seahorse`)
2. Add the following to `/etc/pam.d/login`
   ```
   auth       optional     pam_gnome_keyring.so
   session    optional     pam_gnome_keyring.so auto_start
   ```
3. Reboot and test
