(script static void cheat_skip_intro
    (object_cannot_take_damage (players))
    (object_teleport (get_player_object_from 0) base_cheat_flag)
    (sleep 90)
    (object_teleport (get_player_object_from 0) base_motor_pool)
    (ai_erase intro_base)
    (object_can_take_damage (players))
)

(script static void setup_intro_clear_sequence
    (game_save_wrapper)
    (print "player has found base")
    (remove_location base_vehicle_entrance)
    (print "waiting for player to enter base")
    (wait_for_players_to_enter_area base_motorpool_entrance_volume)
    (sound_looping_stop levels\rpg_zulu_final\music\winter_wonderland)
    (game_save_wrapper)
    (print_objective clear_base)
    (update_objective clear_base)
    (sleep 60)
    (sound_looping_start levels\rpg_zulu_final\music\intro_base "none" 1)
    (print "waiting for player to clear base of enemies")
    (sleep_until (= (ai_living_count intro_base) 0))
    (print "player has cleared base and completed intro")
    (sound_looping_stop levels\rpg_zulu_final\music\intro_base)
    (ai_erase_all)
    (object_destroy_containing "intro_")
    (game_save_wrapper)
)

(script static void setup_intro_find_base
    (game_save_wrapper)
    (sound_looping_stop levels\rpg_zulu_final\music\intro_cutscene)
    (object_create_anew_containing "intro_")
    (ai_place intro_mountains_v2)
    (ai_place intro_base)
    (ai_place intro_marines)
    (ai_place intro_cave)
    (sleep 400)
    (sound_looping_start levels\rpg_zulu_final\music\winter_wonderland "none" 1)
    (show_objective_location first_warthog)
    (print_objective find_base)
    (update_objective find_base)
    (print "waiting for player to find warthog")
    (sleep_until (is_player_in_area volume_first_warthog))
    (remove_location first_warthog)
    (show_objective_location base_vehicle_entrance)
    (print "waiting for player to enter vehicle tunnel")
    (wait_for_players_to_enter_area base_tunnel_entrance_volume)
)