#!/bin/zsh

emulate -L zsh
setopt errexit nounset pipefail

zmodload zsh/datetime
zmodload zsh/stat

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/gmason-shell"
LOCK_DIR="$CACHE_DIR/.locks"
SSH_CACHE_FILE="$CACHE_DIR/ssh-hosts.txt"
MAX_AGE_SECONDS=""
CHECK_INPUTS_NEWER=false

usage() {
  cat <<'EOF'
usage: update_shell_caches.sh ssh-hosts [--if-older-than SECONDS] [--if-inputs-newer]
EOF
}

file_mtime() {
  local -A stat_result

  zstat -H stat_result -- "$1"
  print -r -- "${stat_result[mtime]}"
}

input_files_newer_than_cache() {
  local cache_file="$1"
  shift
  local cache_mtime=0
  local input_file

  [[ -f "$cache_file" ]] && cache_mtime="$(file_mtime "$cache_file")"

  for input_file in "$@"; do
    [[ -r "$input_file" ]] || continue
    if (( $(file_mtime "$input_file") > cache_mtime )); then
      return 0
    fi
  done

  return 1
}

should_refresh() {
  local cache_file="$1"
  shift
  local age

  [[ -f "$cache_file" ]] || return 0

  if [[ -n "$MAX_AGE_SECONDS" ]]; then
    age=$(( EPOCHSECONDS - $(file_mtime "$cache_file") ))
    (( age >= MAX_AGE_SECONDS )) && return 0
  fi

  if [[ "$CHECK_INPUTS_NEWER" == true ]] && input_files_newer_than_cache "$cache_file" "$@"; then
    return 0
  fi

  return 1
}

build_ssh_hosts_cache() {
  local tmp_file lock_path
  local -a hosts=()
  local host known_hosts_file
  typeset -U hosts

  mkdir -p "$CACHE_DIR" "$LOCK_DIR"
  lock_path="$LOCK_DIR/ssh-hosts.lock"
  mkdir "$lock_path" 2>/dev/null || exit 0
  trap "rmdir '$lock_path'" EXIT

  if ! should_refresh "$SSH_CACHE_FILE" \
    "$HOME/.ssh/config" \
    "$HOME/.ssh/known_hosts" \
    "$HOME/.ssh/known_hosts2"
  then
    exit 0
  fi

  if [[ -r "$HOME/.ssh/config" ]]; then
    while IFS= read -r host; do
      [[ -n "$host" ]] && hosts+=("$host")
    done < <(
      awk '
        /^[[:space:]]*Host[[:space:]]+/ {
          for (i = 2; i <= NF; i++) {
            if ($i !~ /[*?]/) {
              print $i
            }
          }
        }
      ' "$HOME/.ssh/config"
    )
  fi

  for known_hosts_file in "$HOME/.ssh/known_hosts" "$HOME/.ssh/known_hosts2"; do
    [[ -r "$known_hosts_file" ]] || continue
    while IFS= read -r host; do
      [[ -n "$host" ]] && hosts+=("$host")
    done < <(
      awk '
        /^[^|#]/ {
          split($1, entries, ",")
          print entries[1]
        }
      ' "$known_hosts_file"
    )
  done

  tmp_file="$(mktemp "$CACHE_DIR/ssh-hosts.XXXXXX")"
  {
    if (( ${#hosts[@]} > 0 )); then
      for host in "${hosts[@]}"; do
        print -r -- "$host"
      done
    fi
  } > "$tmp_file"
  mv "$tmp_file" "$SSH_CACHE_FILE"
}

command_name="${1:-}"
shift || true

while (($#)); do
  case "$1" in
    --if-older-than)
      MAX_AGE_SECONDS="${2:-}"
      shift 2
      ;;
    --if-inputs-newer)
      CHECK_INPUTS_NEWER=true
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      usage
      exit 1
      ;;
  esac
done

case "$command_name" in
  ssh-hosts)
    build_ssh_hosts_cache
    ;;
  *)
    usage
    exit 1
    ;;
esac
