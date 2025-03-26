# My computing environment

I use this with [Bluefin-DX](https://docs.projectbluefin.io/). I think Atomic/Immutable distros are a great fit for NixOS. The base system provides a host of nice software and is stable, whereas anything that is project-related can be installed via Nix package manager in user-space.

In fact, having the OS be independent has the advantage that I can use this on Windows with WSL, or MacOS.

# Outline of my setup

- [Bluefin-DX](https://docs.projectbluefin.io/) as the base OS (not mandatory)
- Nix package manager via the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer)
- [Nix home manager](https://github.com/nix-community/home-manager) for configuring the overall home folder
- [Nix direnv](https://github.com/nix-community/nix-direnv) to configure per-project toolchains

# How I bootstrap a new machine

## Nix package manager

Install the Nix package manager using the [Determinate Nix Installer](https://github.com/DeterminateSystems/nix-installer):

```
curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | \
  sh -s -- install
```

- I prefer to use the standard NixOS download therefore I answer no to the first question:

```
INFO nix-installer v3.0.0
Install Determinate Nix?
Selecting 'no' will install Nix from NixOS instead.
Proceed? ([Y]es/[n]o/[e]xplain): n
...
```

- Either start a new terminal or source the Nix environment in the current terminal window to proceed:

```
$ . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
$ nix --version
nix (Nix) 2.26.2
```

## Clone the git repository

This requires that git is pre-installed on the system (which is the case for Bluefin-DX). You could use Homebrew on MacOS or Chocolatey on Windows, or even just download the binaries.

However now that you have the Nix package manager there is no need for that, just:

```
$ nix-shell -p git --run "git clone https://github.com/karypid/dotfiles.git .dotfiles"
Cloning into '.dotfiles'...
remote: Enumerating objects: 18, done.
remote: Counting objects: 100% (18/18), done.
remote: Compressing objects: 100% (17/17), done.
remote: Total 18 (delta 3), reused 16 (delta 1), pack-reused 0 (from 0)
Receiving objects: 100% (18/18), 5.08 KiB | 2.54 MiB/s, done.
Resolving deltas: 100% (3/3), done.
```

The above command uses Nix to install git and run the command, regardless of whether it is already present on the system or not.

## Install Nix home manager

The cloned repo contains a `flake.nix` file that will install home-manager and trigger the home configuration using home-manager.

> There are two important things to note here:
>  1. I use the latest stable version which is currently 24.11 for default `nix-channel` above, make sure you pass the same version into this command
>  2. You may get an failure with message "`error: path '//home' is a symlink`" when using Bluefin/Bazzite/etc, due to your home directory being a symlink. The eaiiest way to get around this is to prepend `HOME=/var/home/_username_' when running that command. Refer to section [Home symlink preparation](#home-symlink-preparation) below for details and an alternative solution.

```
$ cd ~/.dotfiles
$ nix run home-manager/release-24.11 -- init --switch --flake .
The file /var/home/bazzite/.config/home-manager/home.nix already exists, leaving it unchanged...
The file /var/home/bazzite/.config/home-manager/flake.nix already exists, leaving it unchanged...

Creating initial Home Manager generation...

warning: creating lock file '"/var/home/bazzite/.config/home-manager/flake.lock"':
• Added input 'home-manager':
    'github:nix-community/home-manager/0948aeedc296f964140d9429223c7e4a0702a1ff?narHash=sha256-jbqlw4sPArFtNtA1s3kLg7/A4fzP4GLk9bGbtUJg0JQ%3D' (2025-03-22)
• Added input 'home-manager/nixpkgs':
    follows 'nixpkgs'
• Added input 'nixpkgs':
    'github:nixos/nixpkgs/f0946fa5f1fb876a9dc2e1850d9d3a4e3f914092?narHash=sha256-rBfc%2BH1dDBUQ2mgVITMGBPI1PGuCznf9rcWX/XIULyE%3D' (2025-03-23)
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Activating writeBoundary
Activating installPackages
installing 'home-manager-path'
building '/nix/store/i7h4g01wmzpwrqiya6k4683wj6rszygq-user-environment.drv'...
Activating linkGeneration
Creating profile generation 1
Creating home file links in /var/home/bazzite
Activating onFilesChange
Activating reloadSystemd

There are 174 unread and relevant news items.
Read them by running the command "home-manager news".

All done! The home-manager tool should now be installed and you can edit

    /var/home/bazzite/.config/home-manager/home.nix

to configure Home Manager. Run 'man home-configuration.nix' to
see all available options.
```

This should have installed home manager:

```
$ home-manager --version
24.11-pre
```

## Materialize the home configuration

Everything should now be in place for you to materialize the home configuration. There is only one last thing remaining:

> Edit the file flake.nix file and make sure the declaration of the username in the userSettings section matches your actual username. For example, if you are using the user `bazzite` the line should look like this:
>
>   username = "bazzite";

Failure to do this will result in the following error:

```
error: flake 'git+file:///var/home/ACTUAL_USER/.dotfiles' does not provide attribute 'packages.x86_64-linux.homeConfigurations."ACTUAL_USER".activationPackage', 'legacyPackages.x86_64-linux.homeConfigurations."bazzite".activationPackage' or 'homeConfigurations."ACTUAL_USER".activationPackage'
```

If you have the correct username in the flake.nix file, you can now materialize the home configuration with:

```
$ home-manager switch --flake .
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Existing file '/var/home/bazzite/.bash_profile' is in the way of '/nix/store/3kva2kg84g4g488zr0mz2jqyxvqnwah2-home-manager-files/.bash_profile'
Existing file '/var/home/bazzite/.bashrc' is in the way of '/nix/store/3kva2kg84g4g488zr0mz2jqyxvqnwah2-home-manager-files/.bashrc'
Please do one of the following:
- Move or remove the above files and try again.
- In standalone mode, use 'home-manager switch -b backup' to back up
  files automatically.
- When used as a NixOS or nix-darwin module, set
    'home-manager.backupFileExtension'
  to, for example, 'backup' and rebuild.
```

Notice how the default bash configuration is in the way. This is because the system created these files and home manager is being careful not to overwrite them. Either delete them, or move them to  a "BACKUP" folder and try again:

```
bazzite@fedora:~/.dotfiles$ mkdir BACKUP
bazzite@fedora:~/.dotfiles$ mv ~/.bashrc ~/.bash_profile BACKUP/
bazzite@fedora:~/.dotfiles$ home-manager switch --flake .
Starting Home Manager activation
Activating checkFilesChanged
Activating checkLinkTargets
Activating writeBoundary
Activating installPackages
replacing old 'home-manager-path'
installing 'home-manager-path'
building '/nix/store/lxsranpc3cjw5z6bfpmiqdwc6gxhg17z-user-environment.drv'...
Activating linkGeneration
Cleaning up orphan links from /var/home/bazzite
Creating profile generation 2
Creating home file links in /var/home/bazzite
Activating onFilesChange
Activating reloadSystemd

There are 176 unread and relevant news items.
Read them by running the command "home-manager news".
```

## Home symlink preparation

There is currently one thing on Bluefin that is incompatible with my setup:

> The home directory must be a real path, not a symlink. Bluefin-DX and most atomic distros use `/var/home` as the home folder location and symlink it to `/home`. As a result I need to edit `/etc/passwd` and change the home folder to `/var/home` for my user

My user in this example is `bazzite` -- I used [Bazzite](https://bazzite.gg/), another [ublue](https://universal-blue.org/) distribution in a VM -- to write this documentation. This is what the passwd entry looks like

```
$ sudo vi /etc/passwd
[sudo] password for bazzite:

$ grep bazzite /etc/passwd
bazzite:x:1000:1000::/var/home/bazzite:/bin/bash
```

Notice the `/var/home/bazzite` part which was changed instead of the original `/home/bazzite`. The system is now ready to proceed with the installation.

> MAKE SURE TO LOGOUT BEFORE PROCEEDING SO THAT THE CHANGE IS PICKED UP

Another alternative is this: if one of the commands below complains about /home being a symlink, run the same command with `HOME=/var/home/bazzite` prepended to it. For example:

```
$ HOME=/var/home/bazzite nix run home-manager/release-24.11 -- init --switch --flake .

# Instead of:

$ nix run home-manager/release-24.11 -- init --switch --flake .
```
