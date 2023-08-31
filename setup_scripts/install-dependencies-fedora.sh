#!/bin/bash
# Dependecies for building the gcc cross-compiler for i386-elf

sudo dnf instll nasm qemu qemu-kvm
sudo dnf groupinstall "Development Tools" "Development Libraries"
sudo dnf install curl bison flex gmp-devel libmpc-devel mpfr-devel texinfo