(script static void cheat_skip_mission3
    (ai_erase level_patrols)
)

(script static boolean is_mission3_obj1_defeated
    (and 
        (mission_ai_eliminated level_patrols/northeast_lower_plateau_wraith1)
        (mission_ai_eliminated level_patrols/northeast_lower_plateau_wraith2)
        (mission_ai_eliminated level_patrols/northeast_lower_plateau_ghost1)
        (mission_ai_eliminated level_patrols/northeast_lower_plateau_ghost2)
        (= is_player_in_base false)
    )
)

(script static boolean is_mission3_obj2_defeated
    (and 
        (mission_ai_eliminated level_patrols/forest_east)
        (= is_player_in_base false)
    )

)

(script static boolean is_mission3_obj3_defeated
    (and 
        (mission_ai_eliminated level_patrols/southwest_wraith_1)
        (mission_ai_eliminated level_patrols/southwest_wraith_2)
        (mission_ai_eliminated level_patrols/southwest_wraith_3)
        (mission_ai_eliminated level_patrols/southwest_gunners)
        (= is_player_in_base false)
    )
)


(global boolean mission3_active false)

(script continuous handle_mission3_obj3
    (sleep_until (= mission3_active true))
    (sleep_until (= (is_mission3_obj3_defeated) true))
    (print "mission3 obj3 defeated")
    (remove_location mission3_obj3)
    (kill_thread (get_executing_running_thread))
)


(script continuous handle_mission3_obj2
    (sleep_until (= mission3_active true))
    (sleep_until (= (is_mission3_obj2_defeated) true))
    (remove_location mission3_obj2)
    (print "mission3 obj2 defeated")
    (kill_thread (get_executing_running_thread))
)


(script continuous handle_mission3_obj1
    (sleep_until (= mission3_active true))
    (sleep_until (= (is_mission3_obj1_defeated) true))
    (remove_location mission3_obj1)
    (print "mission3 obj1 defeated")
    (kill_thread (get_executing_running_thread))
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
    (show_objective_location mission3_obj1)
    (show_objective_location mission3_obj2)
    (show_objective_location mission3_obj3)
    (set mission3_active true)
    (sleep_until 
        (and 
            (= (is_mission3_obj1_defeated) true)
            (= (is_mission3_obj2_defeated) true)
            (= (is_mission3_obj3_defeated) true)
        )
    )
    (set mission3_active false)
    (print_objective mission3_dialog_9)
    (set mission3_is_completed true)
    (set mission3_is_available false)
    (set is_ending_sequence true)
    (update_objective mission3_objective)
    (show_objective_location base_hangar)
    (release_mission_lock)
    (kill_thread (get_executing_running_thread))

)