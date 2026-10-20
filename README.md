# About

A Fedora UEFI Unified Kernel Image (UKI) example.

This uses the [mkosi 26](https://packages.fedoraproject.org/pkgs/mkosi/mkosi/) and [ukify 259.9](https://packages.fedoraproject.org/pkgs/systemd/systemd-ukify/) Fedora 44 packages.

## Development

Install the [fedora-44-uefi-amd64](https://github.com/rgl/fedora-vagrant) vagrant box.

Create the UKI:

```bash
time vagrant up --no-destroy-on-error | tee provision.log
```

Poke the UKI:

```bash
pushd output
ls -laF
file hello-world.efi
unmkinitramfs hello-world.initrd initrd.tmp
ncdu initrd.tmp
popd
```

Execute the UKI in a VM:

```bash
pushd output
rm -rf boot
install -d boot/EFI/BOOT
install /usr/share/OVMF/OVMF_VARS_4M.fd OVMF_VARS_4M.fd
install hello-world.efi boot/EFI/BOOT/BOOTX64.EFI
qemu-system-x86_64 \
    -enable-kvm \
    -cpu host \
    -smp 4,sockets=1,cores=4,threads=1 \
    -m 4G \
    -drive if=pflash,format=raw,unit=0,file=/usr/share/OVMF/OVMF_CODE_4M.fd,readonly=on \
    -drive if=pflash,format=raw,unit=1,file=OVMF_VARS_4M.fd \
    -drive if=virtio,format=raw,file=fat:boot,readonly=on \
    -nic user,model=virtio,hostfwd=tcp::2022-:22
# hop to the vm console and login as root with the vagrant password.
# then execute the following commands.
cat /etc/os-release
uname -a
timedatectl status
networkctl status
resolvectl status
systemctl status
systemctl status hello-world
journalctl -u hello-world
ip addr
resolvectl query ip6.me
curl http://ip4only.me/api/ # get the vm public ipv4 address.
curl http://ip6only.me/api/ # get the vm public ipv6 address.
curl -4 http://ip6.me/api/  # get the vm public ipv4 address.
curl -6 http://ip6.me/api/  # get the vm public ipv6 address.
# hop to a new terminal on the host machine, then execute the following
# commands.
ssh root@localhost -p 2022
exit
# hop back to the host terminal that is running qemu-system-x86_64, press ctrl+c
# to terminate the vm, then execute the following commands.
popd
```

Destroy everything:

```bash
rm -rf output
vagrant destroy -f
```

## References

* [mkosi(1) man page](https://github.com/systemd/mkosi/blob/v26/mkosi/resources/man/mkosi.1.md)
* [Unified Kernel Images (UKI) Specification](https://uapi-group.org/specifications/specs/unified_kernel_image/)
* ASCII Art
  * [hello-world](https://patorjk.com/software/taag/#p=display&f=Terrace&t=Hello%2C+World%21&x=none&v=4&h=4&w=80&we=false)
  * [motd](https://patorjk.com/software/taag/#p=display&f=Small&t=Hello%2C+World%21&x=none&v=4&h=4&w=80&we=false)
