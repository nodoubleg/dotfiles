#!/bin/zsh

emulate -L zsh
setopt errexit nounset pipefail

repo_root="${0:A:h}"
presets_dir="$repo_root/starship-presets"
default_output_path="$HOME/.config/starship.toml"
default_host_color="#f5f7f9"
starship_bin="${commands[starship]:-}"
preview_cache_dir="${TMPDIR:-/tmp}/gmason-starship-cache"

typeset -a preset_paths constellation_color_names constellation_colors

constellation_color_names=(
  "starlight white"
  "mission gold"
  "signal blue"
  "survey blue"
  "retro magenta"
  "burnt orange"
  "nvidia green"
  "shell black"
  "shell red"
  "shell green"
  "shell yellow"
  "shell blue"
  "shell magenta"
  "shell cyan"
  "shell white"
  "shell bright black"
  "shell bright red"
  "shell bright green"
  "shell bright yellow"
  "shell bright blue"
  "shell bright magenta"
  "shell bright cyan"
  "shell bright white"
)
constellation_colors=(
  "#f5f7f9"
  "#d7ab61"
  "#2f4c79"
  "#4a668d"
  "#ed73bd"
  "#e06236"
  "#76b900"
  "#000000"
  "#cc0000"
  "#4e9a06"
  "#c4a000"
  "#3465a4"
  "#75507b"
  "#06989a"
  "#d3d7cf"
  "#555753"
  "#ef2929"
  "#8ae234"
  "#fce94f"
  "#729fcf"
  "#ad7fa8"
  "#34e2e2"
  "#eeeeec"
)

usage() {
  cat <<'EOF'
usage: generate_starship_config.zsh

Starts an interactive wizard for choosing a Starship preset and writing a config.
EOF
}

