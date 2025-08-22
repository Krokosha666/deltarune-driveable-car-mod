chunk_size = 128;
chunk_scale = 2;
darkworldscale = 1;
real_chunk_size = chunk_size * chunk_scale;
active_chunks = ds_map_create();
skid_points = [];

if (!variable_global_exists("krokosha_car_mod_all_cars_tracker_array"))
    global.krokosha_car_mod_all_cars_tracker_array = [];

if (!variable_global_exists("krokosha_car_partymember_comments"))
    global.krokosha_car_partymember_comments = true;

car_ignore_interact_in_rooms = [];

function add_ignore_interact_room(arg0)
{
    array_push(car_ignore_interact_in_rooms, arg0);
}

vehicular_manslaughter_objects_list = [];

function lambda_vehicular_manslaughter_default_explode(arg0, arg1)
{
    audio_play_sound(snd_rudebuster_hit, 1, false);
    krokosha_create_explosion(lerp(arg0.bbox_left, arg0.bbox_right, 0.5), lerp(arg0.bbox_top, arg0.bbox_bottom, 0.5), false);
    
    try
    {
        if (variable_instance_exists(arg0.id, "bullet"))
        {
            if (instance_exists(arg0.bullet))
            {
                if (arg0.bullet.object_index == obj_overworldbulletparent.object_index)
                    instance_destroy(arg0.bullet);
            }
        }
    }
    catch (_)
    {
    }
    
    instance_destroy(arg0);
}

function lambda_vehicular_manslaughter_true()
{
    return true;
}

function add_vehicular_manslaughter_target(arg0, arg1 = lambda_vehicular_manslaughter_true, arg2 = lambda_vehicular_manslaughter_default_explode)
{
    array_push(vehicular_manslaughter_objects_list, [arg0, arg1, arg2]);
}

function lambda_check1_vehicular_manslaughter_darkworld_enemies(arg0)
{
    return variable_global_exists("darkzone") && global.darkzone;
}

add_vehicular_manslaughter_target("obj_chaseenemy", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_scissordancer", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_ponman_appear", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_traffic_car", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_mazecheese", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_ow_pathingenemy", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_dw_bluebook_straight", lambda_check1_vehicular_manslaughter_darkworld_enemies);
add_vehicular_manslaughter_target("obj_dw_church_organikchaser", lambda_check1_vehicular_manslaughter_darkworld_enemies);

function lambda_check1_vehicular_manslaughter_first_check_sans_ch4(arg0)
{
    return global.chapter == 4 && global.plot >= 300;
}

function lambda_onhit_vehicular_manslaughter_kill_sans(arg0, arg1)
{
    if ((arg0.sprite_index == spr_sans_dance_loop || arg0.sprite_index == spr_toriel_sans_dance_loop || arg0.sprite_index == spr_sans_dance_loop_back) && arg0.visible)
    {
        audio_play_sound(snd_rudebuster_hit, 1, false);
        krokosha_create_explosion(lerp(arg0.bbox_left, arg0.bbox_right, 0.5), lerp(arg0.bbox_top, arg0.bbox_bottom, 0.5), false);
        arg0.visible = false;
    }
}

add_vehicular_manslaughter_target("obj_marker", lambda_check1_vehicular_manslaughter_first_check_sans_ch4, lambda_onhit_vehicular_manslaughter_kill_sans);

function lambda_check1_vehicular_manslaughter_first_check_berdly_ch2(arg0)
{
    return global.chapter == 2;
}

function lambda_onhit_vehicular_manslaughter_kill_berdly(arg0, arg1)
{
    if (arg0.sprite_index == spr_berdly_hurt_kneel_burnt || arg0.sprite_index == spr_berdly_hurt_kneel)
        krokosha_car_manager.lambda_vehicular_manslaughter_default_explode(arg0, arg1);
}

add_vehicular_manslaughter_target("obj_npc_sign", lambda_check1_vehicular_manslaughter_first_check_berdly_ch2, lambda_onhit_vehicular_manslaughter_kill_berdly);
krokosha_car_resistution = 0.8;

