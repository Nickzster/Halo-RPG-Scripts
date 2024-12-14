(script static void return
    (sleep 0)
)

(script static boolean _true
    (= 1 1)
)

(script static boolean _false
    (= 1 0)
)

(script static boolean (timed_block (short ticks))
    (sleep ticks)
    (_true)
)

(script static void (update_objective (hud_message objective))
    (hud_set_objective_text objective)
)

(script static void (print_objective_with_seconds (hud_message objective) (short seconds))
    (show_hud_help_text 1)
    (hud_set_help_text objective)
    (sleep (* 30 seconds))
    (show_hud_help_text 0)
)

(script static void (print_objective (hud_message objective))
    (print_objective_with_seconds objective 10)
)

(script static short (in_minutes (short minutes))
    (* 30 (* minutes 60))
)

(script static short (in_seconds (short seconds))
    (* seconds 30)
)

(script static object (get_player_object_from (short index))
    (list_get (players) index)
)

(script static void (show_objective_location (cutscene_flag flag))
    (activate_team_nav_point_flag "default_red" player flag 0)
)

(script static void (show_base_location (cutscene_flag flag))
    (activate_team_nav_point_flag "default" player flag 0)
)

(script static void (remove_location (cutscene_flag flag))
    (deactivate_team_nav_point_flag player flag)
)

(script static void (cheat_complete_mission (ai mission_enc) (device switch))
    (ai_erase mission_enc)
    (sleep 30)
    (device_set_position_immediate switch 1)
)

(global boolean disable_game_save false)

(script static void game_save_wrapper
    (if (= disable_game_save false) 
        (begin
            (game_save_cancel)
            (game_save_no_timeout)
        )
    )
)

(script static boolean (mission_is_ready (boolean is_available)(boolean is_completed))
    (and (= is_available true) (= is_completed false) )
)

(script static boolean (mission_is_ready (boolean is_available)(boolean is_completed)(boolean is_unlocked))
    (and (= is_available true) (= is_completed false) (= is_unlocked true) )
)

(script static void (setup_mission_control (device switch) (cutscene_flag location))
    (device_set_power switch 1)
    (activate_team_nav_point_flag "default" player location 0)
)

(script static void (cleanup_mission_control (device switch) (cutscene_flag location))
    (device_set_power switch 0)
    (remove_location location)
)

(script static void remove_all_locations
    (remove_location base_hangar)
    (remove_location base_armory)
    (remove_location base_med_bay_a)
    (remove_location base_med_bay_b)
    (remove_location base_motor_pool)
    (remove_location base_ops_center)
    (remove_location terminals)
    (remove_location forerunner_secret)
    (remove_location fob_bravo)
    (remove_location fob_alpha)
    (remove_location supply_pad_bravo)
    (remove_location supply_pad_alpha)
)


(script static void turn_off_mission_switches
    (print "turning off mission switches")
    (cleanup_mission_control pylon_a_control_base pylon_a_flag)
    (cleanup_mission_control pylon_b_control_base pylon_b_flag)
    (cleanup_mission_control unlock_ft_mountain_control unlock_ft_village_flag)
    (cleanup_mission_control unlock_ft_village_control unlock_ft_mountain_flag)
    (remove_location base_ops_center_entrance)
)

(script static boolean (is_player_in_area (trigger_volume vol))
    (volume_test_objects vol (players))
)

(script static void (wait_for_players_to_enter_area (trigger_volume vol))
    (sleep_until (is_player_in_area vol))
)

(script static void respawn_armory
    (object_create_anew_containing "ar")
    (object_create_anew_containing "pi")
    (object_create_anew_containing "pr")
    (object_create_anew_containing "pp")
    (object_create_anew_containing "nr")
    (object_create_anew_containing "frag")
    (object_create_anew_containing "pfrag")
    (object_create_anew_containing "hp")
    (object_create_anew_containing "ammo")
    (if (= shotgun_unlocked true) (object_create_anew_containing "sg"))
    (if (= sniper_unlocked true) (object_create_anew_containing "sr"))
    (if (= rocket_launcher_unlocked true) (object_create_anew_containing "rl"))
    (if (= plasma_cannon_unlocked true) (object_create_anew_containing "pc"))
    (if (= flamethrower_unlocked true) (object_create_anew_containing "ft"))
    (if (= spistol_unlocked true) (object_create_anew_containing "sp"))
    (if (= ma5s_unlocked true) (object_create_anew_containing "sa"))
)

