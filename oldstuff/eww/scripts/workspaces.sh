#!/usr/bin/env bash

monitor="$1"

gib_workspace_names() {
  wmctrl -d \
    | awk '{ print $1 " " $2 " " $9 }'
}

gib_workspace_yuck() {
  buffered=""
  gib_workspace_names | while read -r id active name; do
    name="${name#*_}"
    if [ "$active" == '*' ]; then
      button_name=""
      active_class="active"
      button_class="empty"
    else
      active_class="inactive"
      if wmctrl -l | awk '{ print $2 }' | grep --regexp $id >/dev/null; then
        button_class="occupied"
        button_name=""
      else
        button_class="empty"
        button_name=""
      fi
    fi

    buffered+="(button :class \"workspace_button $button_class $active_class\"  :onclick \"wmctrl -s $id\" \"$button_name\")"
    echo -n "$buffered"
    buffered=""
  done
}

xprop -spy -root _NET_CURRENT_DESKTOP | while read -r; do
  echo '(box :orientation "h" :class "workspaces" :space-evenly true :halign "center" :valign "center" :vexpand true '"$(gib_workspace_yuck)"')'
done
