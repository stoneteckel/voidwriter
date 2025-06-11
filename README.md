# VOIDWRITER v1.0.1

***Cyber-formatting utility for terminal sorcerers.***

No GUI. No forgiveness. Just pure storage obliteration.

---

## SYSTEM BREACH WARNING

> This script will **completely wipe** the selected drive.  
> All data will be lost in the digital ether.  
> There is **no undo**, no rollback, no mercy.

VOIDWRITER is not for the faint of heart.  
It is a terminal-native exorcist for ghost-ridden disks.

---

## FEATURES

- Detects all storage drives with size and model
-  Prevents you from formatting mounted partitions (with optional force unmount)
- Nukes the partition table with `wipefs` + `sgdisk`
- Rebuilds clean GPT partitions via `parted`
- Supports `ext4`, `xfs`, and `btrfs`
- Verifies that necessary filesystem tools are installed **before proceeding**
- Smooth typewriter & glitch text effects for peak immersion
- Final confirmation ritual: type `VOID` to proceed
- 100% Bash. No dependencies outside common CLI tools.

---

## USAGE RITUAL

```bash
chmod +x voidwriter.sh
sudo ./voidwriter.sh
Requires root access (sudo) because you are literally rewriting partitions like a digital necromancer.
```

---

## REQUIRED SPELL COMPONENTS

Make sure the following tools are installed (package names may vary by distro):

```bash
sudo apt install parted gdisk util-linux btrfs-progs xfsprogs
```

---

## CUSTOMIZATION & CONTRIBUTION
VOIDWRITER is open to modification, remixing, and personalization.

### Future ideas
- LUKS encryption support

- Add filesystem label customization

- TUI (Terminal UI) with dialog or fzf

- Integration with secure erase / blkdiscard

- Live ISO / initramfs mode

---

## Changelog
**v1.0.1 - D-Bus Whisperer Patch**  
- Cybernodes now receive proper filesystem labels.  
- Fixes mysterious "No object for D-Bus interface" when exploring freshly formatted XFS volumes.  
- Partitions are now auto-mounted by mortal file explorers without manual summoning.

## LICENSE: THE VOID CODE

Licensed under the MIT License.

