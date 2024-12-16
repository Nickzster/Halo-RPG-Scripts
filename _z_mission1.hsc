(script static void cheat_skip_mission1a
    (cheat_complete_mission mission1a pylon_a_field_control)
)

(script continuous mission1a
    ; Pylon A
    (sleep_until (= (device_get_position pylon_a_control_base) 1))
    (if (not (grab_mission_lock 2))(return))
    (update_objective mission1a_objective)
    (print_objective mission1a_dialog_1)
    (sleep 60)
    (print_objective mission1a_dialog_2)
    (sleep 60)
    (show_objective_location fob_bravo)
    (print_objective mission1a_dialog_3)
    (sleep 60)
    (print_objective mission1a_dialog_4)
    (sleep 60)
    (device_set_power pylon_a_field_control 1)
    (sleep_until (mission_ai_eliminated mission1a))
    (device_set_power mission1_a_door1 1)
    (device_set_power mission1_a_door2 1)
    (sleep_until (= (device_get_position pylon_a_field_control) 1))
    (device_set_power pylon_a_field_control 0)
    (remove_location fob_bravo)
    (update_objective rtb_objective)
    (print_objective mission1a_dialog_5)
    (set mission1a_is_completed true)
    (set mission1a_is_available false)
    (device_set_power pylon_a_light 0)
    (release_mission_lock)
    (kill_thread (get_executing_running_thread))
)

(script static void cheat_skip_mission1b
    (cheat_complete_mission mission1b pylon_b_field_control)
)

(script continuous mission1b
    (sleep_until (= (device_get_position pylon_b_control_base) 1))
    (if (not (grab_mission_lock 3))(return))
    (update_objective mission1b_objective)
    (print_objective mission1b_dialog_1)
    (sleep 60)
    (print_objective mission1b_dialog_2)
    (sleep 60)
    (show_objective_location fob_alpha)
    (print_objective mission1b_dialog_3)
    (sleep 60)
    (print_objective mission1b_dialog_4)
    (sleep 60)
    (device_set_power pylon_b_field_control 1)
    (sleep_until (mission_ai_eliminated mission1b))
    (device_set_power mission1_b_door1 1)
    (device_set_power mission1_b_door2 1)
    (sleep_until (= (device_get_position pylon_b_field_control) 1))
    (device_set_power pylon_a_field_control 0)
    (remove_location fob_alpha)
    (update_objective rtb_objective)
    (print_objective mission1b_dialog_5)
    (set mission1b_is_completed true)
    (set mission1b_is_available false)
    (device_set_power pylon_b_light 0)
    (release_mission_lock)
    (kill_thread (get_executing_running_thread))
)

(script static void bootstrap_mission1
    (print "waiting to boostrap mission 1")
    (sleep_until (volume_test_objects ops_center_entrance (players)))
    (print "starting mission 1")
    (print_objective mission1_dialog_1)
    (print_objective mission1_dialog_2)
    (print_objective mission1_dialog_3)
    (set mission1a_is_available true)
    (set mission1b_is_available true)
    (set mission1c_is_available true)
)