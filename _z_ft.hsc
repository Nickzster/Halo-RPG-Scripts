; 0 - alpha
; 1 - bravo
(global short selected_travel_location 0)

(script static void abort_travel
    (ai_erase marines_pelican)
    (remove_location base_hangar)
    (object_destroy pn1)
    (print "pelican travel aborted")
)

(script static void (debug_travel_location (short location))
    (cond 
        (
            (= location 0)
            (print "traveling to village...")
        )
        (
            (= location 1)
            (print "traveling to mountain...")
        )
    )
)

(script static boolean pelican_test_seat_for_player 
    (or 
        (= (vehicle_test_seat pn1 "P-riderRF" (unit (list_get (players) 0))) 1)
        (= (vehicle_test_seat pn1 "P-riderLF" (unit (list_get (players) 0))) 1)
    )
)


; exec_travel is a generic function to handle a pelican drop
(script static void (exec_travel (short location) (short drop_vehicle_timeout) (short drop_players_timeout) (cutscene_recording dropoff) (cutscene_flag starting_point))
    (pelican_load_marines)
    ; Set objective flag over pelican
    (show_base_location base_hangar)
    ; Wait for player to enter pelican
    (sleep_until (or 
        (= is_player_in_base false)
        (!= selected_travel_location location)
        (= (pelican_test_seat_for_player) true)
    ))

    (cond 
        ; abort sequence
        ; if player leaves the base without pelican, abort the travel sequence
        (
            (= is_player_in_base false) 
            (abort_travel)
        )
        ; swap sequence
        ; player changed locations: abort the travel sequence
        (
            (!= selected_travel_location location)
            (print "pelican travel aborted: player changed location")
        )
        (
            (= (pelican_test_seat_for_player) true)
            (begin 
                (remove_location base_hangar)
                (exit_base_pelican_hover)
                (debug_travel_location location)
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
)

; bravo
(script continuous handle_mountain_ft_v2
    (sleep_until (= mountain_dp_unlocked true))
    (sleep_until (= (device_get_position ft_mountain_control) 1))
    (device_set_position_immediate ft_mountain_control 0)
    (device_set_power ft_mountain_control 0)
    (if (= current_mission 6) (kill_thread (get_executing_running_thread)))
    (device_set_power ft_mountain_light 1)
    (set selected_travel_location 1)
    (print "player queued mountain for ft")
    ; Vehicle deployment: 25 to 27 seconds
    ; Player deployment: 36 to 38 seconds
    (exec_travel 1 1893 1539 pelican_bravo_dropoff_1 launch_supply_pad_bravo)
    (print "mountain travel sequence completed")
    (device_set_power ft_mountain_control 1)
    (device_set_power ft_mountain_light 0)
)

; alpha
(script continuous handle_village_ft_v2
    (sleep_until (= village_dp_unlocked true))
    (sleep_until (= (device_get_position ft_village_control) 1))
    (device_set_position_immediate ft_village_control 0)
    (device_set_power ft_village_control 0)
    (if (= current_mission 6)(kill_thread (get_executing_running_thread)))
    (device_set_power ft_village_light 1)
    (set selected_travel_location 0)
    (print "player queued village for ft")
    ; Vehicle deployment: 84s to 86s
    ; Player deployment: 93s to 95s
    (exec_travel 0 1705 1407 pelican_alpha_dropoff_1 launch_supply_pad_alpha)
    (print "village travel sequence completed") 
    (device_set_power ft_village_control 1)
    (device_set_power ft_village_light 0)
)