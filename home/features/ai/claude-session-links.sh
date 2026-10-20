claude_dir="$HOME/.claude"
projects="$claude_dir/projects"
synced="$claude_dir/synced-projects"
state="$claude_dir/synced-projects-files"
home_prefix=$(printf '%s' "$HOME" | tr -c '[:alnum:]' '-')
tmp_suffix=".claude-session-links.tmp"
max_unguarded_deletions=20

shopt -s nullglob

list_files() {
  find "$1" -type f ! -name "*$tmp_suffix" -printf '%P\t%i\t%T@\n' | sort
}

link_into() {
  local source=$1 destination=$2
  mkdir -p "${destination%/*}"
  ln -f "$source" "$destination$tmp_suffix"
  mv -fT "$destination$tmp_suffix" "$destination"
}

sync_project() {
  local key=$1
  local local_dir="$projects/$home_prefix-$key"
  local shared_dir="$synced/$key"
  local list="$state/$key"
  local -A known=() local_inode=() local_mtime=() shared_inode=() shared_mtime=() present=()
  local -a deletions=()
  local path inode mtime

  [ -L "$local_dir" ] && rm "$local_dir"
  if [ -d "$local_dir" ] && [ -d "$shared_dir" ] && [ -f "$list" ]; then
    while IFS= read -r path; do known[$path]=1; done <"$list"
  fi
  mkdir -p "$local_dir" "$shared_dir"
  find "$local_dir" -type l -delete
  find "$local_dir" "$shared_dir" -name "*$tmp_suffix" -delete

  while IFS=$'\t' read -r path inode mtime; do
    local_inode[$path]=$inode
    local_mtime[$path]=$mtime
  done < <(list_files "$local_dir")
  while IFS=$'\t' read -r path inode mtime; do
    shared_inode[$path]=$inode
    shared_mtime[$path]=$mtime
  done < <(list_files "$shared_dir")

  for path in "${!local_inode[@]}" "${!shared_inode[@]}"; do
    [ -n "${present[$path]:-}" ] && continue
    present[$path]=1
    if [ -n "${local_inode[$path]:-}" ] && [ -n "${shared_inode[$path]:-}" ]; then
      [ "${local_inode[$path]}" = "${shared_inode[$path]}" ] && continue
      if [[ ${local_mtime[$path]} > ${shared_mtime[$path]} ]]; then
        link_into "$local_dir/$path" "$shared_dir/$path"
      else
        link_into "$shared_dir/$path" "$local_dir/$path"
      fi
    elif [ -n "${known[$path]:-}" ]; then
      deletions+=("$path")
    elif [ -n "${local_inode[$path]:-}" ]; then
      link_into "$local_dir/$path" "$shared_dir/$path"
    else
      link_into "$shared_dir/$path" "$local_dir/$path"
    fi
  done

  if ((${#deletions[@]} > max_unguarded_deletions && ${#deletions[@]} * 2 > ${#known[@]})); then
    echo "skipping ${#deletions[@]} deletions in $key: too many at once" >&2
    for path in "${deletions[@]}"; do unset "present[$path]"; done
    for path in "${!known[@]}"; do present[$path]=1; done
  else
    for path in "${deletions[@]}"; do
      rm -f "$local_dir/$path" "$shared_dir/$path"
      unset "present[$path]"
    done
  fi

  printf '%s\n' "${!present[@]}" >"$list$tmp_suffix"
  mv -f "$list$tmp_suffix" "$list"
}

mkdir -p "$projects" "$synced" "$state"
declare -A keys=()
for dir in "$projects/$home_prefix-projects" "$projects/$home_prefix-projects"-* "$projects/$home_prefix--treehouse-"*; do
  [ -d "$dir" ] && keys[${dir#"$projects/$home_prefix-"}]=1
done
for dir in "$synced"/[!.]*; do
  [ -d "$dir" ] && keys[${dir##*/}]=1
done
for key in "${!keys[@]}"; do
  sync_project "$key"
done