function krokosha_find_first_collision_point(arg0, arg1, arg2)
{
    var corners1 = arg0.krokosha_get_corners();
    var dist = -99999999;
    var p = [0, 0];
    
    for (var i = 0; i < 8; i += 2)
    {
        var corner = [corners1[i], corners1[i + 1]];
        var distance = dot_product(corner[0] - arg1.x, corner[1] - arg1.y, arg2[0], arg2[1]);
        
        if (distance > dist)
        {
            dist = distance;
            p = corner;
        }
    }
    
    return p;
}

function krokosha_resolve_car_collision(arg0, arg1, arg2, arg3)
{
    var colpoint = krokosha_find_first_collision_point(arg0, arg1, arg2);
    var r1 = [colpoint[0] - arg0.x, colpoint[1] - arg0.y];
    var r2 = [colpoint[0] - arg1.x, colpoint[1] - arg1.y];
    var v1 = arg0.krokosha_get_velocity_at_local_point(r1[0], r1[1]);
    var v2 = arg1.krokosha_get_velocity_at_local_point(r2[0], r2[1]);
    var rv = [v2[0] - v1[0], v2[1] - v1[1]];
    var dot = dot_product(rv[0], rv[1], arg2[0], arg2[1]);
    
    if (dot > 0)
        exit;
    
    var r1dot = dot_product(-r1[1], r1[0], arg2[0], arg2[1]);
    var r2dot = dot_product(-r2[1], r2[0], arg2[0], arg2[1]);
    var j = (-(1 + krokosha_car_resistution) * dot) / ((1 / arg0.vehicle_mass) + (1 / arg1.vehicle_mass) + ((r1dot * r1dot) / arg0.rotation_inertia) + ((r2dot * r2dot) / arg1.rotation_inertia));
    var impulsex = j * arg2[0];
    var impulsey = j * arg2[1];
    arg0.velocity_x -= impulsex / arg0.vehicle_mass;
    arg0.velocity_y -= impulsey / arg0.vehicle_mass;
    arg1.velocity_x += impulsex / arg1.vehicle_mass;
    arg1.velocity_y += impulsey / arg1.vehicle_mass;
    arg0.angular_velocity -= ((r1[0] * impulsey) - (r1[1] * impulsex)) / arg0.rotation_inertia;
    arg1.angular_velocity += ((r2[0] * impulsey) - (r2[1] * impulsex)) / arg1.rotation_inertia;
    var totalmass = arg0.vehicle_mass + arg1.vehicle_mass;
    var corcarion = 0.8 * arg3;
    
    if (!arg0.car_impact_touching_wallrn)
    {
        arg0.x -= arg2[0] * corcarion * (arg1.vehicle_mass / totalmass);
        arg0.y -= arg2[1] * corcarion * (arg1.vehicle_mass / totalmass);
    }
    
    if (!arg1.car_impact_touching_wallrn)
    {
        arg1.x += arg2[0] * corcarion * (arg0.vehicle_mass / totalmass);
        arg1.y += arg2[1] * corcarion * (arg0.vehicle_mass / totalmass);
    }
}

function krokosha_project_shape(arg0, arg1)
{
    var _min = 9999999999999999;
    var _max = -9999999999999999;
    
    for (var i = 0; i < 8; i += 2)
    {
        var dot = dot_product(arg0[i + 0], arg0[i + 1], arg1[0], arg1[1]);
        _min = min(_min, dot);
        _max = max(_max, dot);
    }
    
    return [_min, _max];
}

