(script startup main
    (ai_allegiance player human)
    (set number_of_players player_spawn_count)
    (intro_cinematic)
    (setup_intro_find_base)
    (setup_intro_clear_sequence)
    (object_cannot_take_damage (players))
    (rescue_cinematic)
    (object_can_take_damage (players))
    ; bootstrap base after rescue cinematic
    (ai_place marines_motorpool)
    (enter_base)
    ; end bootstrap
    (device_set_power motor_pool_door 0)
    (tutorial_sequence)
    (device_set_power intel_1_field_control 1)
    (device_set_power intel_2_field_control 1)
    (device_set_power intel_3_field_control 1)
    ; (set start_side_quests true)
    (bootstrap_mission1)
    (device_set_power motor_pool_door 1)
    (release_mission_lock)
    (setup_available_missions)
    (wake bootstrap_ft_quests)
)



; (script continuous mission_manager
;     (sleep_until (rpg_started))
;     (sleep_until (= active_mission_lock false)) ; wait for player to complete mission
;     (print "mission completed")
;     (sleep_until (= is_player_in_base true))
;     (print "player has rtb")
;     (bootstrap_new_missions)
;     (if (mission_is_ready mission1a_is_available mission1a_is_completed) (setup_mission pylon_a_control_base pylon_a_flag))
;     (if (mission_is_ready mission1b_is_available mission1b_is_completed) (setup_mission pylon_b_control_base pylon_b_flag))
;     (if (= mountain_dp_unlocked false) (device_set_power unlock_ft_mountain_control 1))
;     (if (= village_dp_unlocked false) (device_set_power unlock_ft_village_control 1))
;     (if (mission_is_ready mission2_is_available mission2_is_completed mission2_is_unlocked ) (show_base_location base_ops_center_entrance))
;     (if (mission_is_ready mission3_is_available mission3_is_completed) (show_base_location base_ops_center_entrance))
;     (if (mission_is_ready ending_mission_is_available ending_mission_is_completed) (kill_thread (get_executing_running_thread)))
;     (print "waiting for player to make mission decision")
;     (sleep_until (= active_mission_lock true)) ; wait for player to make mission selection
; )
