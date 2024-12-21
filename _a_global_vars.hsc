; weapon side quest variables
(global object_definition shotgun_ref weapons\shotgun\shotgun)
(global boolean shotgun_unlocked false)
(global object_definition sniper_ref "weapons\sniper rifle\sniper rifle")
(global boolean sniper_unlocked false)
(global object_definition rocket_launcher_ref "weapons\rocket launcher\rocket launcher")
(global boolean rocket_launcher_unlocked false)
(global object_definition plasma_cannon_ref "weapons\plasma_cannon\_plasma_cannon")
(global boolean plasma_cannon_unlocked false)
(global object_definition flamethrower_ref weapons\flamethrower\flamethrower)
(global boolean flamethrower_unlocked false)
(global object_definition ma5s_ref weapons\ma5s\ma5s)
(global boolean ma5s_unlocked false)
(global object_definition spistol_ref cmt\weapons\human\odst_pistol\odst_pistol)
(global boolean spistol_unlocked false)

(global boolean is_player_in_base false) ; the player is either in the base or outside
(global boolean is_player_deployed false) ; player can be riding in pelican: so they are outside, but not on the ground yet.
(global boolean player_can_be_naughty false)

(global boolean player_is_naughty false)

(global boolean active_mission_lock true) ; applies for intro, tutorial, main missions & active side quests

(global short number_of_players 1) ; used to track player count for special things. Not using player_spawn_count for easier testing.

(global boolean used_village_ft false)
(global boolean used_mountain_ft false)

; >=0 are main missions
; < 0 are active side quests & exploration
(global boolean music_track_lock false) ; corresponds to current_mission
(global short current_mission 0)
; -3 - Village Drop Pad
; -2 - Mountain Drop Pad
; -1 - Explore & Patrols only
; 0 - Intro
; 1 - Tutorial
; 2 - Pylon A
; 3 - Pylon B
; 4 - Disable Planetary defenses
; 5 - Repel the invasion
; 6 - Hangar Attack & Ending