load_presets() {
  preset_paths=("$presets_dir"/*.toml(N))
  (( ${#preset_paths[@]} > 0 )) || {
    print -u2 -- "no presets found in $presets_dir"
    exit 1
  }
}

find_preset_index() {
  local needle="$1"
  local -i i=1

  for i in {1..${#preset_paths[@]}}; do
    [[ "${preset_paths[$i]}" == "$needle" ]] && {
      print -r -- "$i"
      return 0
    }
  done

  return 1
}

default_preset_path() {
  local preferred="$presets_dir/current-gmason.toml"

  if [[ -f "$preferred" ]]; then
    print -r -- "$preferred"
  else
    print -r -- "${preset_paths[1]}"
  fi
}

render_config_file() {
  local preset_path="$1"
  local output_path="$2"
  local host_color="$3"
  local content

  content="$(<"$preset_path")"
  content="${content//__GMASON_USER_HOST_COLOR__/$host_color}"

  {
    print -r -- "# generated from ${preset_path:t}"
    print -r -- "$content"
  } >| "$output_path"
}

render_prompt_preview() {
  local config_path="$1"
  local preview_path="${PWD:A}"

  mkdir -p "$preview_cache_dir"
  STARSHIP_CACHE="$preview_cache_dir" \
  STARSHIP_CONFIG="$config_path" \
  "$starship_bin" prompt \
    --status=0 \
    --cmd-duration=0 \
    --terminal-width="${COLUMNS:-120}" \
    --path "$preview_path" 2>/dev/null
}

print_color_choice() {
  local index="$1"
  local name="$2"
  local hex="$3"
  local red green blue

  red=$(( 16#${hex[2,3]} ))
  green=$(( 16#${hex[4,5]} ))
  blue=$(( 16#${hex[6,7]} ))

  printf '%s\n' "${index}. $(printf '\033[48;2;%d;%d;%dm  \033[0m \033[38;2;%d;%d;%dm%s %s\033[0m' "$red" "$green" "$blue" "$red" "$green" "$blue" "$name" "$hex")" >&2
}

print_preset_menu() {
  local default_preset="$1"
  local preview_color="$2"
  local preset_path preview
  local -i i default_index

  default_index="$(find_preset_index "$default_preset" 2>/dev/null || print 1)"

  print -u2
  print -u2 "Available presets:"
  for (( i = 1; i <= ${#preset_paths[@]}; ++i )); do
    preset_path="${preset_paths[$i]}"
    if (( i == default_index )); then
      print -u2 -- "${i}. ${preset_path:t:r} [default]"
    else
      print -u2 -- "${i}. ${preset_path:t:r}"
    fi
    preview="$(mktemp "${TMPDIR:-/tmp}/starship-preview.XXXXXX")"
    render_config_file "$preset_path" "$preview" "$preview_color"
    render_prompt_preview "$preview" >&2
    rm -f "$preview"
    print -u2
  done
}

choose_preset() {
  local default_preset="$1"
  local preview_color="$2"
  local choice
  local -i default_index

  default_index="$(find_preset_index "$default_preset" 2>/dev/null || print 1)"

  while true; do
    print_preset_menu "$default_preset" "$preview_color"
    read -r "choice?Preset number [${default_index}]: "
    [[ -z "$choice" ]] && choice="$default_index"
    if [[ "$choice" == <-> ]] && (( choice >= 1 && choice <= ${#preset_paths[@]} )); then
      print -r -- "${preset_paths[$choice]}"
      return 0
    fi
    print -u2 -- "Enter a preset number from 1 to ${#preset_paths[@]}."
  done
}

expand_path() {
  local path_value="$1"
  print -r -- "${~path_value}"
}

choose_output_path() {
  local default_path="$1"
  local choice
  local expanded

  while true; do
    read -r "choice?Output path [${default_path}]: "
    [[ -z "$choice" ]] && choice="$default_path"
    expanded="$(expand_path "$choice")"
    if [[ -d "$expanded" ]]; then
      print -u2 -- "Output path is a directory: $expanded"
      continue
    fi
    print -r -- "$expanded"
    return 0
  done
}

choose_host_color() {
  local preset_path="$1"
  local default_color="$2"
  local choice
  local -i i

  while true; do
    print -u2
    print -u2 -- "Preset colors:"
    for (( i = 1; i <= ${#constellation_colors[@]}; ++i )); do
      print_color_choice "$i" "${constellation_color_names[$i]}" "${constellation_colors[$i]}"
    done
    read -r "choice?Host color (number or #RRGGBB) [${default_color}]: "
    [[ -z "$choice" ]] && choice="$default_color"
    if [[ "$choice" == <-> ]] && (( choice >= 1 && choice <= ${#constellation_colors[@]} )); then
      print -r -- "${constellation_colors[$choice]}"
      return 0
    fi

    if [[ "$choice" == \#[[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]][[:xdigit:]] ]]; then
      print -r -- "${choice:l}"
      return 0
    fi

    print -u2 -- "Enter a hex color like #4a668d."
  done
}

confirm_preview() {
  local answer

  while true; do
    read -r "answer?Use this config? [y/n]: "
    case "$answer" in
      y|Y) return 0 ;;
      n|N) return 1 ;;
      *) print -u2 -- "Enter y or n." ;;
    esac
  done
}

main() {
  local selected_preset selected_output_path selected_host_color
  local preview_file

  case "${1:-}" in
    "" )
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

  [[ -n "$starship_bin" ]] || {
    print -u2 -- "starship is not installed or not in PATH"
    exit 1
  }

  load_presets

  selected_preset="$(default_preset_path)"
  selected_output_path="$default_output_path"
  selected_host_color="$default_host_color"

  while true; do
    selected_preset="$(choose_preset "$selected_preset" "$selected_host_color")"
    selected_output_path="$(choose_output_path "$selected_output_path")"
    selected_host_color="$(choose_host_color "$selected_preset" "$selected_host_color")"

    preview_file="$(mktemp "${TMPDIR:-/tmp}/starship-config.XXXXXX")"
    render_config_file "$selected_preset" "$preview_file" "$selected_host_color"

    print
    print "Preview:"
    render_prompt_preview "$preview_file"
    print
    print "Target path: $selected_output_path"
    print "Host color: ${selected_host_color}"

    if confirm_preview; then
      mkdir -p "$(dirname "$selected_output_path")"
      mv "$preview_file" "$selected_output_path"
      print
      print "Wrote ${selected_output_path}"
      return 0
    fi

    rm -f "$preview_file"
  done
}

main "$@"
