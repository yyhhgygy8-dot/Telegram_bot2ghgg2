# WireGuard Panel — Flux Orbit build

This package adds an Orbit/Flux deployment layer around the original WireGuard Panel.

## Deploy

1. Push this repository to GitHub/GitLab/Bitbucket.
2. Open https://orbit.runonflux.com/.
3. Paste the repository URL.
4. Set the application port to **3000**.
5. Optional environment variable: `FLASK_SECRET_KEY`.
6. Deploy.

Orbit can auto-detect/build Git applications, but this repository includes a Dockerfile so the runtime is explicit.

## Important limitation

The original project is a **host-level WireGuard management panel**. It expects `/etc/wireguard`, `wg-quick`, iptables/nftables, root privileges and systemd. A normal Orbit web deployment is a container and does not automatically grant the Linux kernel networking capabilities required to create/manage WireGuard interfaces.

Therefore this build makes the **web panel itself Orbit-deployable**, but it does **not** magically make kernel-level WireGuard tunneling available inside an unprivileged Orbit container.

For real VPN traffic, use a Flux/VM/node/container runtime that explicitly provides WireGuard support and `CAP_NET_ADMIN` (and the required networking privileges), or connect this panel to a separate WireGuard host/backend.