(script static void cleanup_patrol_vehicles
    (object_destroy_containing "patrol_gt")
    (object_destroy_containing "patrol_wh")
    (object_destroy_containing "patrol_be")
    (object_destroy_containing "patrol_cg")
)

(script static void cleanup_patrols
    (print "cleaning up patrols")
    (cleanup_patrol_vehicles)
    (ai_erase level_patrols)
    (ai_erase banshee_patrols)
    (if 
        (and 
        (= mission2_is_available true)
        (= mission2_is_unlocked false)
    )
        (begin 
            ; remove nav points
            (remove_location intel_1_flag)
            (remove_location intel_2_flag)
            (remove_location intel_3_flag)
        )
    )

)

(script static void reset_mission_lock
    ; if the player makes a discovery while waiting to make mission selection
    ; Should reset the mission lock so new discovery persists.
    (if (= active_mission_lock false)
        (begin
            (print "Player is waiting to make mission selection, but made a discovery. Resetting mission lock.")
            (set active_mission_lock true)
            (sleep 30)
            (set active_mission_lock false)
        )
    )
)

(script static void respawn_patrol_vehicles
    (object_create_anew_containing "patrol_gt")
    (object_create_anew_containing "patrol_wh")
    (object_create_anew_containing "patrol_be")
    (object_create_anew_containing "patrol_cg")
)

(script static void respawn_patrols
    (print "spawning patrols")
    (respawn_patrol_vehicles)
    (ai_place level_patrols)
    (ai_place banshee_patrols)
    (if (and 
        (= mission2_is_available true)
        (= mission2_is_unlocked false)

    )
        (begin 
            ; spawn nav points
            (if (= intel_1_discovered false) (show_objective_location intel_1_flag))
            (if (= intel_2_discovered false) (show_objective_location intel_2_flag))
            (if (= intel_3_discovered false) (show_objective_location intel_3_flag))
        )
    )

)

(script static void cleanup_mission_enc
    (ai_erase mission1a)
    (ai_erase mission1b)
    (ai_erase mountain_drop_pad)
    (ai_erase village_drop_pad)
    (object_destroy_containing "mission1a")
    (object_destroy_containing "mission1b")
    (object_destroy_containing "mountain_drop_pad_")
    (object_destroy_containing "village_dp_")
    (object_destroy_containing "mission1a_scenery_")
    (object_destroy_containing "mission1b_scenery_")
    (garbage_collect_now)
    (rasterizer_decals_flush)
)


(script static void handle_mission_enc_spawn
    (cond 
        (
            (= current_mission 2) 
            (begin
                ; place & setup ai for pylon A
                (object_create_anew mission1a_cg1)
                (object_create_anew mission1a_cg2)
                (object_create_anew_containing "mission1a_scenery")
                (ai_place mission1a)
                (ai_set_current_state mission1a/grunts sleep)
            )
        ) 
        (
            (= current_mission 3) 
            (begin
                ; place ai for pylon B
                (object_create_anew mission1b_wh1)
                (object_create_anew mission1b_gt1)
                (object_create_anew mission1b_cg1)
                (object_create_anew mission1b_cg2)
                (object_create_anew_containing "mission1b_scenery")
                (sleep 1)
                (ai_place mission1b)
            )
        ) 
        (
            (= current_mission 4) 
            (begin
                (ai_place mission2)
                (ai_erase mission2/oasis_boss)
                (return)
            )
        )
        (
            (= current_mission 5)
            (begin
                ; (ai_place level_patrols) ; Using level patrols for now, will set up own enc for mission 3 later.
                (ai_erase level_patrols/ridge_1)
                (ai_erase level_patrols/ridge_2)
                (ai_erase level_patrols/ridge_stealth)
                (return)
            )
        )
        (
            (= current_mission -2)
            (begin
                (ai_place mountain_drop_pad)
                (sleep 1)
                (object_create_anew_containing "mountain_drop_pad_")
            )
        )
        (
            (= current_mission -3)
            (begin
                (ai_place village_drop_pad)
                (sleep 1)
                (object_create_anew_containing "village_dp_")
            )
        ) 
    )
)

