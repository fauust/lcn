#!/usr/bin/env bash

set -o nounset
set -o pipefail
set -o posix

# Return value
typeset -ri RETURN_OK=0
typeset -ri RETURN_NO_FILE=1
typeset -ri RETURN_NOT_STARTED=4
typeset -ri RETURN_MODIFIED=3
typeset -ri RETURN_UNKNOWN=2

err() {
  echo >&2 "$*"
}

# Make sure only root can run this
(($(id -u) == 0)) || err "This script must be run as root"

usage() {
  cat >&2 <<-EOF
  Usage : $0
    -d debug mode (show diff)
    -h help
EOF
}

typeset VAR_DEBUG_MODE=""

while getopts "dh" OPTION; do
  case $OPTION in
    d)
      VAR_DEBUG_MODE="yes"
      ;;
    h)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

[[ -x /usr/sbin/nft ]] || {
  err "/usr/sbin/nft command not found"
  exit "$RETURN_UNKNOWN"
}

typeset -r VAR_SECURITY_FILE="/etc/security/.md.conf"

if [[ ! -f $VAR_SECURITY_FILE ]]; then
  echo $RETURN_NO_FILE
  exit $RETURN_NO_FILE
else
  VAR_ORIGINAL_RULES=$(sed -e '/chain f2b-*/,/}/d' -e '/chain INPUT {/,/}/d' $VAR_SECURITY_FILE | grep -vE '(f2b|^$)')
fi

# determine nftables config file (Debian/Alpine)
[[ -f /etc/nftables.conf ]] && VAR_NFTABLES_CONF="/etc/nftables.conf"
[[ -f /etc/nftables.nft ]] && VAR_NFTABLES_CONF="/etc/nftables.nft"

# check that nftables is started (and command allowed)
if grep "^# manual nftables (raw)" "$VAR_NFTABLES_CONF" >/dev/null; then
  # on manual firewall, ip and ip6 chain are defined.
  VAR_ACTUAL_RULES_TMP=$(nft -s list ruleset 2>/dev/null)
else
  # on templated firewall, there is no ip and ip6 chain.
  # if there is an ip chain it was created by fail2ban and we don't want it.
  VAR_ACTUAL_RULES_TMP=$(nft -s list ruleset inet 2>/dev/null)
fi
VAR_ACTUAL_RULES=$(echo "$VAR_ACTUAL_RULES_TMP" | sed -e '/chain f2b-*/,/}/d' -e '/chain INPUT {/,/}/d' | grep -vE '(f2b|^$)')
if (($(echo "$VAR_ACTUAL_RULES" | wc -l) < 3)); then
  echo $RETURN_NOT_STARTED
  exit $RETURN_NOT_STARTED
fi

# verify that nftables ruleset has not been modified
if [[ $VAR_ORIGINAL_RULES != "$VAR_ACTUAL_RULES" ]]; then
  if [[ $VAR_DEBUG_MODE == "yes" ]]; then
    echo "diff: <ORIGINAL_RULES|ACTUAL_RULES>"
    diff <(echo "$VAR_ORIGINAL_RULES") <(echo "$VAR_ACTUAL_RULES")
    echo ""
  fi
  echo $RETURN_MODIFIED
  exit $RETURN_MODIFIED
else
  echo $RETURN_OK
  exit $RETURN_OK
fi
