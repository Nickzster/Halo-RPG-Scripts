(global boolean bravov2 false)

; Bravo
(script continuous handle_mountain_ft
    (sleep_until (= mountain_dp_unlocked true))
    (sleep_until (= (device_get_position ft_mountain_control) 1))
    (sleep_until (= bravov2 false))
    (device_set_position_immediate ft_mountain_control 0)
    (print "fast traveling to mountain...")
    (fade_out 0 0 0 60)
    (sleep 90)
    (object_create_anew ft_mountain_hg)
    (exit_base)
    (object_teleport (get_player_object_from 0) ft_mountain_0)
    (object_teleport (get_player_object_from 1) ft_mountain_1)
    (object_teleport (get_player_object_from 2) ft_mountain_2)
    (object_teleport (get_player_object_from 3) ft_mountain_3)
    (fade_in 0 0 0 60)
)
; Bravo V2
; Vehicle deployment: 25 to 27 seconds
; Player deployment: 36 to 38 seconds

(script static void exec_bravo_travel
    ; Set objective flag over pelican
    (show_base_location base_hangar)
    ; Wait for player to enter pelican
    (sleep_until (or 
        (= (vehicle_test_seat pn1 "P-riderRF" (unit (list_get (players) 0))) 1)
        (= (vehicle_test_seat pn1 "P-riderLF" (unit (list_get (players) 0))) 1)
    ))
    (print "traveling to mountain...")
    ; Disable player input 
    (player_enable_input 0)
    (sleep 30)
    ; Play hover animation
    (pelican_hover)
    (sleep_until (= (recording_time pn1) 150))
    (fade_out 0 0 0 120)
    (sleep 150)
    (sleep_until (= (recording_time pn1) 0))
    (object_create_anew ft_mountain_hg)
    ; Attach warthog to pelican
    (objects_attach pn1 "cargo" ft_mountain_hg "")
    ; Teleport pelican to launch_supply_pad_bravo
    ; Play and delete pelican_bravo_dropoff_1
    (pelican_launch_to_bravo)
    (fade_in 0 0 0 90)
    ; Sleep 25 * 30
    (sleep (in_seconds 25))
    ; Drop vehicle
    (print "dropping vehicle")
    (objects_detach pn1 ft_mountain_hg)
    ; Sleep 11 * 30
    (sleep (in_seconds 11))
    ; Drop player
    (print "dropping player")
    (player_enable_input 1)
    (vehicle_unload pn1 "")
    (unit_set_enterable_by_player pn1 0)
    (exit_base)
)

(script continuous handle_mountain_ft_v2
    (sleep_until (= mountain_dp_unlocked true))
    (sleep_until (= (device_get_position ft_mountain_control) 1))
    (sleep_until (= bravov2 true))
    (device_set_position_immediate ft_mountain_control 0)
    (exec_bravo_travel)

)

(global boolean alphav2 false)

; Alpha
(script continuous handle_village_ft
    (sleep_until (= village_dp_unlocked true))
    (sleep_until (= (device_get_position ft_village_control) 1))
    (sleep_until (= alphav2 false))
    (device_set_position_immediate ft_village_control 0)
    (print "fast traveling to village...")
    (fade_out 0 0 0 60)
    (sleep 90)
    (object_create_anew ft_village_hg)
    (exit_base)
    (object_teleport (get_player_object_from 0) ft_village_0)
    (object_teleport (get_player_object_from 1) ft_village_1)
    (object_teleport (get_player_object_from 2) ft_village_2)
    (object_teleport (get_player_object_from 3) ft_village_3)
    (fade_in 0 0 0 60)
)

; Alpha V2
; Vehicle deployment: 84s to 86s
; Player deployment: 93s to 95s
(script continuous handle_village_ft_v2
    (sleep_until (= village_dp_unlocked true))
    (sleep_until (= (device_get_position ft_village_control) 1))
    (sleep_until (= alphav2 true))
    (device_set_position_immediate ft_village_control 0)
    ; Set objective flag over pelican
    ; Wait for player to enter pelican
    (print "traveling to village...")
    ; Play hover animation
    (fade_out 0 0 0 60)
    (sleep 90)
    (object_create_anew ft_village_hg)
    ; Attach warthog to pelican
    ; Teleport pelican to launch_supply_pad_alpha
    ; Play and delete pelican_alpha_dropoff_1
    (fade_in 0 0 0 60)
    (exit_base)
    ; Sleep 84 * 30
    ; Drop vehicle
    ; Sleep 10 * 30
    ; Drop player
    ; Enable input
)