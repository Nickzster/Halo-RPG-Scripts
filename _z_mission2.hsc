
(script static void cheat_find_all_intel
    (device_set_position_immediate intel_1_field_control 1)
    (device_set_position_immediate intel_2_field_control 1)
    (device_set_position_immediate intel_3_field_control 1)
)

(script continuous mission2_intel
    (sleep_until 
        (or
            (= (device_get_position intel_1_field_control) 1)
            (= (device_get_position intel_2_field_control) 1)
            (= (device_get_position intel_3_field_control) 1)
        )
    )

    (begin
        (if (= (device_get_position intel_1_field_control) 1)
            (begin
                (device_set_position_immediate intel_1_field_control 0)
                (device_set_power intel_1_field_control 0)
                (set mission2_terminals_discovered (+ mission2_terminals_discovered 1))
                (print_objective found_intel)
            )
        )
    )

    (begin
        (if (= (device_get_position intel_2_field_control) 1)
            (begin
                (device_set_position_immediate intel_2_field_control 0)
                (device_set_power intel_2_field_control 0)
                (set mission2_terminals_discovered (+ mission2_terminals_discovered 1))
                (print_objective found_intel)
            )
        )
    )

    (begin
        (if (= (device_get_position intel_3_field_control) 1)
            (begin
                (device_set_position_immediate intel_3_field_control 0)
                (device_set_power intel_3_field_control 0)
                (set mission2_terminals_discovered (+ mission2_terminals_discovered 1))
                (print_objective found_intel)
            )
        )
    )

    (if (>= mission2_terminals_discovered 3)
        (begin
            (print_objective mission2_discovered_1)
            (print_objective mission2_discovered_2)
            (print_objective mission2_discovered_3)
            (print_objective mission2_discovered_4)
            (if (= mission2_is_available true) (print_objective mission2_discovered_5))
            (if (not (mission_is_currently_active)) (update_objective rtb_objective))
            (set mission2_is_unlocked true)
            (reset_mission_lock)
            (kill_thread (get_executing_running_thread))
        )
    )
)

(script static void cheat_skip_mission2
    (object_cannot_take_damage (players))
    (object_teleport (get_player_object_from 0) oasis_cheat_flag)
    (sleep 30)
    (object_teleport (get_player_object_from 0) base_cheat_flag)
    (object_can_take_damage (players))
    (cheat_complete_mission mission2 oasis_field_control)
    (device_set_position_immediate oasis_field_control 0)
)

(script continuous mission2
    (sleep_until (= mission1a_is_completed true))
    (sleep_until (= mission1b_is_completed true))
    (sleep_until (= mission2_is_unlocked true))
    (sleep_until (= mission2_is_available true))
    (sleep_until (= active_mission_lock false))
    (print "waiting to start mission 2")
    (wait_for_players_to_enter_area ops_center_entrance)
    (if (not (grab_mission_lock 4))(return))
    (print "starting mission 2")
    (update_objective mission2_objective)
    (print_objective mission2_dialog_1)
    (print_objective mission2_dialog_2)
    (show_objective_location forerunner_secret)
    (print_objective mission2_dialog_3)
    (device_set_power mission2_door_1 1)
    (device_set_power mission2_door_2 1)
    (wait_for_players_to_enter_area mission2_boss_trigger)
    (ai_place mission2/oasis_boss)
    (sleep_until (= (device_get_position oasis_field_control) 0))
    (sleep_until (= (mission_ai_eliminated mission2) true))
    (remove_location forerunner_secret)
    (device_set_power oasis_field_control 0)
    (print_objective mission2_dialog_4)
    (print_objective mission2_dialog_5)
    (print_objective mission2_dialog_6)
    (update_objective rtb_objective)
    (set mission2_is_completed true)
    (set mission2_is_available false)
    (release_mission_lock)
    (kill_thread (get_executing_running_thread))
)