# Talos Linux Configuration Files

Configuration files used to setup Talos Linux into different types of environments and with different configurations.

## Generating Config Files

To Generate a config file to be used with talosctl:

```bash
for G in development/nodes/*.yaml ; do newName=$(basename $G) ; cat "development/config/header.yaml" "$G" "development/config/cluster.yaml" > development/generated/${newName} ; done
```

## Run Machine

```bash
virt-install --name talos-master-1 --memory 2048 --vcpus 2 --disk size=20 --os-variant generic --noautoconsole \
  --install kernel=https://github.com/siderolabs/talos/releases/download/v1.0.4/vmlinuz-amd64,initrd=https://github.com/siderolabs/talos/releases/download/v1.0.4/initramfs-amd64.xz,kernel_args_overwrite=yes,kernel_args="talos.platform=metal init_on_alloc=1 slab_nomerge pti=on init_on_free=1"
```