(script static void toggle_music_lock
    (set music_track_lock false)
    (sleep 60)
    (set music_track_lock true)
)


(script static boolean is_intro
    (= current_mission 0)
)

(script static boolean is_tutorial
    (= current_mission 1)
)

(script static boolean is_mission_active
    (= active_mission_lock true)
)

(script static boolean (mission_ai_eliminated (ai enc) )
    (and
        (= is_player_deployed true)
        (= is_player_in_base false)
        (<= (ai_living_count enc) 2)
    )
)

(script static boolean mission_is_currently_active
    (= active_mission_lock true)
)

(script static boolean (grab_mission_lock (short m_idx))
    (if (= active_mission_lock true) (_false))
    (set active_mission_lock true)
    (set current_mission m_idx)
    (turn_off_mission_switches)
    (_true)
)

(script static void release_mission_lock
    (set active_mission_lock false)
    (set current_mission -1)
    (toggle_music_lock)
)

(script static boolean rpg_started 
    ; Once the intro & tutorial are completed, the "real" RPG begins.
    (not (or (is_intro) (is_tutorial)))
)

(script dormant handle_mission2_locked_dialog
    (update_objective mission2_locked_objective)
    (print_objective mission2_dialog_locked_1)
    (print_objective mission2_dialog_locked_2)
    (print_objective mission2_dialog_locked_3)
)

(script static void bootstrap_new_missions
    (if ;bootstrap mission 2
        (and
            (= mission1a_is_completed true)
            (= mission1b_is_completed true)
            (= mission2_is_available false)
        )
        (begin
            (print "bootstrapping mission 2")
            (set mission2_is_available true)
            (if (= mission2_is_unlocked false)
                (begin
                    (wake handle_mission2_locked_dialog)
                )
            )
        )
    )
    (if ;bootstrap mission 3
        (and
            (= mission2_is_completed true)
            (= mission3_is_available false)
        )
        (begin
            (print "bootstrapping mission 3")
            (set mission3_is_available true)
        )
    )
    (if ; bootstrap ending mission
        (and
            (= mission3_is_completed true)
            (= ending_mission_is_available false)
        )
        (begin
            (print "bootstrapping ending mission")
            (set ending_mission_is_available true)
        )
    )
)


(script static void setup_available_missions
    (if (= active_mission_lock false)
        (begin
            (bootstrap_new_missions)
            (if (mission_is_ready mission1a_is_available mission1a_is_completed) (setup_mission_control pylon_a_control_base pylon_a_flag))
            (if (mission_is_ready mission1b_is_available mission1b_is_completed) (setup_mission_control pylon_b_control_base pylon_b_flag))
            (if (= mountain_dp_unlocked false) (setup_mission_control unlock_ft_mountain_control unlock_ft_mountain_flag))
            (if (= village_dp_unlocked false) (setup_mission_control unlock_ft_village_control unlock_ft_village_flag))
            (if (mission_is_ready mission2_is_available mission2_is_completed mission2_is_unlocked ) (show_base_location base_ops_center_entrance))
            (if (mission_is_ready mission3_is_available mission3_is_completed) (show_base_location base_ops_center_entrance))
            (if (mission_is_ready ending_mission_is_available ending_mission_is_completed) (kill_thread (get_executing_running_thread)))
        )
    )
)

(script static void spawn_world_scenery
    ; Not sure what ls is short for, but it is currently tied to the dish and two pelicans with the weapon side missions...
    (object_create_anew_containing "ls_")
)

(script static void delete_world_scenery
    (object_destroy_containing "ls_")
)

; As soon as the player sets foot in pelican
(script static void exit_base_pelican_hover
    (print "player is exiting base via pelican")
    (turn_off_mission_switches)
)

; Transitioning from hover animation inside hole to flying to drop
(script static void exit_base_pelican_transition
    (ai_erase base_humans)
    ; Destroy all base objects when exiting to improve performance
    (object_destroy_containing "base_")
    (sleep 1)
    ; rec is short for recovery. In case the player loses their vehicle in combat, they can find a recovery vehicle to use.
    (object_create_anew_containing "rec_")
    (spawn_world_scenery)
    (set player_can_be_naughty false)
    (set is_player_in_base false)
    (toggle_music_lock)
)

