#!/bin/bash

# user permission check
if [ ! $(id -u) = 0 ]; then
  echo "Error: Tor2web install script must be runned by root"
  exit 1
fi

# Preliminary Requirements Check
ERR=0
echo "Checking preliminary Tor2web requirements"
for REQ in apt-key apt-get
do
  if which $REQ >/dev/null; then
    echo " + $REQ requirement meet"
  else
    ERR=$(($ERR+1))
    echo " - $REQ requirement not meet"
  fi
done

if [ $ERR -ne 0 ]; then
  echo "Error: Found ${ERR} unmet requirements"
  exit 1
fi

DO () {
  if [ -z "$2" ]; then
    EXPECTED_RET=0
  else
    EXPECTED_RET=$2
  fi
  if [ -z "$3" ]; then
    CMD=$1
  else
    CMD=$3
  fi
  echo -n "Running: \"$CMD\"... "
  eval $CMD &>${LOGFILE}

  STATUS=$?

  echo $CMD > $TMPDIR/last_command
  echo $STATUS > $TMPDIR/last_status

  if [ "$STATUS" -eq "$EXPECTED_RET" ]; then
    echo "SUCCESS"
  else
    echo "FAIL"
    echo "Ouch! The installation failed."
    echo "COMBINED STDOUT/STDERR OUTPUT OF FAILED COMMAND:"
    cat ${LOGFILE}
    exit 1
  fi
}

LOGFILE="./install.log"
ASSUMEYES=0

GLOBALEAKS_PGP_KEY="
-----BEGIN PGP PUBLIC KEY BLOCK-----

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
=0i3e
-----END PGP PUBLIC KEY BLOCK-----"

for arg in "$@"; do
  shift
  case "$arg" in
    --assume-yes ) ASSUMEYES=1; shift;;
    -- ) shift; break;;
    * ) break;;
  esac
done

DISTRO="unknown"
DISTRO_CODENAME="unknown"
if which lsb_release >/dev/null; then
  DISTRO="$(lsb_release -is)"
  DISTRO_CODENAME="$(lsb_release -cs)"
  REAL_DISTRO=$DISTRO
  REAL_DISTRO_CODENAME=$DISTRO_CODENAME
fi

# LinuxMint is based on Ubuntu, if we encounter Mint just allign the Ubuntu version is based upon
if [ "$DISTRO" == "LinuxMint" ]; then
  DISTRO="Ubuntu"
  DISTRO_CODENAME=$(grep UBUNTU_CODENAME /etc/os-release | sed -e 's/UBUNTU_CODENAME=//')
fi

# The supported platforms are experimentally more than only Ubuntu as
# publicly communicated to users.
#
# Depending on the intention of the user to proceed anyhow installing on
# a not supported distro we using the experimental package if it exists
# or buster as fallback.
if echo "$DISTRO_CODENAME" | grep -vqE "^(buster|bionic)"; then
  # In case of unsupported platforms we fallback on Buster
  echo "Detected OS: $DISTRO - $DISTRO_CODENAME, which is not supported: fallback to 'buster'"
  DISTRO="Debian"
  DISTRO_CODENAME="buster"
else
    echo "Detected OS: $DISTRO - $DISTRO_CODENAME"
fi

echo "Adding GlobaLeaks PGP key to trusted APT keys"
TMPFILE=$TMPDIR/globaleaks_key
echo "$GLOBALEAKS_PGP_KEY" > $TMPFILE
DO "apt-key add $TMPFILE"
DO "rm -f $TMPFILE"

DO "apt-get update -y"

echo "Installing software-properties-common"
DO "apt-get install software-properties-common -y"

# try adding universe repo only on Ubuntu
if echo "$DISTRO" | grep -qE "^(Ubuntu)$"; then
  if ! grep -q "^deb .*universe" /etc/apt/sources.list /etc/apt/sources.list.d/*; then
    echo "Adding Ubuntu Universe repository"
    DO "add-apt-repository 'deb http://archive.ubuntu.com/ubuntu $DISTRO_CODENAME universe'"
  fi
fi

if [ ! -f /etc/apt/sources.list.d/globaleaks.list ]; then
  # we avoid using apt-add-repository as we prefer using /etc/apt/sources.list.d/globaleaks.list
  echo "deb http://deb.globaleaks.org $DISTRO_CODENAME/" > /etc/apt/sources.list.d/globaleaks.list
fi

DO "apt-get update -y"
DO "apt-get install tor2web -y"
