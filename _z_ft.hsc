(script static void abort_travel
    (ai_erase marines_pelican)
    (remove_location base_hangar)
    (object_destroy pn1)
    (print "pelican travel aborted")
)

; exec_travel is a generic function to handle a pelican drop
(script static void (exec_travel (string message) (short drop_vehicle_timeout) (short drop_players_timeout) (cutscene_recording dropoff) (cutscene_flag starting_point))
    (pelican_load_marines)
    ; Set objective flag over pelican
    (show_base_location base_hangar)
    ; Wait for player to enter pelican
    (sleep_until (or 
        (= (vehicle_test_seat pn1 "P-riderRF" (unit (list_get (players) 0))) 1)
        (= (vehicle_test_seat pn1 "P-riderLF" (unit (list_get (players) 0))) 1)
        (= is_player_in_base false)
    ))
    ; abort sequence
    ; if player leaves the base without pelican, abort the travel sequence
    (if (= is_player_in_base false) 
        (abort_travel)
        (begin 
            (remove_location base_hangar)
            (exit_base_pelican_hover)
            (print message)
            ; Disable player input 
            (player_enable_input 0)
            (sleep 15)
            ; Play hover animation
            (pelican_hover)
            (sleep_until (= (recording_time pn1) 150))
            (fade_out 0 0 0 120)
            (vehicle_unload pelican_hog "")
            (sleep 150)
            (pelican_cleanup_vehicles)
            (sleep_until (= (recording_time pn1) 0))
            (object_create_anew pelican_hog)
            ; Attach warthog to pelican
            (objects_attach pn1 "cargo" pelican_hog "")
            ; Teleport pelican to launch_supply_pad_bravo
            ; Play and delete pelican_bravo_dropoff_1
            (pelican_launch dropoff starting_point)
            (exit_base_pelican_transition)
            (fade_in 0 0 0 90)
            (sleep_until (<= (recording_time pn1) drop_vehicle_timeout) 1)
            ; Drop vehicle
            (print "dropping vehicle")
            (objects_detach pn1 pelican_hog)
            ; 1539 frames remaining for pelican_bravo_dropoff_1 animation
            (sleep_until (<= (recording_time pn1) drop_players_timeout) 1)
            ; Drop player
            (exit_base_pelican_deployed)
            (print "dropping player")
            (player_enable_input 1)
            (vehicle_unload pn1 "")
            (unit_set_enterable_by_player pn1 0)
        )
    )
)

; bravo
(script continuous handle_mountain_ft_v2
    (sleep_until (= mountain_dp_unlocked true))
    (sleep_until (= (device_get_position ft_mountain_control) 1))
    (device_set_position_immediate ft_mountain_control 0)
    ; Vehicle deployment: 25 to 27 seconds
    ; Player deployment: 36 to 38 seconds
    (exec_travel "traveling to mountain..." 1893 1539 pelican_bravo_dropoff_1 launch_supply_pad_bravo)
)

; alpha
(script continuous handle_village_ft_v2
    (sleep_until (= village_dp_unlocked true))
    (sleep_until (= (device_get_position ft_village_control) 1))
    (device_set_position_immediate ft_village_control 0)
    ; Vehicle deployment: 84s to 86s
    ; Player deployment: 93s to 95s
    (exec_travel "traveling to village..." 1705 1407 pelican_alpha_dropoff_1 launch_supply_pad_alpha) 
)