function krokosha_check_car_collision(arg0, arg1)
{
    var corners1 = arg0.krokosha_get_corners();
    var corners2 = arg1.krokosha_get_corners();
    var axes = [];
    
    for (var i = 0; i < 8; i += 2)
    {
        var nextcorner = (i + 2) % 8;
        var edge = [corners1[nextcorner + 0] - corners1[i + 0], corners1[nextcorner + 1] - corners1[i + 1]];
        var normal = [-edge[1], edge[0]];
        array_push(axes, normal);
    }
    
    for (var i = 0; i < 8; i += 2)
    {
        var nextcorner = (i + 2) % 8;
        var edge = [corners2[nextcorner + 0] - corners2[i + 0], corners2[nextcorner + 1] - corners2[i + 1]];
        var normal = [-edge[1], edge[0]];
        array_push(axes, normal);
    }
    
    var minoverlap = 9999999999;
    var smallestAxis = [0, 0];
    
    for (var i = 0; i < array_length(axes); i++)
    {
        var axis = axes[i];
        var length = sqrt((axis[0] * axis[0]) + (axis[1] * axis[1]));
        
        if (length == 0)
            continue;
        
        axis[0] /= length;
        axis[1] /= length;
        var proj1 = krokosha_project_shape(corners1, axis);
        var proj2 = krokosha_project_shape(corners2, axis);
        
        if (proj1[1] < proj2[0] || proj2[1] < proj1[0])
            return false;
        
        var overlap = min(proj1[1], proj2[1]) - max(proj1[0], proj2[0]);
        
        if (overlap < minoverlap)
        {
            minoverlap = overlap;
            smallestAxis = [axis[0], axis[1]];
        }
    }
    
    return [true, smallestAxis, minoverlap];
}

function angle_to_dir(arg0)
{
    return [sin(arg0), -cos(arg0)];
}

function vec2_length(arg0, arg1)
{
    return sqrt((arg0 * arg0) + (arg1 * arg1));
}

function vec2_normalize(arg0, arg1)
{
    var len = vec2_length(arg0, arg1);
    
    if (len == 0)
        return [0, 0];
    
    return [arg0 / len, arg1 / len];
}

function get_chunk_coords(arg0, arg1)
{
    return [floor(arg0 / real_chunk_size), floor(arg1 / real_chunk_size)];
}

function krokosha_car_mgr_cleanup_all_surface()
{
    var keys = ds_map_keys_to_array(active_chunks);
    
    for (var i = 0; i < array_length(keys); i++)
    {
        var chunk = ds_map_find_value(active_chunks, keys[i]);
        surface_free(chunk.surface);
    }
    
    ds_map_destroy(active_chunks);
}

function krokosha_car_mgr_reset_skidmark_surfaces()
{
    krokosha_car_mgr_cleanup_all_surface();
    active_chunks = ds_map_create();
}

function get_chunk(arg0, arg1)
{
    var key = string(arg0) + "," + string(arg1);
    
    if (!ds_map_exists(active_chunks, key))
    {
        var new_chunk = 
        {
            surface: surface_create(chunk_size, chunk_size, 12),
            x: arg0 * real_chunk_size,
            y: arg1 * real_chunk_size,
            last_used: current_time
        };
        surface_set_target(new_chunk.surface);
        draw_clear_alpha(c_black, 0);
        surface_reset_target();
        ds_map_add(active_chunks, key, new_chunk);
        return new_chunk;
    }
    else
    {
        var chunk = ds_map_find_value(active_chunks, key);
        chunk.last_used = current_time;
        return chunk;
    }
}

function clean_chunks(arg0 = 30000)
{
    var keys = ds_map_keys_to_array(active_chunks);
    
    for (var i = 0; i < array_length(keys); i++)
    {
        var chunk = ds_map_find_value(active_chunks, keys[i]);
        
        if ((current_time - chunk.last_used) > arg0)
        {
            surface_free(chunk.surface);
            ds_map_delete(active_chunks, keys[i]);
        }
    }
}

function add_skid_line(arg0, arg1, arg2, arg3)
{
    var chunk2 = get_chunk_coords(arg2, arg3);
    get_chunk(chunk2[0], chunk2[1]);
    array_push(skid_points, 
    {
        x1: arg0,
        y1: arg1,
        x2: arg2,
        y2: arg3
    });
}

