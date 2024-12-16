(script static void cheat_skip_mission3
    (ai_erase level_patrols)
)

(script static boolean is_mission3_obj1_defeated
    (and 
        (= is_player_in_base false)
        (= is_player_deployed true)
        (<= 
            (+ 
                (ai_living_count level_patrols/northeast_lower_plateau_wraith1)
                (ai_living_count level_patrols/northeast_lower_plateau_wraith2)
                (ai_living_count level_patrols/northeast_lower_plateau_ghost1)
                (ai_living_count level_patrols/northeast_lower_plateau_ghost2)
            )
        1)
    )
)

(script static boolean is_mission3_obj2_defeated
    (and 
        (= is_player_in_base false)
        (= is_player_deployed true)
        (<= (ai_living_count level_patrols/forest_east) 2)
    )

)

(script static boolean is_mission3_obj3_defeated
    (and 
        (= is_player_in_base false)
        (= is_player_deployed true)
        (<= 
            (+ 
                (ai_living_count level_patrols/southwest_wraith_1)
                (ai_living_count level_patrols/southwest_wraith_2)
                (ai_living_count level_patrols/southwest_wraith_3)
                (ai_living_count level_patrols/southwest_gunners)
            )
        1)      
    )
)


(global boolean mission3_active false)
(global boolean mission3_obj1_completed false)
(global boolean mission3_obj2_completed false)
(global boolean mission3_obj3_completed false)

(script continuous handle_mission3
    (sleep_until (= mission3_active true))
    (if (= (is_mission3_obj1_defeated) true)
        (begin
            (print "mission3 obj1 defeated") 
            (set mission3_obj1_completed true)
            (remove_location mission3_obj1)
        )
    )
    (if (= (is_mission3_obj2_defeated) true)
        (begin
            (print "mission3 obj2 defeated") 
            (set mission3_obj2_completed true)
            (remove_location mission3_obj2)
        )
    )
    (if (= (is_mission3_obj3_defeated) true)
        (begin
            (print "mission3 obj3 defeated") 
            (set mission3_obj3_completed true)
            (remove_location mission3_obj3)
        )
    )
    (if (= mission3_is_completed true) (kill_thread (get_executing_running_thread)))
)

(script continuous mission3
    (sleep_until (and (= mission2_is_completed true) (= mission3_is_available true)))
    (print "waiting to start mission 3")
    (sleep_until (volume_test_objects ops_center_entrance (players)))
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
            (= mission3_obj1_completed true)
            (= mission3_obj2_completed true)
            (= mission3_obj3_completed true)
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