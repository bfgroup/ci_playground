#!/bin/sh

# Usage:
# LLVM_REPO: LLVM repo to obtain clang binaries. Only needed for clang install.
# PACKAGES: Compiler packages to install.

set -e
echo ">>>>>"
echo ">>>>> APT: REPO.."
echo ">>>>>"
sudo -E apt-add-repository -y "ppa:ubuntu-toolchain-r/test"
if test -n "${LLVM_REPO}" ; then
	wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add -
	sudo -E apt-add-repository "deb http://apt.llvm.org/xenial/ ${LLVM_REPO} main"
fi
echo ">>>>>"
echo ">>>>> APT: UPDATE.."
echo ">>>>>"
sudo -E apt-get update
echo ">>>>>"
echo ">>>>> APT: INSTALL ${PACKAGES}.."
echo ">>>>>"
sudo -E apt-get -yq --no-install-suggests --no-install-recommends install ${PACKAGES}