function check_if_car_with_spawn_id_doesnt_already_exist(arg0)
{
    for (var i = 0; i < array_length(global.krokosha_car_mod_all_cars_tracker_array); i++)
    {
        var carinfo = global.krokosha_car_mod_all_cars_tracker_array[i];
        
        if (carinfo[5] == arg0)
            return false;
    }
    
    return true;
}

function spawn_this_car_if_it_doesnt_exist(arg0, arg1, arg2, arg3, arg4)
{
    if (!instance_exists(obj_mainchara))
        return -1;
    
    if (arg4 != 0)
    {
        if (!check_if_car_with_spawn_id_doesnt_already_exist(arg4))
            return -1;
    }
    
    return instance_create_depth(arg0, arg1, obj_mainchara.depth, krokosha_car_driveable, 
    {
        car_name: arg3,
        carangle: arg2,
        car_spawnreason: arg4
    });
}

function krokosha_get_closest_car()
{
    var closest_car_dist = 1000000000000000;
    var closest_car = -1;
    
    if (instance_exists(obj_mainchara))
    {
        for (var i = 0; i < instance_number(krokosha_car_driveable); i++)
        {
            var car = instance_find(krokosha_car_driveable, i);
            
            if (!car.doors_locked)
            {
                var cardist = vec2_length(car.x - obj_mainchara.x, car.y - obj_mainchara.y);
                var mindist = (vec2_length(car.wheelbase_x, car.wheelbase_y) + 16) * darkworldscale;
                
                if (cardist < mindist && cardist < closest_car_dist)
                {
                    closest_car_dist = cardist;
                    closest_car = car;
                }
            }
        }
    }
    
    return closest_car;
}

if (!variable_global_exists("krokosha_exit_positions_of_car_idk_bruh"))
    global.krokosha_exit_positions_of_car_idk_bruh = [];

persistent = true;
krokosha_collision_interaction_overrides_checked = false;

