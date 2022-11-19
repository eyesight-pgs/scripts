#!/bin/bash

# open folder in nvim when partial name of folder is provided.
# using zoxide to complete the partial folder name.
# using tmux to avoid opening multiple instance of nvim for same folder.
# usage: t <partial folder name>
# ex: t my-proj # this will open "my-project" folder in nvim inside tmux
#
# known issues:
# - this scripts is not working if executed within tmux program.

if path="$(zoxide query $1)"; then
  echo "path: ${path}";
else
  echo "path not found in zoxide database";
  exit;
fi

echo "path found";
dir="$(basename $path)"; 
echo "folder name: $dir";

if tmux attach-session -t $dir; then
  echo "tmux session found, attaching...";
else
  echo "tmux session not found";
  echo "creating new session and attaching to it and opening nivm";
  if tmux new-session -c "$path" -s "$dir" "nvim ."; then
    echo "session $dir created";
  else
    echo "failed to create new tmux session($dir)";
    exit;
  fi
fi


