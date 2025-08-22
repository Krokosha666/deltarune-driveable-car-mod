var dt = delta_time / 1000000;

if (variable_global_exists("darkzone"))
{
    if (global.darkzone)
    {
        chunk_scale = 4;
        darkworldscale = 2;
        real_chunk_size = chunk_size * chunk_scale;
    }
    else
    {
        chunk_scale = 2;
        darkworldscale = 1;
        real_chunk_size = chunk_size * chunk_scale;
    }
}

if (krokosha_car_mgr_last_room != room)
{
    krokosha_car_mgr_last_room = room;
    krokosha_car_mgr_reset_skidmark_surfaces();
    
    if (global.chapter == 1)
    {
        if (asset_get_index("room_forest_chase1"))
        {
            if (room == room_forest_chase1)
            {
                if (krokosha_player_is_in_car)
                {
                    if (instance_exists(obj_astream))
                        snd_free_all();
                    
                    global.currentsong[0] = snd_init("creepychase.ogg");
                    global.currentsong[1] = mus_loop(global.currentsong[0]);
                    scr_losechar();
                }
            }
        }
    }
    
    for (var i = 0; i < array_length(global.krokosha_car_mod_all_cars_tracker_array); i++)
    {
        var car = global.krokosha_car_mod_all_cars_tracker_array[i];
        
        try
        {
            if (car[7] == room)
            {
                var car_already_exists = false;
                
                for (i = 0; i < instance_number(krokosha_car_driveable); i++)
                {
                    var realcar = instance_find(krokosha_car_driveable, i);
                    
                    if (realcar.car_globalreferenceindex == car[0])
                    {
                        car_already_exists = true;
                        break;
                    }
                }
                
                if (!car_already_exists && instance_exists(obj_mainchara))
                {
                    instance_create_depth(car[2], car[3], obj_mainchara.depth, krokosha_car_driveable, 
                    {
                        car_globalreferenceindex: car[0],
                        car_name: car[1],
                        carangle: car[4],
                        car_spawnreason: car[5]
                    });
                }
            }
        }
        catch (_)
        {
        }
    }
}

if (krokosha_carcrash_dialogue_active && variable_global_exists("msg"))
{
    if ((instance_exists(obj_writer) || instance_exists(obj_dialoguer)) && global.msg[0] == krokosha_car_crash_current_dialogue)
    {
        if (global.chapter == 1 && instance_exists(obj_dialoguer) && variable_instance_exists(350, "writer") && instance_exists(obj_dialoguer.writer))
        {
            obj_dialoguer.xx = (19 * obj_dialoguer.f) + camera_get_view_x(view_get_camera(0));
            obj_dialoguer.yy = (20 * obj_dialoguer.f) + camera_get_view_y(view_get_camera(0));
            obj_dialoguer.xx = round(obj_dialoguer.xx);
            obj_dialoguer.yy = round(obj_dialoguer.yy);
            
            if (obj_dialoguer.side == 0)
            {
                obj_dialoguer.writer.x = obj_dialoguer.xx + (10 * obj_dialoguer.f);
                obj_dialoguer.writer.y = obj_dialoguer.yy + (5 * obj_dialoguer.f);
            }
            
            if (obj_dialoguer.side == 1)
            {
                obj_dialoguer.writer.x = obj_dialoguer.xx + (10 * obj_dialoguer.f);
                obj_dialoguer.writer.y = obj_dialoguer.yy + (150 * obj_dialoguer.f);
            }
            
            obj_dialoguer.writer.writingx = obj_dialoguer.writer.x;
            obj_dialoguer.writer.writingy = obj_dialoguer.writer.y;
            
            if (global.fc != 0)
            {
                obj_dialoguer.writer.writingx += 58 * obj_dialoguer.f;
                
                if (global.lang == "ja")
                    obj_dialoguer.writer.writingx -= 8;
            }
            
            if (variable_instance_exists(350, "myface") && instance_exists(obj_dialoguer.myface))
            {
                obj_dialoguer.myface.x = obj_dialoguer.writer.x + (8 * obj_dialoguer.f);
                obj_dialoguer.myface.y = obj_dialoguer.writer.y + (5 * obj_dialoguer.f);
            }
        }
        
        if ((current_time - krokosha_carcrash_dialogue_timestart) > 3000)
        {
            if (instance_exists(obj_writer))
                obj_writer.forcebutton1 = 1;
            
            if (instance_exists(obj_dialoguer))
            {
                if (instance_exists(obj_dialoguer.writer))
                    instance_destroy(obj_dialoguer.writer);
                
                instance_destroy(obj_dialoguer);
            }
            
            krokosha_carcrash_dialogue_active = false;
        }
    }
    else
    {
        krokosha_carcrash_dialogue_active = false;
    }
}

krokosha_collision_interaction_overrides_check_now();
krokosha_collision_interaction_overrides_checked = false;
krokosha_dev_test_rigdbody_collision = true;