function krokosha_collision_interaction_overrides_check_now()
{
    if (!krokosha_collision_interaction_overrides_checked)
    {
        if (asset_get_index("obj_traffic_car"))
        {
            if (krokosha_player_is_in_car)
            {
                with (obj_caterpillarchara)
                    visible = false;
                
                for (var i = 0; i < instance_number(obj_traffic_car); i++)
                {
                    var tr_car = instance_find(obj_traffic_car, i);
                    
                    if (tr_car.touchcon != 0)
                    {
                        global.interact = 0;
                        tr_car.touchtimer = 30;
                        tr_car.touchcon = 0;
                        
                        with (obj_mainchara)
                        {
                            image_alpha = 1;
                            visible = false;
                        }
                        
                        with (obj_caterpillarchara)
                        {
                            if (image_alpha == 0.5)
                            {
                                image_alpha = 1;
                                visible = false;
                            }
                        }
                        
                        krokosha_create_explosion(lerp(tr_car.bbox_left, tr_car.bbox_right, 0.5), lerp(tr_car.bbox_top, tr_car.bbox_bottom, 0.5), true);
                        instance_destroy(tr_car);
                        break;
                    }
                }
            }
        }
        
        if (asset_get_index("obj_darkslide"))
        {
            if (krokosha_player_is_in_car)
            {
                for (var i = 0; i < instance_number(obj_darkslide); i++)
                {
                    var slide = instance_find(obj_darkslide, i);
                    
                    if (slide.collide == 1)
                    {
                        global.interact = 0;
                        
                        with (obj_mainchara)
                            sliding = 0;
                        
                        if (instance_exists(krokosha_player_current_car))
                        {
                            krokosha_player_current_car.skidding = lerp(krokosha_player_current_car.skidding, 1, 0.1);
                            
                            if (krokosha_player_current_car.velocity_y < 60)
                                krokosha_player_current_car.velocity_y += 6;
                            
                            krokosha_player_current_car.y += 2;
                        }
                    }
                    
                    slide.collide = 0;
                    slide.collidetimer = -1;
                    slide.cancollide = 0;
                    slide.collider = 0;
                    slide.slidetimer = 0;
                    slide.abovey = 1;
                    
                    if (variable_instance_exists(slide.id, "slide_noise"))
                    {
                        if (audio_exists(slide.slide_noise))
                            snd_stop(slide.slide_noise);
                    }
                    else
                    {
                        slide.slide_noise = -1;
                    }
                }
            }
        }
        
        if (asset_get_index("obj_darkslide_new"))
        {
            if (krokosha_player_is_in_car)
            {
                for (var i = 0; i < instance_number(obj_darkslide_new); i++)
                {
                    var slide = instance_find(obj_darkslide_new, i);
                    
                    if (slide.collide == 1)
                    {
                        global.interact = 0;
                        
                        with (obj_mainchara)
                        {
                            sliding = 0;
                            fun = 0;
                        }
                        
                        if (instance_exists(krokosha_player_current_car))
                        {
                            krokosha_player_current_car.skidding = lerp(krokosha_player_current_car.skidding, 1, 0.1);
                            
                            if (krokosha_player_current_car.velocity_y < 60)
                                krokosha_player_current_car.velocity_y += 6;
                            
                            krokosha_player_current_car.y += 2;
                        }
                    }
                    
                    slide.collide = 0;
                    slide.collidetimer = -1;
                    slide.cancollide = 0;
                    slide.collider = 0;
                    slide.slidetimer = -3;
                    slide.abovey = 0;
                    slide.sliding = 1;
                    slide.instant_end_sliding = 0;
                    slide.move_lr_enabled = 0;
                    
                    if (global.chapter >= 2)
                        slide.move_lr_enabled = 1;
                    
                    if (variable_instance_exists(slide.id, "slide_noise"))
                    {
                        if (audio_exists(slide.slide_noise))
                            snd_stop(slide.slide_noise);
                    }
                    else
                    {
                        slide.slide_noise = -1;
                    }
                }
            }
        }
        
        if (krokosha_player_is_in_car)
        {
            if (global.chapter == 1)
            {
                if (room == room_forest_chase1)
                {
                    if (instance_exists(obj_lancerchase2))
                    {
                        if (obj_lancerchase2.con == 5 || obj_lancerchase2.con == 6 || obj_lancerchase2.con == 7)
                        {
                            if (instance_exists(obj_dialoguer))
                                instance_destroy(obj_dialoguer);
                            
                            obj_lancerchase2.con = 7;
                        }
                    }
                }
            }
        }
        
        krokosha_collision_interaction_overrides_checked = true;
    }
}

function krokosha_despawn_all_cars()
{
    for (var i = 0; i < instance_number(krokosha_car_driveable); i++)
    {
        var car_instance = instance_find(krokosha_car_driveable, i);
        instance_destroy(car_instance);
    }
    
    if (variable_global_exists("krokosha_car_mod_all_cars_tracker_array"))
        array_delete(global.krokosha_car_mod_all_cars_tracker_array, 0, array_length(global.krokosha_car_mod_all_cars_tracker_array));
}

krokosha_DEV_susie_i_remember_your_grand_theft_auto = false;
krokosha_carcrash_dialogue_active = false;
krokosha_carcrash_dialogue_timestart = 0;
krokosha_car_crash_current_dialogue = "";
krokosha_car_crash_dialogues = [[["\\E3* Dude...^1 you said you know how to drive.../%", "krokosha_carcrash_susie_1"], ["\\E5* Stop hitting stuff!^1 It's not your car!/%", "krokosha_carcrash_susie_2"]], [["\\E0* Kris,^1 you know we could always just^1 umm...^1 walk?/%", "krokosha_carcrash_ral_1"]], [["\\E8* (I knew this was a bad idea.)/%", "krokosha_carcrash_noel_1"], ["\\E2* Kris?^1 Are you sure you need a car here?/%", "krokosha_carcrash_noel_2"]], [["\\EB* Kris, you simpleton you can't even drive!/%", "krokosha_carcrash_berdly_1"]], [["* You are the original              ryan gosling/%", "krokosha_carcrash_starwalker_1"], ["* This \\cYcar\\cW is \\cYPissing\\cW me off./%", "krokosha_carcrash_starwalker_2"], ["* I'm the original   \\cYStarwalker\\cW /%", "krokosha_carcrash_starwalker_3"]]];

