#!/bin/sh

# Usage:
# XCODE_VERSION = Dotted version of Xcode to install and make active.
# XCODE_INSTALL_USER = Account name for developer.apple.com without TFA.
# XCODE_INSTALL_PASSWORD = Password for that account.

set -e

xc_versions ()
{
	grep -E -e '[>]([[:digit:]]+[.]){1,2}([[:digit:]]+)' ${PWD}/Xcode*/Contents/version.plist | sed -r -e 's/^([^:]+)[:][^>]+[>]([^<]+).*/\1 \2/g'
}

xc_path ()
{
	xc_versions | grep -F "$1" | sed -r -e 's/[[:space:]]+[0-9.]+$//g'
}

if test -n "${XCODE_INSTALL_USER}" ; then
	sudo gem install xcode-install
	xcversion update
	echo ">>>>>"
	echo ">>>>> AVAILABLE.."
	echo ">>>>>"
	xcversion list
	echo ">>>>>"
	echo ">>>>> INSTALLL: Xcode ${XCODE_VERSION}.."
	echo ">>>>>"
	xcversion --verbose --no-progress --no-clean --no-show-release-notes install ${XCODE_VERSION}
	echo ""
	echo ">>>>>"
	echo ">>>>> INSTALL: CLI Tools.."
	echo ">>>>>"
	xcversion --verbose install-cli-tools
	echo ""
	echo ">>>>>"
	echo ">>>>> AVAILABLE.."
	echo ">>>>>"
	xcversion list
	echo ">>>>>"
	echo ">>>>> SELECT: Xcode ${XCODE_VERSION}.."
	echo ">>>>>"
	xcversion select ${XCODE_VERSION} --symlink
else
	pushd /Applications
	echo ">>>>>"
	echo ">>>>> AVAILABLE.."
	echo ">>>>>"
	xc_versions
	echo ">>>>>"
	echo ">>>>> SELECT: Xcode ${XCODE_VERSION}.."
	echo ">>>>>"
	XC_PATH=`xc_path "${XCODE_VERSION}"`
	sudo ln -s "${XC_PATH}" Xcode.app
	sudo xcode-select -s "${PWD}/Xcode.app"
fi

# Use, modification, and distribution are
# subject to the Boost Software License, Version 1.0. (See accompanying
# file LICENSE.txt)
#
# Copyright Rene Rivera 2020.