if (!keyboard_check(ord("T")))
{
    for (var i = 0; i < instance_number(krokosha_car_driveable); i++)
    {
        var car = instance_find(krokosha_car_driveable, i);
        depth = max(depth, car.depth + 1);
        
        for (var e = 0; e < instance_number(krokosha_car_driveable); e++)
        {
            var car2 = instance_find(krokosha_car_driveable, e);
            
            if (car != car2)
            {
                if (krokosha_dev_test_rigdbody_collision)
                {
                    var result = krokosha_check_car_collision(car, car2);
                    
                    if (is_array(result) && result[0])
                    {
                        var vx = car.velocity_x - car2.velocity_x;
                        var vy = car.velocity_y - car2.velocity_y;
                        
                        if (((vx * vx) + (vy * vy)) > 40 && !car.car_impact_touching_wallrn && !car2.car_impact_touching_wallrn)
                            car.play_car_impact_sound();
                        
                        krokosha_resolve_car_collision(car, car2, result[1], result[2]);
                    }
                }
                else
                {
                    var cardist = vec2_length(car.x - car2.x, car.y - car2.y);
                    var car1look = angle_to_dir(car.carangle);
                    var car1look_x = car1look[0];
                    var car1look_y = car1look[1];
                    var car2look = angle_to_dir(car2.carangle);
                    var car2look_x = car2look[0];
                    var car2look_y = car2look[1];
                    var caraligment = dot_product(car1look_x, car1look_y, car2look_x, car2look_y);
                    var fullwb_x = car.wheelbase_x + car2.wheelbase_x;
                    var fullwb_y = car.wheelbase_y + car2.wheelbase_y;
                    var wbdiff = abs(fullwb_y - fullwb_x);
                    var mindist = fullwb_x;
                    
                    if (cardist < mindist && cardist != 0)
                    {
                        var actualforce = -dot_product(car.velocity_x, car.velocity_y, car2.velocity_x, car2.velocity_y);
                        actualforce = median(actualforce, -1000, 1000);
                        
                        if (abs(actualforce) > 48 && car.car_impact_cooldown == 0 && car2.car_impact_cooldown == 0 && !car.car_impact_touching_wallrn && !car2.car_impact_touching_wallrn)
                        {
                            car.car_impact_cooldown = 0.4;
                            car2.car_impact_cooldown = 0.4;
                            audio_play_sound(snd_impact, 1, false);
                        }
                        
                        car.car_impact_touching_wallrn = true;
                        car2.car_impact_touching_wallrn = true;
                        car.angular_velocity += caraligment * actualforce * 0.1 * dt;
                        car2.angular_velocity -= caraligment * actualforce * 0.1 * dt;
                        var carnormal = vec2_normalize(car.x - car2.x, car.y - car2.y);
                        var cemter_x = lerp(car.x, car2.x, 0.5);
                        var cemter_y = lerp(car.y, car2.y, 0.5);
                        car.x = cemter_x + (carnormal[0] * mindist * 0.5);
                        car.y = cemter_y + (carnormal[1] * mindist * 0.5);
                        car2.x = cemter_x - (carnormal[0] * mindist * 0.5);
                        car2.y = cemter_y - (carnormal[1] * mindist * 0.5);
                        car.velocity_x -= carnormal[0] * actualforce * dt;
                        car.velocity_y -= carnormal[1] * actualforce * dt;
                        car2.velocity_x += carnormal[0] * actualforce * dt;
                        car2.velocity_y += carnormal[1] * actualforce * dt;
                    }
                }
            }
        }
    }
}

if (krokosha_player_is_exiting && instance_exists(obj_mainchara))
{
    if ((current_time - krokosha_player_exiting_starttime) < 400)
    {
        var interpolation_t = (current_time - krokosha_player_exiting_starttime) / 400;
        var my_characters = [1049];
        
        for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
        {
            var partymember = instance_find(obj_caterpillarchara, i);
            array_push(my_characters, partymember);
        }
        
        for (var i = 0; i < min(array_length(global.krokosha_exit_positions_of_car_idk_bruh), array_length(my_characters)); i++)
        {
            var chara = my_characters[i];
            var goalpos = global.krokosha_exit_positions_of_car_idk_bruh[i];
            chara.x = round(lerp(krokosha_player_current_car.x, goalpos[0] - 9, interpolation_t));
            chara.y = round(lerp(krokosha_player_current_car.y, goalpos[1] - 17, interpolation_t));
            
            if (chara.object_index != obj_mainchara.object_index)
            {
                for (i = 0; i < array_length(chara.remx); i++)
                {
                    var progresstginfg = 1 - (i / array_length(chara.remx));
                    chara.remx[i] = lerp(chara.x, obj_mainchara.x, progresstginfg * 0.5);
                    chara.remy[i] = lerp(chara.y, obj_mainchara.y, progresstginfg * 0.5);
                    chara.facing[i] = global.facing;
                }
            }
            else if (krokosha_player_is_exiting_tumbling)
            {
                var looped_thing = ((current_time - krokosha_player_exiting_starttime) & 400) * 0.7;
                
                if (looped_thing > 150)
                    global.facing = 0;
                else if (looped_thing > 100)
                    global.facing = 1;
                else if (looped_thing > 50)
                    global.facing = 2;
                else
                    global.facing = 3;
            }
        }
    }
    else
    {
        global.interact = false;
        krokosha_player_is_in_car = false;
        krokosha_player_is_exiting_tumbling = false;
        krokosha_player_is_exiting = false;
    }
}

check_player_car_enter_button_press();