function krokosha_check_if_character_actually_exists(arg0)
{
    for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
    {
        var partymember = instance_find(obj_caterpillarchara, i);
        
        if (variable_instance_exists(partymember.id, "name"))
        {
            if (partymember.name == arg0)
                return true;
        }
        else
        {
            if (partymember.usprite == spr_ralseiu && arg0 == "ralsei")
                return true;
            
            if (arg0 == "susie")
            {
                if (partymember.usprite == spr_susieu_dark)
                    return true;
            }
        }
    }
    
    return false;
}

function krokosha_current_room_matches(arg0, arg1 = [])
{
    if (array_length(arg0) > global.chapter)
    {
        var rooms_to_check = [];
        var charr = arg0[global.chapter - 1];
        
        for (var i = 0; i < array_length(charr); i++)
            array_push(rooms_to_check, charr[i]);
        
        for (var i = 0; i < array_length(rooms_to_check); i++)
        {
            if (room == asset_get_index(rooms_to_check[i]))
                return true;
        }
    }
    
    return false;
}

function krokosha_create_explosion(arg0, arg1, arg2 = true)
{
    var explosion = instance_create(arg0, arg1, obj_animation);
    
    if (arg2)
        snd_play(snd_badexplosion);
    
    explosion.sprite_index = spr_realisticexplosion;
}

function scr_speaker_patch_for_ch1(arg0)
{
    if (global.chapter != 1)
        return scr_speaker(arg0);
    
    _speaker = arg0;
    global.typer = 5;
    
    if (global.darkzone == 1)
        global.typer = 6;
    
    if (global.fighting == 1)
        global.typer = 4;
    
    global.fc = 0;
    global.fe = 0;
    
    if (_speaker == "silent" && global.darkzone == 0)
        global.typer = 2;
    
    if (_speaker == "silent" && global.darkzone == 1)
        global.typer = 36;
    
    if (_speaker == "balloon" || _speaker == "enemy")
        global.typer = 50;
    
    if (_speaker == "sans")
    {
        global.typer = 14;
        global.fc = 6;
    }
    
    if (_speaker == "undyne" || _speaker == "und")
    {
        global.typer = 17;
        global.fc = 9;
    }
    
    if (_speaker == "temmie" || _speaker == "tem")
        global.typer = 21;
    
    if (_speaker == "jevil")
        global.typer = 35;
    
    if (_speaker == "catti")
        global.fc = 13;
    
    if (_speaker == "jockington" || _speaker == "joc")
        global.fc = 14;
    
    if (_speaker == "catty" || _speaker == "caddy")
        global.fc = 16;
    
    if (_speaker == "bratty" || _speaker == "bra")
        global.fc = 17;
    
    if (_speaker == "rouxls" || _speaker == "rou")
        global.fc = 18;
    
    if (_speaker == "burgerpants" || _speaker == "bur")
        global.fc = 19;
    
    if (_speaker == "spamton")
    {
        if (global.fighting == 0)
            global.typer = 66;
        else
            global.typer = 68;
    }
    
    if (_speaker == "sneo")
        global.typer = 67;
    
    if (_speaker == "susie" || _speaker == "sus")
    {
        global.fc = 1;
        global.typer = 10;
        
        if (global.darkzone == 1)
        {
            global.typer = 30;
            
            if (global.fighting == 1)
                global.typer = 47;
        }
    }
    
    if (_speaker == "ralsei" || _speaker == "ral")
    {
        global.fc = 2;
        global.typer = 31;
        
        if (global.fighting == 1)
            global.typer = 45;
        
        if (global.flag[30] == 1)
            global.typer = 6;
    }
    
    if (_speaker == "noelle" || _speaker == "noe")
    {
        global.fc = 3;
        
        if (global.darkzone == 0)
            global.typer = 12;
        else
            global.typer = 56;
        
        if (global.fighting == 1)
            global.typer = 59;
    }
    
    if (_speaker == "toriel" || _speaker == "tor")
    {
        global.fc = 4;
        global.typer = 7;
    }
    
    if (_speaker == "asgore" || _speaker == "asg")
    {
        global.fc = 10;
        global.typer = 18;
    }
    
    if (_speaker == "king" || _speaker == "kin")
    {
        global.fc = 20;
        global.typer = 33;
        
        if (global.chapter == 1)
        {
            if (global.plot < 235)
                global.typer = 36;
        }
        
        if (global.fighting == 1)
            global.typer = 48;
    }
    
    if (_speaker == "rudy" || _speaker == "rud")
    {
        global.fc = 15;
        global.typer = 55;
    }
    
    if (_speaker == "lancer" || _speaker == "lan")
    {
        global.fc = 5;
        global.typer = 32;
        
        if (global.fighting == 1)
            global.typer = 46;
    }
    
    if (_speaker == "berdly" || _speaker == "ber")
    {
        global.fc = 12;
        
        if (global.darkzone == 0)
            global.typer = 13;
        else
            global.typer = 57;
        
        if (global.fighting == 1)
            global.typer = 77;
    }
    
    if (_speaker == "alphys" || _speaker == "alp")
    {
        global.fc = 11;
        global.typer = 20;
    }
    
    if (_speaker == "queen" || _speaker == "que")
    {
        global.fc = 21;
        global.typer = 58;
    }
    
    if (_speaker == "queen_2" || _speaker == "que_2")
    {
        global.fc = 21;
        global.typer = 62;
    }
}

