# Debian Pre-Seed Files

This directory holds pre-seed files for automatically installing debian bulleyes with minimal options during the setup process. Additional pre-seeds will be added as needed.

## Boot Image

When booting a virtual machine that has HTTP/FTP capabilities for the install, set the current URL for debian bullseye.
http://ftp.au.debian.org/debian/dists/bullseye/main/installer-amd64/

To boot physical hardware, download the netboot iso from debian website

## Booting With Preseed

Once the source image location has been located and set enter the following as the boot parameters for the kernel:
url=https://raw.githubusercontent.com/geoffh1977/kubernetes-gitops-cluster/main/debian/preseed.cfg auto=true 

## Setting The Hostname And Domain

To not be asked about the hostname and domain during setup, append the following to the kernel boot options:
netcfg/get_hostname=debian netcfg/get_domain=localdomain 

## Changing the encrypted password

To set the password in the pre-seed file, use the following command on another system and copy/paste the resulting string:

```bash
printf "please-change-password" | mkpasswd -s -m sha-512
```

*N.B. If you need the mkpasswd command under Debian, install the whois package*
