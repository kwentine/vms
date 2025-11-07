dry_run=0

usage() {
  local ret=0
  [[ "${1:-}" == -h ]] || { ret=1; exec >&2; }
  sed -n "/^#+/{s/^#+ \?//; s/SCRIPT/${SCRIPT}/; p}" "$0"
  exit "${ret}"
}

run() {
  ((dry_run)) && { echo "$@" >&2; return; }
  "$@"
}