function msgsetloc_patch_for_ch1(arg0, arg1, arg2)
{
    if (global.chapter != 1)
        return msgsetloc(arg0, arg1, arg2);
    
    var str = arg1;
    
    if (!(!variable_global_exists("lang") || global.lang == "en"))
        str = scr_84_get_lang_string(arg2);
    
    global.msg[arg0] = str;
}

function krokosha_do_carcrash_dialogue()
{
    var crashcomment_cooldown = 15000;
    var crashcomment_chance = 0.5;
    
    if (global.darkzone)
    {
        crashcomment_cooldown = 35000;
        crashcomment_chance = 0.9;
    }
    
    if (global.krokosha_car_partymember_comments && !instance_exists(obj_writer) && !krokosha_carcrash_dialogue_active && (current_time - krokosha_carcrash_dialogue_timestart) > crashcomment_cooldown && random(1) > crashcomment_chance)
    {
        krokosha_carcrash_dialogue_timestart = current_time;
        var chars_to_try = ["susie", "ralsei", "noelle", "berdly", "starwalker"];
        var my_char_count = 0;
        
        for (var i = 0; i < array_length(chars_to_try); i++)
        {
            if (krokosha_check_if_character_actually_exists(chars_to_try[i]))
                my_char_count += 1;
        }
        
        if (my_char_count > 0)
        {
            var charselectcounter = median(irandom(my_char_count) + 1, 1, my_char_count);
            
            for (var i = 0; i < array_length(chars_to_try); i++)
            {
                var cur_char_name = chars_to_try[i];
                
                if (krokosha_check_if_character_actually_exists(cur_char_name))
                {
                    if (charselectcounter == 1)
                    {
                        if (cur_char_name == "starwalker")
                            scr_speaker_patch_for_ch1("no_name");
                        else
                            scr_speaker_patch_for_ch1(cur_char_name);
                        
                        var randindex = irandom(array_length(krokosha_car_crash_dialogues[i]) - 1);
                        var got_the_msg = krokosha_car_crash_dialogues[i][randindex][0];
                        
                        if (global.chapter == 1 && cur_char_name == "susie" && global.flag[29] == 0)
                            got_the_msg = string_concat("\\E0", string_copy(got_the_msg, 4, string_length(got_the_msg) - 3));
                        
                        msgsetloc_patch_for_ch1(0, got_the_msg, krokosha_car_crash_dialogues[i][randindex][1]);
                        krokosha_car_crash_current_dialogue = global.msg[0];
                        break;
                    }
                    else
                    {
                        charselectcounter -= 1;
                    }
                }
            }
            
            krokosha_carcrash_dialogue_active = true;
            var d = d_make();
            d.side = 1;
            d.zurasu = 1;
        }
    }
}

