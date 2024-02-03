(script static void cheat_skip_mission3
    (ai_erase level_patrols)
)

(script continuous mission3
    (sleep_until (and (= mission2_is_completed true) (= mission3_is_available true)))
    (print "waiting to start mission 3")
    (wait_for_players_to_enter_area ops_center_entrance)
    (if (not (grab_mission_lock 5))(return))
    (print "starting mission 3")
    (object_create_anew_containing "ending_human_ship")
    (object_create_anew_containing "hg")
    (object_create_anew_containing "sn")
    (update_objective mission3_objective)
    (print_objective mission3_dialog_1)
    (print_objective mission3_dialog_2)
    (print_objective mission3_dialog_3)
    (print_objective mission3_dialog_4)
    (print_objective mission3_dialog_5)
    (print_objective mission3_dialog_6)
    (print_objective mission3_dialog_7)
    (print_objective mission3_dialog_8)
    (sleep_until (and (mission_ai_eliminated level_patrols) (= is_player_in_base false)))
    (print_objective mission3_dialog_9)
    (set mission3_is_completed true)
    (set mission3_is_available false)
    (set is_ending_sequence true)
    (update_objective mission3_objective)
    (release_mission_lock)
    (kill_thread (get_executing_running_thread))

)