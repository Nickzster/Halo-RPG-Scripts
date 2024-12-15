(script static boolean bypass_weapon_side_quests
    (= player_is_naughty true)
)

(script static void unlock_effect
    (fade_out 0.05 0.17 0.32 15)
    (fade_in 0.05 0.17 0.32 15)
)

(script static void (unlock_weapon (hud_message weapon_name)(string weapon_spawn_name))
    (if (bypass_weapon_side_quests) (return))
    (sound_impulse_start sound\sfx\ui\pickup_dbl_time "none" 1)
    (unlock_effect)
    (print_objective weapon_name)
    (object_create_anew_containing weapon_spawn_name)
)

(script static boolean (player_is_holding_weapon (object_definition weap))
    (or
            (unit_has_weapon (unit (list_get (players) 0)) weap)
            (unit_has_weapon (unit (list_get (players) 1)) weap)
    )
)

(script continuous check_unlock_sniper
    (sleep_until (player_is_holding_weapon sniper_ref))
    (unlock_weapon unlocked_sniper "sr")
    (set sniper_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_rocket_launcher
    (sleep_until (player_is_holding_weapon rocket_launcher_ref))
    (unlock_weapon unlocked_rocket "rl")
    (set rocket_launcher_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_plasma_cannon
    (print "starting plasma cannon sq")
    (sleep_until (player_is_holding_weapon plasma_cannon_ref))
    (print "player is holding a plasma cannon")
    (set plasma_cannon_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_flamethrower
    (sleep_until (player_is_holding_weapon flamethrower_ref))
    (unlock_weapon unlocked_flamethrower "ft")
    (set flamethrower_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_shotgun
    (sleep_until (player_is_holding_weapon shotgun_ref))
    (unlock_weapon unlocked_shotgun "sg")
    (set shotgun_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_ma5s
    (sleep_until (player_is_holding_weapon ma5s_ref))
    (unlock_weapon unlocked_ma5s "sa")
    (set ma5s_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script continuous check_unlock_spistol
    (sleep_until (player_is_holding_weapon spistol_ref))
    (unlock_weapon unlocked_spistol "sp")
    (set spistol_unlocked true)
    (kill_thread (get_executing_running_thread))
)

(script static void setup_naughty_boy
    (print "you've been a naughty boy...")
    (turn_off_mission_switches)
    (object_destroy_containing "naughty")
    (device_set_position_immediate special_door_1 0)
    (device_set_position_immediate special_door_2 0)
    (device_set_power special_door_1 0)
    (device_set_power special_door_2 0)
    (device_set_position_immediate base_ops_center_door_2 0)
    (device_set_position_immediate base_ops_center_door_3 0)
    (device_set_position_immediate base_ops_center_door_4 0)
    (device_set_position_immediate base_ops_center_door_5 0)
    (device_set_power base_ops_center_door_2 0)
    (device_set_power base_ops_center_door_3 0)
    (device_set_power base_ops_center_door_4 0)
    (device_set_power base_ops_center_door_5 0)
    (device_one_sided_set ops_center_ext_entrance true)
    (device_set_position_immediate base_ops_center_door_1 1)
    (device_set_power base_ops_center_door_1 0)
)

(script static void handle_naughty_boy_teleport
    (if (>= (objects_distance_to_flag (get_player_object_from 0) naughty_boy_flag) 9)
    (begin
        (object_teleport (get_player_object_from 0) naughty_boy_flag)
    ))
    (if (>= (objects_distance_to_flag (get_player_object_from 1) naughty_boy_flag) 9)
    (begin
        (object_teleport (get_player_object_from 1) naughty_boy_flag)
    ))
)

(script continuous player_kills_captain
    (sleep_until 
        (and 
            (= (ai_living_count base_humans/captain) 0)
            (= player_can_be_naughty true)
            (is_player_in_area naughty_boy_volume)
        )
    )
    (if (= player_is_naughty false)
    (begin
        (fade_out 1 0 0 10)
        (setup_naughty_boy)
        (ai_allegiance_remove human player)
        (sleep 30)
        (fade_in 1 0 0 10)
        (set player_is_naughty true)
    ))
    (remove_all_locations)
    (handle_naughty_boy_teleport)
    (ai_place naughty_boy)
    (ai_magically_see_players naughty_boy)
    (ai_try_to_fight_player naughty_boy)
    (ai_follow_target_players naughty_boy)
    (sleep (in_seconds 10))
)

(script static void cheat_complete_mountain_dp
    (ai_erase mountain_drop_pad)
)

(global boolean mountain_dp_is_available false)
(global boolean mountain_dp_unlocked false)
(script continuous mountain_dp_quest
    (sleep_until (= mountain_dp_is_available true))
    (print "mountain drop pad quest is now available.")
    (device_set_power unlock_ft_mountain_control 1)
    (sleep_until (= (device_get_position unlock_ft_mountain_control) 1))
    (if (not (grab_mission_lock -2)) (return))
    (device_set_position_immediate unlock_ft_mountain_control 0)
    (device_set_power unlock_ft_mountain_control 0)
    (print "starting mountain dp quest")
    (update_objective mountain_dp_objective)
    (print_objective unlock_mountain_dp_1)
    (activate_team_nav_point_flag "default_red" player supply_pad_bravo 0)
    (sleep 60)
    (sleep_until (mission_ai_eliminated mountain_drop_pad))
    (print "mountain dp unlocked")
    (update_objective rtb_objective)
    (remove_location supply_pad_bravo)
    (unlock_effect)
    (print_objective unlocked_mountain_dp)
    (release_mission_lock)
    (set mountain_dp_unlocked true)
    (device_set_power ft_mountain_control 1)
    (kill_thread (get_executing_running_thread))
)

(script static void cheat_complete_village_dp
    (ai_erase village_drop_pad)
)

(global boolean village_dp_is_available false)
(global boolean village_dp_unlocked false)
(script continuous village_dp_quest
    (sleep_until (= village_dp_is_available true))
    (print "village drop pad quest is now available.")
    (device_set_power unlock_ft_village_control 1)
    (sleep_until (= (device_get_position unlock_ft_village_control) 1))
    (if (not (grab_mission_lock -3)) (return))
    (device_set_position_immediate unlock_ft_village_control 0)
    (device_set_power unlock_ft_village_control 0)
    (print "starting village dp quest")
    (update_objective village_dp_objective)
    (print_objective unlock_village_dp_1)
    (activate_team_nav_point_flag "default_red" player supply_pad_alpha 0)
    (sleep 60)
    (sleep_until (mission_ai_eliminated village_drop_pad))
    (print "village dp unlocked")
    (update_objective rtb_objective)
    (remove_location supply_pad_alpha)
    (unlock_effect)
    (print_objective unlocked_village_dp)
    (release_mission_lock)
    (set village_dp_unlocked true)
    (device_set_power ft_village_control 1)
    (kill_thread (get_executing_running_thread))
)

(script dormant bootstrap_ft_quests
    (set village_dp_is_available true)
    (set mountain_dp_is_available true)
)

; (script static void start_ft_side_quest
;     (sleep_until
;         (or
;             (= mission1a_is_completed true)
;             (= mission1b_is_completed true)
;             (= mission1c_is_completed true)
;         )
;     )
;     (print "flamethrower side quest now available")
;     (object_create_anew sq_flamethrower)
; )

; (global boolean start_side_quests false)
; (script continuous setup_side_quests
;     (sleep_until (= start_side_quests true))
;     (print "setting up side quests")
;     (object_create_anew sq_sniper_rifle)
;     (object_create_anew sq_rocket_launcher)
;     (object_create_anew sq_plasma_cannon)
;     (start_ft_side_quest)
;     (kill_thread (get_executing_running_thread))
; )