krokosha_car_mgr_last_room = room;
krokosha_player_exiting_starttime = current_time;
krokosha_player_is_exiting = false;
krokosha_player_is_exiting_tumbling = false;
krokosha_player_is_enteringorleaving_car_timer = current_time;
krokosha_player_is_in_car = false;
krokosha_player_current_car = undefined;
krokosha_enter_button_pressed_need_to_check = false;
krokosha_dev_test_no_interact = true;

function check_player_car_enter_button_press()
{
    if (krokosha_enter_button_pressed_need_to_check)
    {
        krokosha_enter_button_pressed_need_to_check = false;
        
        if ((current_time - krokosha_player_is_enteringorleaving_car_timer) < 500)
            exit;
        
        if (!instance_exists(obj_mainchara))
            exit;
        
        if (obj_mainchara.cutscene)
            exit;
        
        if (global.interact == 5)
            exit;
        
        if (krokosha_player_is_in_car)
        {
            if (!instance_exists(obj_dialoguer) && (!instance_exists(obj_writer) || (instance_exists(obj_writer) && !obj_writer.skippable)))
            {
                krokosha_player_is_enteringorleaving_car_timer = current_time;
                krokosha_player_current_car.car_player_dismount_smooth();
            }
        }
        else if (!global.interact)
        {
            krokosha_player_is_enteringorleaving_car_timer = current_time;
            var found_car = krokosha_get_closest_car();
            
            if (found_car != -1)
                found_car.car_player_enter_smooth();
        }
    }
    
    if (button1_p())
    {
        if (!instance_exists(obj_dialoguer) && (!instance_exists(obj_writer) || (instance_exists(obj_writer) && !obj_writer.skippable)))
            krokosha_enter_button_pressed_need_to_check = true;
    }
    else
    {
        krokosha_enter_button_pressed_need_to_check = false;
    }
}

function krokosha_remove_car_from_global_tracker(arg0)
{
    if (!variable_global_exists("krokosha_car_mod_all_cars_tracker_array"))
    {
        global.krokosha_car_mod_all_cars_tracker_array = [];
        exit;
    }
    
    var index_of_interest = arg0.car_globalreferenceindex;
    var existingcars = [];
    var existingcars_indexes = [];
    
    for (var i = 0; i < instance_number(krokosha_car_driveable); i++)
    {
        var car = instance_find(krokosha_car_driveable, i);
        array_push(existingcars, car);
        array_push(existingcars_indexes, car.car_globalreferenceindex);
    }
    
    if (array_length(global.krokosha_car_mod_all_cars_tracker_array) > index_of_interest && global.krokosha_car_mod_all_cars_tracker_array[index_of_interest][0] == index_of_interest)
    {
        array_delete(global.krokosha_car_mod_all_cars_tracker_array, index_of_interest, 1);
        
        for (var i = 0; i < array_length(global.krokosha_car_mod_all_cars_tracker_array); i++)
        {
            var carinfo = global.krokosha_car_mod_all_cars_tracker_array[i];
            
            for (var e = 0; e < array_length(existingcars); e++)
            {
                var car = existingcars[e];
                var oldindex = existingcars_indexes[e];
                
                if (oldindex == carinfo[0])
                {
                    carinfo[0] = i;
                    car.car_globalreferenceindex = i;
                    break;
                }
            }
        }
    }
}

depth = 99000;
