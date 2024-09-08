function fish_prompt
    if fish_is_root_user
        set div ""
    else 
        set div ""
    end
    set_color -b green; set_color -o black; 
    echo (date "+%H:%M:%S")(set_color -b cyan; set_color -o green)$div(set_color normal; set_color -o black; set_color -b cyan) (prompt_pwd)(set_color -b magenta; set_color cyan)$div(set_color normal ; set_color -o black; set_color -b magenta) (echo $CMD_DURATION)ms(set_color normal; set_color -o black; set_color magenta)$div(set_color normal)" "
end