; Player is deployed
(script static void exit_base_pelican_deployed
    (respawn_patrols)
    (handle_mission_enc_spawn)
    (game_save_wrapper)
    (set is_player_deployed true)
)

(script static void exit_base_foot
    (print "player is exiting base on foot")
    (turn_off_mission_switches)
    ; (set music_track_lock false)
    (ai_erase base_humans)
    ; Destroy all base objects when exiting to improve performance
    (object_destroy_containing "base_")
    (object_destroy pn1)
    (sleep 1)
    ; rec is short for recovery. In case the player loses their vehicle in combat, they can find a recovery vehicle to use.
    (object_create_anew_containing "rec_")
    (spawn_world_scenery)
    (respawn_patrols)
    (handle_mission_enc_spawn)
    (sleep 1)
    ; (<void> volume_teleport_players_not_inside <trigger_volume> <cutscene_flag>)
    ; TODO: Will need to handle teleporting player logic if 1 player exits base
    (set player_can_be_naughty false)
    (set is_player_in_base false)
    (set is_player_deployed true)
    (game_save_wrapper)
    (toggle_music_lock)
)

(script static void enter_base_without_music_toggle
    (print "player is entering base")
    (set music_track_lock false)
    (cleanup_patrols)
    (cleanup_mission_enc)
    (delete_world_scenery)
    (object_destroy_containing "rec_")
    (sleep 1)
    (object_create_anew_containing "base_")
    (respawn_armory)
    ; TODO: Will need to handle teleporting player logic if 1 player enters base
    ; (<void> volume_teleport_players_not_inside <trigger_volume> <cutscene_flag>)
    (ai_place base_humans)
    (set player_can_be_naughty true)
    (set is_player_in_base true)
    (set is_player_deployed false)
    (game_save_wrapper)
    (setup_available_missions)
    (pelican_reset)
)

(script static void enter_base_ending
    (print "entering base on last mission")
    (set music_track_lock false)
    (cleanup_patrols)
    (cleanup_mission_enc)
    (object_create_anew_containing "base_")
    (respawn_armory)
    (game_save_wrapper)
    (wake ending_mission)
)


(script static void enter_base
    (enter_base_without_music_toggle)
    (toggle_music_lock)
)

(global boolean is_ending_sequence false)
(script continuous handle_player_loc_change
    ; don't check for player loc change until intro & tutorial is completed.
    (sleep_until (rpg_started))
    (cond
        (
            (and
                (is_player_in_area enter_base_volume)
                (= is_player_in_base false)
            )
            (begin
                (if (= is_ending_sequence false)
                    (enter_base)                    
                    (begin (enter_base_ending) (kill_thread (get_executing_running_thread)))
                )

            )
        )
        (
            (and 
                (is_player_in_area exit_base_volume) 
                (= is_player_in_base true)
            )
            (exit_base_foot)
        )
    )
)

(global short checkpoint_duration_in_minutes 2)

(script continuous checkpoint_manager
    (sleep_until (and (rpg_started) (= is_player_in_base false)))
    (game_save_wrapper)
    (sleep (in_minutes checkpoint_duration_in_minutes))
)

(script static void pelican_hover
    (vehicle_hover pn1 0)
    (recording_play_and_hover pn1 hover_2)
)

(script static void pelican_cleanup_vehicles
    (object_destroy pelican_hog)
    (object_destroy pelican_rhog)
    (object_destroy pelican_tank)
)

(script static void pelican_load_marines
    (ai_erase marines_pelican)
    (sleep 1)
    (ai_place marines_pelican)
    (unit_enter_vehicle (unit (list_get (ai_actors marines_pelican/marines) 0)) pn1 "P-riderLM")
    (unit_enter_vehicle (unit (list_get (ai_actors marines_pelican/marines) 1)) pn1 "P-riderRM")
)

(script static void pelican_reset
    (object_create_anew pn1)
    (object_teleport pn1 pelican_idle_hangar)
    (vehicle_hover pn1 1)
    (unit_set_enterable_by_player pn1 1)
)

(script static void (pelican_launch (cutscene_recording dropoff)(cutscene_flag starting_location) )
    (object_teleport pn1 starting_location)
    (recording_play_and_delete pn1 dropoff)
)
