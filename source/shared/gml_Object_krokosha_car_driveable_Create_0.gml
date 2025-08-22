if (!variable_global_exists("krokosha_car_mod_all_cars_tracker_array"))
    global.krokosha_car_mod_all_cars_tracker_array = [];

if (!variable_global_exists("krokosha_exit_positions_of_car_idk_bruh"))
    global.krokosha_exit_positions_of_car_idk_bruh = [];

function movetoward(arg0, arg1, arg2)
{
    if (arg0 < arg1)
        return min(arg0 + arg2, arg1);
    else if (arg0 > arg1)
        return max(arg0 - arg2, arg1);
    
    return arg1;
}

function check_if_car_manager_exists()
{
    if (!instance_exists(krokosha_car_manager))
        instance_create_depth(0, 0, 4000, krokosha_car_manager);
    
    return 1576;
}

check_if_car_manager_exists();

function movetoward_vector(arg0, arg1, arg2, arg3, arg4)
{
    var dx = arg2 - arg0;
    var dy = arg3 - arg1;
    var dist = sqrt((dx * dx) + (dy * dy));
    
    if (dist <= arg4)
        return [arg2, arg3];
    
    return [arg0 + ((dx / dist) * arg4), arg1 + ((dy / dist) * arg4)];
}

function clamp(arg0, arg1, arg2)
{
    return median(arg0, arg1, arg2);
}

function clamp01(arg0)
{
    return clamp(arg0, 0, 1);
}

function sign(arg0)
{
    if (arg0 == 0)
        return 0;
    
    return (arg0 > 0) ? 1 : -1;
}

function angle_to_dir(arg0)
{
    return [sin(arg0), -cos(arg0)];
}

function vec2_length(arg0, arg1)
{
    return sqrt((arg0 * arg0) + (arg1 * arg1));
}

function vec2_length_sq(arg0, arg1)
{
    return (arg0 * arg0) + (arg1 * arg1);
}

function vec2_normalize(arg0, arg1)
{
    var len = vec2_length(arg0, arg1);
    
    if (len == 0)
        return [0, 0];
    
    return [arg0 / len, arg1 / len];
}

no_player_control_override_wishthrottle = 0;
no_player_control_override_wishsteer = 0;
no_player_control_override_handbrake = 0;

if (!variable_instance_exists(id, "doors_locked"))
    doors_locked = false;

if (!variable_instance_exists(id, "renderfidelity"))
    renderfidelity = 1;

is_fwd = false;
is_rwd = true;
is_awd = false;
maxturnangle = degtorad(42);
normalturnangle = degtorad(25);
highspeedturnangle = degtorad(10);
maxspeed = 225;
reversemaxspeed = 27;
acceleration = 5;
brakestrength = 5;
steerspeed = 20;
tiretraction = 0.5;
wheel_scale = 1;
krokosha_darkworldscale = 1;
is_player_in_the_car = false;
is_player_the_driver = false;
enable_debug_secondary_controls = true;

if (!variable_instance_exists(id, "car_name"))
    car_name = "graycar";

car_modelresourcefound = false;
has_custom_engine_sound = false;
renderwheels = false;
electricengine = false;
max_lean_angle_deg = 12;
leanmultiplier = 1.4;
car_low_res_surface = undefined;
default_car_low_res_surface_size = 128;
car_low_res_surface_size = default_car_low_res_surface_size;
car_texture_as_sprite = undefined;
car_texture = undefined;
vertex_format = undefined;
vertex_buffer = undefined;
car_engine_sound_stream = undefined;
car_tirescreech_sound = undefined;
car_engine_sound = undefined;
wheelbase_x = 3.5;
wheelbase_y = 9;
last_wheelpos_arr = [[0, 0], [0, 0], [0, 0], [0, 0]];
last_realsteerangle = 0;
krokosha_pressing_honk_button = false;

if (!variable_instance_exists(id, "velocity_x"))
{
    velocity_x = 0;
    last_velocity_x = 0;
}
else
{
    last_velocity_x = velocity_x;
}

if (!variable_instance_exists(id, "velocity_y"))
{
    velocity_y = 0;
    last_velocity_y = 0;
}
else
{
    last_velocity_y = velocity_y;
}

if (!variable_instance_exists(id, "running"))
    running = false;

if (!variable_instance_exists(id, "angular_velocity"))
    angular_velocity = 0;

rotation_inertia = 1;
vehicle_mass = 1;

if (!variable_instance_exists(id, "carangle"))
    carangle = 0;

if (!variable_instance_exists(id, "steer"))
    steer = 0;

car_airspeed = 0;
car_speed = 0;
car_side_speed = 0;

if (!variable_instance_exists(id, "skidding"))
    skidding = 0;

if (!variable_instance_exists(id, "rwd_burnout"))
    rwd_burnout = 0;

if (!variable_instance_exists(id, "fwd_burnout"))
    fwd_burnout = 0;

frontwheels_rollangle = random(5);
rearwheels_rollangle = random(5);
smooth_velocity_diff_x = 0;
smooth_velocity_diff_y = 0;
spr_vel_smooth_velocity_diff_x = 0;
spr_vel_smooth_velocity_diff_y = 0;
wheelrimcolor1_r = 1;
wheelrimcolor1_g = 0;
wheelrimcolor1_b = 0;
wheelrimcolor2_r = 0;
wheelrimcolor2_g = 0;
wheelrimcolor2_b = 1;
car_impact_cooldown = 0;
car_impact_touching_wallrn = false;
krokosha_dev_temp_col_visual = [];
entering_car_smooth = false;
entering_car_smooth_timestart = 0;
is_leaving_car = false;
krokosha_kris_center_offset_x = 9;
krokosha_kris_center_offset_y = 21.5;

if (!variable_instance_exists(id, "car_spawnreason"))
    car_spawnreason = 0;

if (!variable_instance_exists(id, "car_globalreferenceindex"))
    car_globalreferenceindex = -1;

function spring_calc(arg0, arg1, arg2, arg3, arg4, arg5)
{
    var to_travel = arg2 - arg1;
    var stiff = to_travel * arg3;
    var damp = arg0 * arg4;
    var newspring = stiff - damp;
    return newspring;
}

function play_car_impact_sound()
{
    if (car_impact_cooldown == 0)
    {
        audio_play_sound(snd_impact, 1, false);
        car_impact_cooldown = 0.4;
        check_if_car_manager_exists();
        
        if (abs(car_airspeed) > 120 && is_player_the_driver && is_player_in_the_car)
            krokosha_car_manager.krokosha_do_carcrash_dialogue();
    }
}

function krokosha_car_is_moving()
{
    return abs(car_speed) > 0.01 || abs(angular_velocity) > 0.01;
}

function krokosha_get_velocity_at_local_point(arg0, arg1)
{
    var tangentX = -arg1;
    var tangentY = arg0;
    return [velocity_x + (angular_velocity * tangentX), velocity_y + (angular_velocity * tangentY)];
}

function krokosha_apply_impulse(arg0, arg1, arg2, arg3)
{
    velocity_x += (arg0 / vehicle_mass);
    velocity_y += (arg1 / vehicle_mass);
    var torque = (arg2 * arg1) - (arg3 * arg0);
    angular_velocity += (torque / rotation_inertia);
}

function krokosha_get_corners()
{
    var carlook = angle_to_dir(carangle);
    var carlook_x = carlook[0];
    var carlook_y = carlook[1];
    var carside_x = -carlook_y;
    var carside_y = carlook_x;
    var loc_hwby_x = carlook_x * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwby_y = carlook_y * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_x = carside_x * wheelbase_x * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_y = carside_y * wheelbase_x * 0.5 * krokosha_darkworldscale;
    return [x + (loc_hwby_x - loc_hwbx_x), y + (loc_hwby_y - loc_hwbx_y), x + (loc_hwby_x + loc_hwbx_x), y + (loc_hwby_y + loc_hwbx_y), x + (-loc_hwby_x - loc_hwbx_x), y + (-loc_hwby_y - loc_hwbx_y), x + (-loc_hwby_x + loc_hwbx_x), y + (-loc_hwby_y + loc_hwbx_y)];
}

function apply_car_velocity()
{
    var dt = delta_time / 1000000;
    dt = min(dt, 0.06666);
    var carlook = angle_to_dir(carangle);
    var carlook_x = carlook[0];
    var carlook_y = carlook[1];
    var carside_x = -carlook_y;
    var carside_y = carlook_x;
    var loc_hwby_x = carlook_x * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwby_y = carlook_y * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_x = carside_x * wheelbase_x * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_y = carside_y * wheelbase_x * 0.5 * krokosha_darkworldscale;
    var new_x = x + (velocity_x * dt * krokosha_darkworldscale);
    var new_y = y + (velocity_y * dt * krokosha_darkworldscale);
    
    if (abs(car_airspeed) > 30)
    {
        var vehicular_manslaughter_check_array = [];
        
        for (var i = 0; i < array_length(krokosha_car_manager.vehicular_manslaughter_objects_list); i++)
        {
            var name_to_slaughter = krokosha_car_manager.vehicular_manslaughter_objects_list[i];
            var found_asset = asset_get_index(name_to_slaughter[0]);
            
            if (found_asset)
            {
                if (name_to_slaughter[1](name_to_slaughter[0], found_asset))
                    array_push(vehicular_manslaughter_check_array, [found_asset, name_to_slaughter[1], name_to_slaughter[2]]);
            }
        }
        
        for (var i = 0; i < array_length(vehicular_manslaughter_check_array); i++)
        {
            var obj_to_slaughter = vehicular_manslaughter_check_array[i];
            var _list = ds_list_create();
            var _num = collision_circle_list(new_x + (loc_hwby_x * sign(car_speed)), new_y + (loc_hwby_y * sign(car_speed)), wheelbase_x * 0.5, obj_to_slaughter[0], true, true, _list, false);
            
            if (_num > 0)
            {
                for (i = 0; i < _num; i++)
                {
                    var killing_enemy = ds_list_find_value(_list, i);
                    
                    if (killing_enemy && instance_exists(killing_enemy))
                        obj_to_slaughter[2](killing_enemy, self);
                }
            }
            
            ds_list_destroy(_list);
        }
    }
    
    var check_collision = true;
    
    if (keyboard_check(ord("T")))
        check_collision = false;
    
    if (!check_collision)
    {
        x = new_x;
        y = new_y;
        car_impact_touching_wallrn = false;
        exit;
    }
    
    var cur_forwardspeed = dot_product(carlook_x, carlook_y, velocity_x, velocity_y);
    var totalspeed = abs(velocity_x) + abs(velocity_y);
    array_delete(krokosha_dev_temp_col_visual, 0, array_length(krokosha_dev_temp_col_visual));
    var hit_front = collision_line(x, y, new_x + loc_hwby_x, new_y + loc_hwby_y, obj_solidblock, true, true);
    
    if (hit_front)
        array_push(krokosha_dev_temp_col_visual, [new_x + loc_hwby_x, new_y + loc_hwby_y]);
    
    var hit_fl = collision_line(x, y, new_x + (loc_hwby_x - loc_hwbx_x), new_y + (loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
    
    if (hit_fl)
        array_push(krokosha_dev_temp_col_visual, [new_x + (loc_hwby_x - loc_hwbx_x), new_y + (loc_hwby_y - loc_hwbx_y)]);
    
    var hit_fr = collision_line(x, y, new_x + (loc_hwby_x + loc_hwbx_x), new_y + (loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
    
    if (hit_fr)
        array_push(krokosha_dev_temp_col_visual, [new_x + (loc_hwby_x + loc_hwbx_x), new_y + (loc_hwby_y + loc_hwbx_y)]);
    
    var hit_left = collision_line(x, y, new_x + (-loc_hwbx_x * 1.1), new_y + (-loc_hwbx_y * 1.1), obj_solidblock, true, true);
    
    if (hit_left)
        array_push(krokosha_dev_temp_col_visual, [new_x + (-loc_hwbx_x * 1.1), new_y + (-loc_hwbx_y * 1.1)]);
    
    var hit_right = collision_line(x, y, new_x + (loc_hwbx_x * 1.1), new_y + (loc_hwbx_y * 1.1), obj_solidblock, true, true);
    
    if (hit_right)
        array_push(krokosha_dev_temp_col_visual, [new_x + (loc_hwbx_x * 1.1), new_y + (loc_hwbx_y * 1.1)]);
    
    var hit_rear = collision_line(x, y, new_x + -loc_hwby_x, new_y + -loc_hwby_y, obj_solidblock, true, true);
    
    if (hit_rear)
        array_push(krokosha_dev_temp_col_visual, [new_x + -loc_hwby_x, new_y + -loc_hwby_y]);
    
    var hit_rl = collision_line(x, y, new_x + (-loc_hwby_x - loc_hwbx_x), new_y + (-loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
    
    if (hit_rl)
        array_push(krokosha_dev_temp_col_visual, [new_x + (-loc_hwby_x - loc_hwbx_x), new_y + (-loc_hwby_y - loc_hwbx_y)]);
    
    var hit_rr = collision_line(x, y, new_x + (-loc_hwby_x + loc_hwbx_x), new_y + (-loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
    
    if (hit_rr)
        array_push(krokosha_dev_temp_col_visual, [new_x + (-loc_hwby_x + loc_hwbx_x), new_y + (-loc_hwby_y + loc_hwbx_y)]);
    
    var hit_dir_of_movement = false;
    
    if (car_airspeed > 5)
    {
        var vnormal = vec2_normalize(velocity_x, velocity_y);
        hit_dir_of_movement = collision_line(x, y, new_x + (vnormal[0] * wheelbase_x * 0.5 * krokosha_darkworldscale), new_y + (vnormal[1] * wheelbase_x * 0.5 * krokosha_darkworldscale), obj_solidblock, true, true);
        
        if (hit_dir_of_movement)
            array_push(krokosha_dev_temp_col_visual, [new_x + (vnormal[0] * wheelbase_x * 0.5), new_y + (vnormal[1] * wheelbase_x * 0.5)]);
    }
    
    var real_hit_happened = false;
    
    if (hit_rl && hit_rear && hit_rr && hit_fl && hit_front && hit_fr && hit_left && hit_right)
    {
        car_impact_touching_wallrn = true;
        velocity_x *= clamp01(1 - dt);
        velocity_y *= clamp01(1 - dt);
        x = new_x;
        y = new_y;
    }
    else if (hit_dir_of_movement)
    {
        velocity_x *= 0.2;
        velocity_y *= 0.2;
        
        if (totalspeed > 48 && !car_impact_touching_wallrn)
            play_car_impact_sound();
        
        real_hit_happened = true;
    }
    else if (hit_rl || hit_rear || hit_rr)
    {
        var actually_should_go_through = hit_rl && !hit_rear && hit_rr;
        
        if (cur_forwardspeed < 0 && !actually_should_go_through)
        {
            var oldx_hit_rear = collision_line(x, y, x + -loc_hwby_x, new_y + -loc_hwby_y, obj_solidblock, true, true);
            var oldx_hit_rl = collision_line(x, y, x + (-loc_hwby_x - loc_hwbx_x), new_y + (-loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
            var oldx_hit_rr = collision_line(x, y, x + (-loc_hwby_x + loc_hwbx_x), new_y + (-loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
            var oldy_hit_rear = collision_line(x, y, new_x + -loc_hwby_x, y + -loc_hwby_y, obj_solidblock, true, true);
            var oldy_hit_rl = collision_line(x, y, new_x + (-loc_hwby_x - loc_hwbx_x), y + (-loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
            var oldy_hit_rr = collision_line(x, y, new_x + (-loc_hwby_x + loc_hwbx_x), y + (-loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
            var hit_on_old_x = oldx_hit_rear || oldx_hit_rl || oldx_hit_rr;
            var hit_on_old_y = oldy_hit_rear || oldy_hit_rl || oldy_hit_rr;
            
            if (hit_on_old_x && hit_on_old_y)
            {
                velocity_x *= 0.2;
                velocity_y *= 0.2;
            }
            else if (hit_on_old_y)
            {
                velocity_x *= 0.1;
                y = new_y;
            }
            else if (hit_on_old_x)
            {
                velocity_y *= 0.1;
                x = new_x;
            }
            else
            {
                velocity_x *= 0.8;
                velocity_y *= 0.8;
            }
            
            angular_velocity *= 0.9;
            var dist = carangle % 1.5707963267948966;
            
            if (dist > 0.0001 && dist < 1.5706963267948966)
            {
                if (dist > 0.7853981633974483)
                    carangle += (dist * dt);
                else
                    carangle -= (dist * dt);
            }
            
            if (totalspeed > 48 && !car_impact_touching_wallrn)
                play_car_impact_sound();
            
            real_hit_happened = true;
        }
        else
        {
            x = new_x;
            y = new_y;
            
            if (actually_should_go_through)
                carangle = round(carangle / 0.7853981633974483) * pi * 0.25;
        }
        
        car_impact_touching_wallrn = true;
    }
    else if (hit_fl || hit_front || hit_fr)
    {
        var actually_should_go_through = hit_fl && !hit_front && hit_fr;
        
        if (cur_forwardspeed > 0 && !actually_should_go_through)
        {
            var oldx_hit_front = collision_line(x, y, x + loc_hwby_x, new_y + loc_hwby_y, obj_solidblock, true, true);
            var oldx_hit_fl = collision_line(x, y, x + (loc_hwby_x - loc_hwbx_x), new_y + (loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
            var oldx_hit_fr = collision_line(x, y, x + (loc_hwby_x + loc_hwbx_x), new_y + (loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
            var oldy_hit_front = collision_line(x, y, new_x + loc_hwby_x, y + loc_hwby_y, obj_solidblock, true, true);
            var oldy_hit_fl = collision_line(x, y, new_x + (loc_hwby_x - loc_hwbx_x), y + (loc_hwby_y - loc_hwbx_y), obj_solidblock, true, true);
            var oldy_hit_fr = collision_line(x, y, new_x + (loc_hwby_x + loc_hwbx_x), y + (loc_hwby_y + loc_hwbx_y), obj_solidblock, true, true);
            var hit_on_old_x = oldx_hit_front || oldx_hit_fl || oldx_hit_fr;
            var hit_on_old_y = oldy_hit_front || oldy_hit_fl || oldy_hit_fr;
            
            if (hit_on_old_x && hit_on_old_y)
            {
                velocity_x *= 0.2;
                velocity_y *= 0.2;
            }
            else if (hit_on_old_y)
            {
                velocity_x *= 0.1;
                y = new_y;
            }
            else if (hit_on_old_x)
            {
                velocity_y *= 0.1;
                x = new_x;
            }
            else
            {
                velocity_x *= 0.8;
                velocity_y *= 0.8;
            }
            
            angular_velocity *= 0.9;
            var dist = carangle % 1.5707963267948966;
            
            if (dist > 0.0001 && dist < 1.5706963267948966)
            {
                if (dist > 0.7853981633974483)
                    carangle += (dist * dt);
                else
                    carangle -= (dist * dt);
            }
            
            if (totalspeed > 48 && !car_impact_touching_wallrn)
                play_car_impact_sound();
            
            real_hit_happened = true;
        }
        else
        {
            x = new_x;
            y = new_y;
            
            if (actually_should_go_through)
                carangle = round(carangle / 0.7853981633974483) * pi * 0.25;
        }
        
        car_impact_touching_wallrn = true;
    }
    else if (hit_left || hit_right)
    {
        if ((car_side_speed > 0 && hit_right) || (car_side_speed < 0 && hit_left))
        {
            skidding = 0;
            rwd_burnout *= 0.1;
            var side_friction = car_side_speed * 0.99;
            velocity_x -= (carside_x * side_friction);
            velocity_y -= (carside_y * side_friction);
            velocity_x *= 0.8;
            velocity_y *= 0.8;
            x += (velocity_x * dt * krokosha_darkworldscale);
            y += (velocity_y * dt * krokosha_darkworldscale);
            
            if (totalspeed > 48 && !car_impact_touching_wallrn)
                play_car_impact_sound();
            
            real_hit_happened = true;
        }
        else
        {
            x = new_x;
            y = new_y;
        }
        
        car_impact_touching_wallrn = true;
    }
    else if (totalspeed > 0)
    {
        if (place_meeting(new_x, new_y, obj_solidblock))
        {
            if (totalspeed > 48 && !car_impact_touching_wallrn)
                play_car_impact_sound();
            
            car_impact_touching_wallrn = true;
            
            if (place_meeting(new_x, y, obj_solidblock))
            {
                y = new_y;
                velocity_x *= 0.1;
            }
            else if (place_meeting(x, new_y, obj_solidblock))
            {
                x = new_x;
                velocity_y *= 0.1;
            }
            else
            {
                velocity_x *= 0.2;
                velocity_y *= 0.2;
            }
            
            var dist = carangle % 1.5707963267948966;
            
            if (dist > 0.0001 && dist < 1.5706963267948966)
            {
                if (dist > 0.7853981633974483)
                    carangle += (dist * dt);
                else
                    carangle -= (dist * dt);
            }
            
            real_hit_happened = true;
        }
        else
        {
            car_impact_touching_wallrn = false;
            x = new_x;
            y = new_y;
        }
    }
    else
    {
    }
}

function update_car()
{
    var dt = delta_time / 1000000;
    dt = min(dt, 0.06666);
    check_if_car_manager_exists();
    krokosha_car_manager.krokosha_collision_interaction_overrides_check_now();
    
    if (variable_global_exists("darkzone"))
    {
        if (global.darkzone)
            krokosha_darkworldscale = 2;
        else
            krokosha_darkworldscale = 1;
    }
    
    if (array_length(global.krokosha_car_mod_all_cars_tracker_array) < car_globalreferenceindex)
    {
        car_explode();
        exit;
    }
    else if (array_length(global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex]) < 8)
    {
        car_explode();
        exit;
    }
    
    var room_changed = global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][7] != room;
    var is_ch1_forestmaze = asset_get_index("obj_forestmaze_controller") && instance_exists(obj_forestmaze_controller);
    
    if (is_ch1_forestmaze)
    {
        if (variable_instance_exists(id, "krokosha_ch1_forestmaze_tracker"))
            room_changed = room_changed || krokosha_ch1_forestmaze_tracker != obj_forestmaze_controller.roomno;
    }
    
    if (is_player_in_the_car && room_changed && instance_exists(obj_mainchara) && !obj_mainchara.cutscene)
    {
        if (is_ch1_forestmaze)
        {
            if (!variable_instance_exists(id, "krokosha_ch1_forestmaze_tracker"))
                krokosha_ch1_forestmaze_tracker = obj_forestmaze_controller.roomno;
            
            if (krokosha_ch1_forestmaze_tracker != obj_forestmaze_controller.roomno)
            {
                krokosha_ch1_forestmaze_tracker = obj_forestmaze_controller.roomno;
                krokosha_car_mgr_reset_skidmark_surfaces();
            }
        }
        
        global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][7] = room;
        
        if (!krokosha_car_manager.krokosha_dev_test_no_interact)
        {
            if (is_player_in_the_car && global.interact == 0)
                global.interact = 1;
        }
        
        x = obj_mainchara.x + (krokosha_kris_center_offset_x * krokosha_darkworldscale);
        y = obj_mainchara.y + (krokosha_kris_center_offset_y * krokosha_darkworldscale);
        obj_mainchara.visible = 0;
        
        for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
        {
            var partymember = instance_find(obj_caterpillarchara, i);
            partymember.visible = 0;
        }
        
        carlook = angle_to_dir(carangle);
        carlook_x = carlook[0];
        carlook_y = carlook[1];
        carside_x = -carlook_y;
        carside_y = carlook_x;
        loc_hwby_x = carlook_x * wheelbase_y * 0.5 * krokosha_darkworldscale;
        loc_hwby_y = carlook_y * wheelbase_y * 0.5 * krokosha_darkworldscale;
        loc_hwbx_x = carside_x * wheelbase_x * 0.5 * krokosha_darkworldscale;
        loc_hwbx_y = carside_y * wheelbase_x * 0.5 * krokosha_darkworldscale;
        
        for (var i = 0; i < array_length(last_wheelpos_arr); i++)
        {
            var cur_real_wpos_x = x;
            var cur_real_wpos_y = y;
            
            if (i <= 1)
            {
                if (i == 0)
                {
                    cur_real_wpos_x = x + (loc_hwby_x - loc_hwbx_x);
                    cur_real_wpos_y = y + (loc_hwby_y - loc_hwbx_y);
                }
                else
                {
                    cur_real_wpos_x = x + (loc_hwby_x + loc_hwbx_x);
                    cur_real_wpos_y = y + (loc_hwby_y + loc_hwbx_y);
                }
                
                cur_real_wpos_y += 1;
            }
            else
            {
                if (i == 2)
                {
                    cur_real_wpos_x = x + (-loc_hwby_x - loc_hwbx_x);
                    cur_real_wpos_y = y + (-loc_hwby_y - loc_hwbx_y);
                }
                else
                {
                    cur_real_wpos_x = x + (-loc_hwby_x + loc_hwbx_x);
                    cur_real_wpos_y = y + (-loc_hwby_y + loc_hwbx_y);
                }
                
                cur_real_wpos_y += 1;
            }
            
            last_wheelpos_arr[i][0] = cur_real_wpos_x;
            last_wheelpos_arr[i][1] = cur_real_wpos_y;
        }
        
        if (asset_get_index("obj_controller_city_mice3"))
        {
            if (instance_exists(obj_controller_city_mice3))
            {
                if (global.flag[379] == 0)
                {
                    car_explode();
                    exit;
                }
            }
        }
    }
    else if (is_leaving_car && entering_car_smooth)
    {
    }
    else if (entering_car_smooth && instance_exists(obj_mainchara))
    {
        var carenterspeed = dt * 200;
        var better_center_car_pos_x = x - (krokosha_kris_center_offset_x * krokosha_darkworldscale);
        var better_center_car_pos_y = y - (krokosha_kris_center_offset_y * krokosha_darkworldscale);
        var movedtoward_kindacardoor = movetoward_vector(better_center_car_pos_x, better_center_car_pos_y, obj_mainchara.x, obj_mainchara.y, wheelbase_x * 0.5 * krokosha_darkworldscale);
        better_center_car_pos_x = movedtoward_kindacardoor[0];
        better_center_car_pos_y = movedtoward_kindacardoor[1];
        obj_mainchara.x = round(movetoward(obj_mainchara.x, better_center_car_pos_x, carenterspeed));
        obj_mainchara.y = round(movetoward(obj_mainchara.y, better_center_car_pos_y, carenterspeed));
        
        for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
        {
            var partymember = instance_find(obj_caterpillarchara, i);
            partymember.x = round(movetoward(partymember.x, better_center_car_pos_x, carenterspeed));
            partymember.y = round(movetoward(partymember.y, better_center_car_pos_y, carenterspeed));
        }
        
        if ((current_time - entering_car_smooth_timestart) > 300)
        {
            car_player_enter_now();
            entering_car_smooth = false;
        }
    }
    else if (is_player_in_the_car && instance_exists(obj_mainchara))
    {
        var ignore_interact = check_if_car_manager_exists().krokosha_current_room_matches([["room_dark7", "room_forest_afterthrash2", "room_forest_afterthrash3", "room_forest_afterthrash4", "room_forest_castleview", "room_forest_chase1", "room_dark_chase1", "room_forest_chase2"], [], [], ["room_dw_churchc_darkswords"]], krokosha_car_manager.car_ignore_interact_in_rooms);
        
        if (obj_mainchara.cutscene || ((!ignore_interact && (global.interact > 0 && global.interact != 3 && global.interact != 5 && global.interact != 6)) || (global.interact == 2 && instance_exists(obj_encounterbasic)) || (variable_global_exists("fighting") && global.fighting)))
        {
            car_explode();
            exit;
        }
        else
        {
            obj_mainchara.x = round(x) - (krokosha_kris_center_offset_x * krokosha_darkworldscale);
            obj_mainchara.y = round(y) - (krokosha_kris_center_offset_y * krokosha_darkworldscale);
            obj_mainchara.battleheart.x = obj_mainchara.x + 12;
            obj_mainchara.battleheart.y = obj_mainchara.y + 40;
            
            for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
            {
                var partymember = instance_find(obj_caterpillarchara, i);
                partymember.x = obj_mainchara.x;
                partymember.y = obj_mainchara.y;
                
                for (i = 0; i < array_length(partymember.remx); i++)
                {
                    partymember.remx[i] = obj_mainchara.x;
                    partymember.remy[i] = obj_mainchara.y;
                    partymember.facing[i] = global.facing;
                }
            }
            
            if (asset_get_index("obj_noelle_city_traffic_2"))
            {
                if (instance_exists(obj_noelle_city_traffic_2))
                {
                    obj_noelle_city_traffic_2.visible = false;
                    
                    if (obj_noelle_city_traffic_2.mycater != 0)
                    {
                        with (obj_caterpillarchara)
                        {
                            if (name == "noelle")
                                visible = false;
                        }
                    }
                }
            }
        }
    }
    
    car_impact_cooldown -= dt;
    
    if (car_impact_cooldown < 0)
        car_impact_cooldown = 0;
    
    last_velocity_x = velocity_x;
    last_velocity_y = velocity_y;
    var wishdir = 0;
    var throttle = 0;
    var brake = 0;
    var goalsteer = 0;
    var handbrake = 0;
    
    if (is_player_the_driver)
    {
        if (krokosha_car_manager.krokosha_player_current_car != self)
        {
            is_player_in_the_car = false;
            exit;
        }
        
        var is_in_inventory = variable_global_exists("interact") && global.interact == 5;
        
        if (!is_in_inventory)
        {
            if (up_h())
                wishdir = wishdir + 1;
            
            if (down_h())
                wishdir = wishdir - 1;
            
            if (left_h())
                goalsteer = goalsteer - 1;
            
            if (right_h())
                goalsteer = goalsteer + 1;
            
            if (button2_h())
                handbrake = 1;
        }
        else
        {
            handbrake = 0.5;
        }
    }
    else
    {
        wishdir = no_player_control_override_wishthrottle;
        goalsteer = no_player_control_override_wishsteer;
        handbrake = no_player_control_override_handbrake;
    }
    
    var preparing_to_reverse = sign(wishdir) != sign(car_speed);
    
    if (wishdir != 0)
    {
        if (preparing_to_reverse && car_speed != 0 && skidding < 0.3)
            brake = 1;
        else
            throttle = 1;
    }
    
    if (car_airspeed < (wheelbase_y * 0.3) && abs(wishdir) < 0.01)
        brake = clamp01((car_speed / wheelbase_y) * 0.3);
    
    if (car_airspeed < (wheelbase_y * 0.1) && (abs(wishdir) < 0.01 || !running))
        handbrake = 1;
    
    if (throttle > 0.8 && handbrake > 0.1 && abs(car_speed) < (wheelbase_y * 0.8))
    {
        if (is_rwd)
            rwd_burnout = movetoward(rwd_burnout, 1, dt * 15);
        else
            fwd_burnout = movetoward(fwd_burnout, 1, dt * 15);
        
        angular_velocity += (maxturnangle * steer * wishdir * dt * (1 + skidding));
        skidding = lerp(skidding, 1, dt);
        brake = 1;
        handbrake = 0;
    }
    else
    {
        rwd_burnout = movetoward(rwd_burnout, 0, dt * 3);
        fwd_burnout = movetoward(fwd_burnout, 0, dt * 3);
    }
    
    if (!running)
        throttle = 0;
    
    var realmaxsteerangle = maxturnangle;
    var maxsteer_curve = array_create(4);
    maxsteer_curve[0] = [-0.1, maxturnangle];
    maxsteer_curve[1] = [wheelbase_y * 1.5, maxturnangle];
    maxsteer_curve[2] = [wheelbase_y * 3, normalturnangle];
    maxsteer_curve[3] = [wheelbase_y * 7, highspeedturnangle];
    var my_point = abs(car_speed) * (1 - (skidding * 0.5));
    var min_tq = undefined;
    var max_tq = undefined;
    
    for (var i = 0; i < array_length(maxsteer_curve); i++)
    {
        if (my_point < maxsteer_curve[i][0])
        {
            min_tq = maxsteer_curve[i - 1];
            max_tq = maxsteer_curve[i];
            break;
        }
    }
    
    if (is_undefined(min_tq))
    {
        realmaxsteerangle = maxsteer_curve[array_length(maxsteer_curve) - 1][1];
    }
    else
    {
        var rpsdelta = max_tq[0] - min_tq[0];
        var delta = (my_point - min_tq[0]) / rpsdelta;
        realmaxsteerangle = lerp(min_tq[1], max_tq[1], delta);
    }
    
    var carlook = angle_to_dir(carangle);
    var carlook_x = carlook[0];
    var carlook_y = carlook[1];
    var carside_x = -carlook_y;
    var carside_y = carlook_x;
    var airspeed = vec2_length(velocity_x, velocity_y);
    var velocity_dir_x, velocity_dir_y;
    
    if (airspeed < 0.01)
    {
        velocity_dir_x = carlook_x;
        velocity_dir_y = carlook_y;
    }
    else
    {
        var normalized = vec2_normalize(velocity_x, velocity_y);
        velocity_dir_x = normalized[0];
        velocity_dir_y = normalized[1];
    }
    
    var velocity_aligment = abs(dot_product(velocity_dir_x, velocity_dir_y, carlook_x, carlook_y));
    var steerspeed_framedelta = dt * steerspeed;
    var result = movetoward(steer, goalsteer, steerspeed_framedelta);
    var oldangle = steer * realmaxsteerangle;
    var newangle = result * realmaxsteerangle;
    var prevlook = angle_to_dir(carangle + oldangle);
    var newturnlook = angle_to_dir(carangle + newangle);
    var dot = dot_product(velocity_dir_x, velocity_dir_y, newturnlook[0], newturnlook[1]);
    var olddot = dot_product(velocity_dir_x, velocity_dir_y, prevlook[0], prevlook[1]);
    
    if (dot > olddot && car_speed > 1)
        steer = result;
    else
        steer = lerp(steer, result, 0.5);
    
    var cur_turnangle = steer * realmaxsteerangle;
    last_realsteerangle = cur_turnangle;
    skidding = movetoward(skidding, 0, dt * ((tiretraction - (throttle * 0.4)) + (clamp01(velocity_aligment - 0.4) * 0.5) + ((1 - abs(wishdir)) * 7)));
    
    if ((is_fwd || is_awd) && !preparing_to_reverse && wishdir > 0)
    {
        var coeff = is_fwd ? 1 : 0.5;
        skidding = movetoward(skidding, fwd_burnout, dt * throttle * 2 * coeff);
        
        if (skidding > 0.5)
            angular_velocity += (cur_turnangle * dt * coeff);
    }
    
    var traction = clamp(1 - power(skidding, 0.1), 0.01, 1);
    var realmaxspeed = (car_speed < 0) ? reversemaxspeed : maxspeed;
    var maxspeed_choker = clamp01(abs(car_speed) / realmaxspeed);
    maxspeed_choker = 1 - power(maxspeed_choker, 2);
    var engineforce = ((!is_rwd && throttle) || clamp01(throttle - brake)) * sign(wishdir) * acceleration * wheelbase_y * max(traction, 0.9) * maxspeed_choker;
    
    if (is_rwd || fwd_burnout > 0.15)
    {
        if ((rwd_burnout + fwd_burnout) > 0.98)
        {
            skidding = clamp01(skidding + (dt * 20));
            engineforce *= 0.01;
        }
        else if (handbrake > 0.3)
        {
            engineforce *= 0.01;
        }
    }
    
    var brakeforce = max(brake, handbrake) * -clamp(car_speed, -wheelbase_y * 2, wheelbase_y * 2) * max(traction, velocity_aligment * 0.5) * brakestrength;
    velocity_x += (carlook_x * (engineforce + brakeforce) * dt);
    velocity_y += (carlook_y * (engineforce + brakeforce) * dt);
    var slowed = movetoward_vector(velocity_x, velocity_y, 0, 0, dt * min(wheelbase_x, wheelbase_y));
    velocity_x = slowed[0];
    velocity_y = slowed[1];
    
    if (brake != 0 && steer != 0)
        skidding = max(skidding, clamp01(abs(realmaxsteerangle / maxturnangle)) * 0.3);
    
    if (is_rwd)
    {
        rwd_burnout = max(rwd_burnout, clamp01(((1 - abs(velocity_aligment)) + (angular_velocity * 0.25)) * throttle));
        skidding = max(skidding, rwd_burnout * 0.9);
    }
    
    apply_car_velocity();
    airspeed = vec2_length(velocity_x, velocity_y);
    car_airspeed = airspeed;
    var scalar_airspeed = airspeed / max(wheelbase_x, wheelbase_y);
    var forwardspeed = dot_product(carlook_x, carlook_y, velocity_x, velocity_y);
    car_speed = forwardspeed;
    var sidespeed = dot_product(carside_x, carside_y, velocity_x, velocity_y);
    car_side_speed = sidespeed;
    
    if (scalar_airspeed > 2.2 && forwardspeed != 0)
        skidding = max(skidding, clamp01(abs(sidespeed / forwardspeed)));
    
    if (scalar_airspeed < 1.7 && rwd_burnout < 0.8 && throttle < 0.1)
        skidding = skidding * clamp01(scalar_airspeed) * 0.7;
    
    if (is_rwd)
    {
        var thing2 = sign(forwardspeed);
        
        if (forwardspeed < 0 && (wishdir <= 0 || traction > 0.9))
            thing2 = -thing2;
        
        angular_velocity = lerp((forwardspeed * thing2 * tan(cur_turnangle)) / wheelbase_y, angular_velocity, clamp(power(skidding, 0.5 - (throttle * 0.4)), 0, 0.95));
    }
    else
    {
        angular_velocity = lerp((forwardspeed * tan(cur_turnangle)) / wheelbase_y, angular_velocity, clamp(power(skidding, 0.5 - (throttle * 0.4)), 0, 0.95));
    }
    
    if (handbrake > 0)
    {
        angular_velocity = lerp(0, angular_velocity, clamp01(skidding + scalar_airspeed));
        
        if (car_speed > wheelbase_y)
            skidding = max(skidding, clamp01((car_speed - wheelbase_y) / wheelbase_y));
    }
    else
    {
        rearwheels_rollangle += (((car_speed / 8) + (rwd_burnout * 10 * wishdir)) * dt * (1 + rwd_burnout + skidding));
    }
    
    frontwheels_rollangle += (((car_speed / 8) + (fwd_burnout * 10 * wishdir)) * dt * (1 + fwd_burnout + skidding));
    carangle += (angular_velocity * dt);
    var side_friction = sidespeed * traction;
    velocity_x -= (carside_x * side_friction);
    velocity_y -= (carside_y * side_friction);
    var veldiff_x = last_velocity_x - velocity_x;
    var veldiff_y = last_velocity_y - velocity_y;
    var _vellimit = max(0, max_lean_angle_deg - 2.1);
    var doty = clamp((dot_product(veldiff_x, veldiff_y, carlook_x, carlook_y) - (rwd_burnout * 5 * wishdir)) * leanmultiplier, -_vellimit, _vellimit);
    var dotx = clamp(dot_product(veldiff_x, veldiff_y, carside_x, carside_y) * leanmultiplier, -_vellimit, _vellimit);
    spr_vel_smooth_velocity_diff_x += (spring_calc(spr_vel_smooth_velocity_diff_x, smooth_velocity_diff_x, dotx, 160, 9, dt) * dt);
    spr_vel_smooth_velocity_diff_y += (spring_calc(spr_vel_smooth_velocity_diff_y, smooth_velocity_diff_y, doty, 190, 9, dt) * dt);
    smooth_velocity_diff_x += clamp(spr_vel_smooth_velocity_diff_x * dt, -max_lean_angle_deg, max_lean_angle_deg);
    smooth_velocity_diff_y += clamp(spr_vel_smooth_velocity_diff_y * dt, -max_lean_angle_deg, max_lean_angle_deg);
    
    if (skidding > 0.1)
        audio_sound_gain(car_tirescreech_sound, clamp01(power(skidding, 0.6)) * 0.4, 5);
    else
        audio_sound_gain(car_tirescreech_sound, 0, 20);
    
    audio_sound_pitch(car_tirescreech_sound, 0.5 + (clamp01((skidding * 0.1) + (max(abs(car_airspeed) / wheelbase_y, (rwd_burnout + fwd_burnout) * 4) * 0.25)) * 0.6));
    
    if (running)
    {
        if (electricengine)
            audio_sound_gain(car_engine_sound, (throttle * 0.5) + 0.2, 50);
        else
            audio_sound_gain(car_engine_sound, (throttle * 0.5) + 0.3, 50);
    }
    else
    {
        audio_sound_gain(car_engine_sound, 0, 20);
    }
    
    if (electricengine)
    {
        audio_sound_pitch(car_engine_sound, 0.6 + ((skidding * throttle * 0.1) + (throttle * 0.1) + ((rwd_burnout + fwd_burnout) * 0.1) + (abs(forwardspeed) * 0.005)));
    }
    else
    {
        var modulospeed = abs(forwardspeed);
        
        if (car_speed > 0)
            modulospeed = modulospeed % 100;
        
        var geareffect = modulospeed / 100;
        audio_sound_pitch(car_engine_sound, 0.6 + ((skidding * throttle * 0.1) + (throttle * 0.1) + (max(geareffect, (rwd_burnout + fwd_burnout) * 1.5) * 0.4) + (forwardspeed * 0.001)));
    }
    
    var loc_hwby_x = carlook_x * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwby_y = carlook_y * wheelbase_y * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_x = carside_x * wheelbase_x * 0.5 * krokosha_darkworldscale;
    var loc_hwbx_y = carside_y * wheelbase_x * 0.5 * krokosha_darkworldscale;
    
    for (var i = 0; i < array_length(last_wheelpos_arr); i++)
    {
        var cur_real_wpos_x = x;
        var cur_real_wpos_y = y;
        
        if (i <= 1)
        {
            if (i == 0)
            {
                cur_real_wpos_x = x + (loc_hwby_x - loc_hwbx_x);
                cur_real_wpos_y = y + (loc_hwby_y - loc_hwbx_y);
            }
            else
            {
                cur_real_wpos_x = x + (loc_hwby_x + loc_hwbx_x);
                cur_real_wpos_y = y + (loc_hwby_y + loc_hwbx_y);
            }
            
            cur_real_wpos_y += 1;
            
            if ((skidding - (rwd_burnout * abs(velocity_aligment))) > 0.4 && krokosha_car_is_moving())
                krokosha_car_manager.add_skid_line(last_wheelpos_arr[i][0], last_wheelpos_arr[i][1], cur_real_wpos_x, cur_real_wpos_y);
        }
        else
        {
            if (i == 2)
            {
                cur_real_wpos_x = x + (-loc_hwby_x - loc_hwbx_x);
                cur_real_wpos_y = y + (-loc_hwby_y - loc_hwbx_y);
            }
            else
            {
                cur_real_wpos_x = x + (-loc_hwby_x + loc_hwbx_x);
                cur_real_wpos_y = y + (-loc_hwby_y + loc_hwbx_y);
            }
            
            cur_real_wpos_y += 1;
            
            if ((skidding + rwd_burnout) > 0.4 && krokosha_car_is_moving())
                krokosha_car_manager.add_skid_line(last_wheelpos_arr[i][0], last_wheelpos_arr[i][1], cur_real_wpos_x, cur_real_wpos_y);
        }
        
        last_wheelpos_arr[i][0] = cur_real_wpos_x;
        last_wheelpos_arr[i][1] = cur_real_wpos_y;
    }
    
    global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][2] = x;
    global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][3] = y;
    global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][4] = carangle;
    global.krokosha_car_mod_all_cars_tracker_array[car_globalreferenceindex][6] = current_time;
}

function draw_rotated_rectangle(arg0, arg1, arg2, arg3, arg4, arg5 = 16777215, arg6 = false)
{
    var _hw = arg2 / 2;
    var _hh = arg3 / 2;
    var _x1 = -_hw;
    var _y1 = -_hh;
    var _x2 = _hw;
    var _y2 = -_hh;
    var _x3 = _hw;
    var _y3 = _hh;
    var _x4 = -_hw;
    var _y4 = _hh;
    var _cos = cos(arg4);
    var _sin = sin(arg4);
    var _rx1 = arg0 + ((_x1 * _cos) - (_y1 * _sin));
    var _ry1 = arg1 + ((_x1 * _sin) + (_y1 * _cos));
    var _rx2 = arg0 + ((_x2 * _cos) - (_y2 * _sin));
    var _ry2 = arg1 + ((_x2 * _sin) + (_y2 * _cos));
    var _rx3 = arg0 + ((_x3 * _cos) - (_y3 * _sin));
    var _ry3 = arg1 + ((_x3 * _sin) + (_y3 * _cos));
    var _rx4 = arg0 + ((_x4 * _cos) - (_y4 * _sin));
    var _ry4 = arg1 + ((_x4 * _sin) + (_y4 * _cos));
    draw_set_color(arg5);
    
    if (arg6)
    {
        draw_primitive_begin(pr_linestrip);
        draw_vertex(_rx1, _ry1);
        draw_vertex(_rx2, _ry2);
        draw_vertex(_rx3, _ry3);
        draw_vertex(_rx4, _ry4);
        draw_vertex(_rx1, _ry1);
        draw_primitive_end();
    }
    else
    {
        draw_primitive_begin(pr_trianglestrip);
        draw_vertex(_rx1, _ry1);
        draw_vertex(_rx2, _ry2);
        draw_vertex(_rx4, _ry4);
        draw_vertex(_rx3, _ry3);
        draw_primitive_end();
    }
}

function draw_car_3d(arg0)
{
    var vert_offset_fix = 8;
    shader_set(krokosha_car_shader);
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "car_pos"), car_low_res_surface_size * 0.5, (car_low_res_surface_size * 0.5) + vert_offset_fix);
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "car_velocity_diff"), degtorad(smooth_velocity_diff_x), degtorad(smooth_velocity_diff_y));
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "car_angle"), carangle);
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "outline_mode"), arg0);
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "render_fidelity"), renderfidelity);
    shader_set_uniform_f(shader_get_uniform(krokosha_car_shader, "pixel_aspect"), 1 / car_low_res_surface_size, 1 / car_low_res_surface_size);
    vertex_submit(vertex_buffer, pr_trianglelist, car_texture);
    
    if (renderwheels && arg0 != 1)
    {
        var wheelmodelfound = 0;
        var realwheelmodel = global.krokosha_car_wheel_model_vbuffer;
        
        if (variable_instance_exists(id, "wheel_vertex_format"))
        {
            wheelmodelfound = 1;
            realwheelmodel = wheel_vertex_buffer;
        }
        
        shader_set(krokosha_carwheel_shader);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_pos"), car_low_res_surface_size * 0.5, (car_low_res_surface_size * 0.5) + vert_offset_fix);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeldisk_color1"), wheelrimcolor1_r, wheelrimcolor1_g, wheelrimcolor1_b);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeldisk_color2"), wheelrimcolor2_r, wheelrimcolor2_g, wheelrimcolor2_b);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_angle"), carangle);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "outline_mode"), arg0);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "render_fidelity"), renderfidelity);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "is_custom_wheel"), wheelmodelfound);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheel_scale"), wheel_scale);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "pixel_aspect"), 1 / default_car_low_res_surface_size, 1 / default_car_low_res_surface_size);
        var thescaler = 0.5;
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeloffset"), wheelbase_x * thescaler, wheelbase_y * thescaler);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_steerangle"), last_realsteerangle);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheel_rollangle"), frontwheels_rollangle);
        vertex_submit(realwheelmodel, pr_trianglelist, car_texture);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeloffset"), -wheelbase_x * thescaler, wheelbase_y * thescaler);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_steerangle"), last_realsteerangle + pi);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheel_rollangle"), -frontwheels_rollangle);
        vertex_submit(realwheelmodel, pr_trianglelist, car_texture);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeloffset"), wheelbase_x * thescaler, -wheelbase_y * thescaler);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_steerangle"), 0);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheel_rollangle"), rearwheels_rollangle);
        vertex_submit(realwheelmodel, pr_trianglelist, car_texture);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheeloffset"), -wheelbase_x * thescaler, -wheelbase_y * thescaler);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "car_steerangle"), pi);
        shader_set_uniform_f(shader_get_uniform(krokosha_carwheel_shader, "wheel_rollangle"), -rearwheels_rollangle);
        vertex_submit(realwheelmodel, pr_trianglelist, car_texture);
    }
}

function draw_car()
{
    var width = display_get_width();
    var height = display_get_height();
    
    if (car_modelresourcefound)
    {
        if (!surface_exists(car_low_res_surface))
            krokosha_create_car_render_sufrace();
        
        if (surface_exists(car_low_res_surface))
        {
            var prev_ztest = gpu_get_ztestenable();
            var prev_zwrite = gpu_get_zwriteenable();
            var prev_gputexfilter = gpu_get_texfilter();
            surface_set_target(car_low_res_surface);
            draw_clear_alpha(c_black, 0);
            gpu_set_texfilter(false);
            gpu_set_ztestenable(false);
            gpu_set_zwriteenable(false);
            draw_car_3d(1);
            gpu_set_ztestenable(true);
            gpu_set_zwriteenable(true);
            draw_car_3d(0);
            gpu_set_ztestenable(prev_ztest);
            gpu_set_zwriteenable(prev_zwrite);
            shader_reset();
            surface_reset_target();
            draw_surface_stretched(car_low_res_surface, round(x - (default_car_low_res_surface_size * 0.5 * krokosha_darkworldscale)), round(y - (default_car_low_res_surface_size * 0.5 * krokosha_darkworldscale)), default_car_low_res_surface_size * krokosha_darkworldscale, default_car_low_res_surface_size * krokosha_darkworldscale);
            gpu_set_texfilter(prev_gputexfilter);
        }
    }
    else
    {
        draw_rotated_rectangle(x, y, wheelbase_x * 1.1, wheelbase_y * 1.2, carangle);
    }
    
    if (keyboard_check(ord("Y")))
    {
        draw_set_colour(c_yellow);
        draw_line(10, 10, x, y);
        draw_text(x, y - 40, "X " + string(x));
        draw_text(x, y - 20, "Y " + string(y));
        draw_text(x, y, string(car_speed));
        var smallertextscale = 0.58;
        draw_text_transformed(x, y + 20, string(car_side_speed), smallertextscale, smallertextscale, 0);
        draw_text_transformed(x, y + 30, string(skidding), smallertextscale, smallertextscale, 0);
        draw_text_transformed(x, y + 40, string(rwd_burnout + fwd_burnout), smallertextscale, smallertextscale, 0);
        draw_text_transformed(x, y + 50, "ANG: " + string(carangle), smallertextscale, smallertextscale, 0);
        draw_text_transformed(x, y + 60, "DPTH: " + string(depth), smallertextscale, smallertextscale, 0);
        var carlook = angle_to_dir(carangle);
        var carlook_x = carlook[0];
        var carlook_y = carlook[1];
        var carside_x = -carlook_y;
        var carside_y = carlook_x;
        draw_line(x, y, x + (krokosha_darkworldscale * (carlook_x * wheelbase_y * 0.5)), y + (krokosha_darkworldscale * (carlook_y * wheelbase_y * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (((carlook_x * wheelbase_y) - (carside_x * wheelbase_x)) * 0.5)), y + (krokosha_darkworldscale * (((carlook_y * wheelbase_y) - (carside_y * wheelbase_x)) * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (((carlook_x * wheelbase_y) + (carside_x * wheelbase_x)) * 0.5)), y + (krokosha_darkworldscale * (((carlook_y * wheelbase_y) + (carside_y * wheelbase_x)) * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (-carside_x * wheelbase_x * 0.5)), y + (krokosha_darkworldscale * (-carside_y * wheelbase_x * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (carside_x * wheelbase_x * 0.5)), y + (krokosha_darkworldscale * (carside_y * wheelbase_x * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (((-carlook_x * wheelbase_y) - (carside_x * wheelbase_x)) * 0.5)), y + (krokosha_darkworldscale * (((-carlook_y * wheelbase_y) - (carside_y * wheelbase_x)) * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (((-carlook_x * wheelbase_y) + (carside_x * wheelbase_x)) * 0.5)), y + (krokosha_darkworldscale * (((-carlook_y * wheelbase_y) + (carside_y * wheelbase_x)) * 0.5)));
        draw_line(x, y, x + (krokosha_darkworldscale * (-carlook_x * wheelbase_y * 0.5)), y + (krokosha_darkworldscale * (-carlook_y * wheelbase_y * 0.5)));
        draw_set_colour(c_red);
        
        for (var i = 0; i < array_length(krokosha_dev_temp_col_visual); i++)
        {
            var goalpos = krokosha_dev_temp_col_visual[i];
            draw_line(goalpos[0], goalpos[1], x, y);
        }
        
        draw_set_colour(c_yellow);
    }
}

function parse_wavefront(arg0)
{
    var vertices = [];
    var uvs = [];
    var faces = [];
    var lines = string_split(arg0, "\n");
    
    for (var i = 0; i < array_length(lines); i++)
    {
        var line = string_trim(lines[i]);
        
        if (line == "" || string_char_at(line, 1) == "#")
            continue;
        
        var parts = string_split(line, " ");
        var type = parts[0];
        
        if (type == "v")
        {
            var vx = real(parts[1]);
            var vy = real(parts[2]);
            var vz = real(parts[3]);
            array_push(vertices, [vx, vy, vz]);
        }
        else if (type == "vt")
        {
            var u = real(parts[1]);
            var v = 1 - real(parts[2]);
            array_push(uvs, [u, v]);
        }
        else if (type == "f")
        {
            var face = [];
            
            for (var j = 1; j <= 3; j++)
            {
                var indices = string_split(parts[j], "/");
                array_push(face, real(indices[0]));
                array_push(face, real(indices[1]));
            }
            
            array_push(faces, face);
        }
    }
    
    return [vertices, uvs, faces];
}

function load_wavefront_into_vbuffer(arg0, arg1, arg2 = 1, arg3 = false)
{
    var vertices = arg0[0];
    var uvs = arg0[1];
    var faces = arg0[2];
    
    for (var i = 0; i < array_length(faces); i++)
    {
        var face = faces[i];
        
        for (var j = 0; j < 3; j++)
        {
            var v_i = face[j * 2];
            var uv_i = face[(j * 2) + 1];
            var pos = vertices[v_i - 1];
            var uv = uvs[uv_i - 1];
            vertex_position_3d(arg1, pos[0] * arg2, pos[1] * arg2, pos[2] * arg2);
            vertex_color(arg1, c_white, 1);
            vertex_texcoord(arg1, uv[0], uv[1]);
        }
    }
}

function check_if_wheel_model_loaded()
{
    if (!variable_global_exists("krokosha_car_wheel_model_vbuffer"))
    {
        vertex_format_begin();
        vertex_format_add_position_3d();
        vertex_format_add_color();
        vertex_format_add_texcoord();
        global.krokosha_car_wheel_model_vformat = vertex_format_end();
        global.krokosha_car_wheel_model_vbuffer = vertex_create_buffer();
        vertex_begin(global.krokosha_car_wheel_model_vbuffer, global.krokosha_car_wheel_model_vformat);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 1);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.890411, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.746575, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.636986, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.363014, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0.005);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0.005);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 1);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 1);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0.005);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.253425, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.109589, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, -2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 0.005);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, -8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 1, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 8, 0);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.5, 1);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.82829);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 0, 8);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0, 0.5);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, 5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.17171, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, -5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.17171);
        vertex_position_3d(global.krokosha_car_wheel_model_vbuffer, 2.6666666667, 5.6568533333, -5.6568533333);
        vertex_color(global.krokosha_car_wheel_model_vbuffer, c_white, 1);
        vertex_texcoord(global.krokosha_car_wheel_model_vbuffer, 0.82829, 0.82829);
        vertex_end(global.krokosha_car_wheel_model_vbuffer);
    }
}

function hex_to_rgb(arg0)
{
    var _hex = string_replace(string_trim(arg0), "#", "");
    
    if (string_length(_hex) == 3)
        _hex = string_char_at(_hex, 1) + string_char_at(_hex, 1) + string_char_at(_hex, 2) + string_char_at(_hex, 2) + string_char_at(_hex, 3) + string_char_at(_hex, 3);
    
    var _r = string_copy(_hex, 1, 2);
    var _g = string_copy(_hex, 3, 2);
    var _b = string_copy(_hex, 5, 2);
    return [real("0x" + _r) / 255, real("0x" + _g) / 255, real("0x" + _b) / 255];
}

_config_current_value = false;

function _config_read_line_value(arg0, arg1)
{
    if (string_pos(arg0, arg1) > 0)
    {
        var eqpos = string_pos("=", arg1);
        _config_current_value = string_copy(arg1, eqpos + 1, string_length(arg1) - eqpos);
        return true;
    }
    
    return false;
}

CONST_config_reals = [["reversemaxspeed", "reversemaxspeed"], ["maxspeed", "maxspeed"], ["acceleration", "acceleration"], ["wheelbase_x", "wheelbase_x"], ["wheelbase_y", "wheelbase_y"], ["brakestrength", "brakestrength"], ["maxleanangle", "max_lean_angle_deg"], ["wheelscale", "wheel_scale"], ["leanmultiplier", "leanmultiplier"], ["steerspeed", "steerspeed"], ["tiretraction", "tiretraction"], ["vehiclemass", "vehicle_mass"], ["renderfidelity", "renderfidelity"]];

function read_car_config(arg0)
{
    var file = file_text_open_read(arg0 + "/carconfig.txt");
    
    if (file != -1)
    {
        while (!file_text_eof(file))
        {
            var line = file_text_read_string(file);
            
            if (string_pos("//", line) > 0)
                line = string_copy(line, 1, string_pos("//", line) - 1);
            
            line = string_trim(line);
            file_text_readln(file);
            var found_a_real_val = false;
            
            for (var i = 0; i < array_length(CONST_config_reals); i++)
            {
                var translate = CONST_config_reals[i];
                
                if (_config_read_line_value(translate[0], line))
                {
                    variable_instance_set(id, translate[1], real(_config_current_value));
                    found_a_real_val = true;
                    break;
                }
            }
            
            if (!found_a_real_val)
            {
                if (_config_read_line_value("layout", line))
                {
                    var layout = real(_config_current_value);
                    is_awd = false;
                    is_fwd = false;
                    is_rwd = false;
                    
                    if (layout == 1)
                        is_fwd = true;
                    else if (layout == 2)
                        is_rwd = true;
                    else if (layout == 3)
                        is_awd = true;
                }
                else if (_config_read_line_value("renderwheels", line))
                {
                    renderwheels = string_pos("true", _config_current_value) > 0;
                }
                else if (_config_read_line_value("electricengine", line))
                {
                    electricengine = string_pos("true", _config_current_value) > 0;
                }
                else if (_config_read_line_value("wheelrimcolor1", line))
                {
                    var color = hex_to_rgb(_config_current_value);
                    wheelrimcolor1_r = color[0];
                    wheelrimcolor1_g = color[1];
                    wheelrimcolor1_b = color[2];
                }
                else if (_config_read_line_value("wheelrimcolor2", line))
                {
                    var color = hex_to_rgb(_config_current_value);
                    wheelrimcolor2_r = color[0];
                    wheelrimcolor2_g = color[1];
                    wheelrimcolor2_b = color[2];
                }
            }
        }
        
        file_text_close(file);
    }
    else
    {
        show_debug_message("carconfig.txt NOT FOUND: " + car_name);
    }
}

function read_file_to_string(arg0)
{
    var file = file_text_open_read(arg0);
    var content = "";
    
    while (!file_text_eof(file))
    {
        content += file_text_read_string(file);
        file_text_readln(file);
        
        if (!file_text_eof(file))
            content += "\n";
    }
    
    file_text_close(file);
    return content;
}

function krokosha_create_car_render_sufrace()
{
    car_low_res_surface_size = clamp(floor((default_car_low_res_surface_size * renderfidelity) / 2) * 2, 64, 1024);
    car_low_res_surface = surface_create(car_low_res_surface_size, car_low_res_surface_size);
}

function load_car_model(arg0)
{
    var enginesoundpath = arg0 + "/" + car_name + ".ogg";
    
    if (file_exists(enginesoundpath))
    {
        audio_stop_sound(car_engine_sound);
        car_engine_sound_stream = audio_create_stream(enginesoundpath);
        car_engine_sound = audio_play_sound(car_engine_sound_stream, 5, true, 0);
        has_custom_engine_sound = true;
    }
    
    var texturepngpath = arg0 + "/" + car_name + ".png";
    var modelobjpath = arg0 + "/" + car_name + ".obj";
    var customwheelobjpath = arg0 + "/" + "wheel.obj";
    
    if (file_exists(texturepngpath))
    {
        if (file_exists(modelobjpath))
        {
            krokosha_create_car_render_sufrace();
            check_if_wheel_model_loaded();
            car_texture_as_sprite = sprite_add(texturepngpath, 0, false, false, 0, 0);
            car_texture = sprite_get_texture(car_texture_as_sprite, 0);
            var parsed_car = parse_wavefront(read_file_to_string(modelobjpath));
            vertex_format_begin();
            vertex_format_add_position_3d();
            vertex_format_add_color();
            vertex_format_add_texcoord();
            vertex_format = vertex_format_end();
            vertex_buffer = vertex_create_buffer();
            vertex_begin(vertex_buffer, vertex_format);
            load_wavefront_into_vbuffer(parsed_car, vertex_buffer);
            vertex_end(vertex_buffer);
            car_modelresourcefound = true;
        }
        
        if (file_exists(customwheelobjpath))
        {
            var parsed_wheel = parse_wavefront(read_file_to_string(customwheelobjpath));
            vertex_format_begin();
            vertex_format_add_position_3d();
            vertex_format_add_color();
            vertex_format_add_texcoord();
            wheel_vertex_format = vertex_format_end();
            wheel_vertex_buffer = vertex_create_buffer();
            vertex_begin(wheel_vertex_buffer, wheel_vertex_format);
            load_wavefront_into_vbuffer(parsed_wheel, wheel_vertex_buffer);
            vertex_end(wheel_vertex_buffer);
        }
    }
    
    if (car_modelresourcefound)
    {
    }
    else if (car_name != "empty")
    {
        show_message("KROKOSHA CAR MODEL RESOURCE FAILED OR NOT FOUND: " + car_name);
    }
}

function load_car()
{
    if (car_globalreferenceindex == -1)
    {
        car_globalreferenceindex = array_length(global.krokosha_car_mod_all_cars_tracker_array);
        array_push(global.krokosha_car_mod_all_cars_tracker_array, [car_globalreferenceindex, car_name, x, y, carangle, car_spawnreason, current_time, room]);
    }
    else
    {
    }
    
    check_if_car_manager_exists();
    car_tirescreech_sound = audio_play_sound(593, 5, true, 0);
    car_engine_sound = audio_play_sound(592, 5, true, 0);
    var carmod_assetsdirname = program_directory + "KROKOSHA_CARMOD_FILES/" + "krokosha_dr_car_models/";
    
    if (!directory_exists(carmod_assetsdirname))
        exit;
    
    var find = file_find_first(carmod_assetsdirname + "*", 16);
    
    while (find != "")
    {
        var full_path = carmod_assetsdirname + find;
        
        if (file_attributes(full_path, 16))
        {
            if (find == car_name)
            {
                read_car_config(full_path);
                load_car_model(full_path);
                break;
            }
        }
        
        find = file_find_next();
    }
    
    file_find_close();
}

function krokosha_check_if_game_is_in_cutscene()
{
    var is_in_cutscene = obj_mainchara.cutscene;
    
    if (!is_in_cutscene)
    {
        if (asset_get_index("obj_cutscene_master"))
        {
            if (instance_exists(obj_cutscene_master))
            {
                for (var i = 0; i < array_length(obj_cutscene_master.actor_name); i++)
                {
                    var actor = obj_cutscene_master.actor_name[i];
                    
                    if (actor == "kris")
                    {
                        is_in_cutscene = true;
                        break;
                    }
                }
            }
        }
    }
    
    return is_in_cutscene;
}

function car_player_dismount(arg0 = undefined, arg1 = undefined)
{
    if (is_player_in_the_car)
    {
        krokosha_car_manager.krokosha_player_is_in_car = false;
        entering_car_smooth = false;
        set_engine_running(false);
        is_player_in_the_car = false;
        is_player_the_driver = false;
        persistent = false;
        
        if (is_undefined(arg0))
            arg0 = check_if_car_manager_exists().krokosha_current_room_matches([["room_dark_chase1"], ["room_dw_cyber_rhythm_slide"]]);
        
        if (global.flag[31] > 5)
            global.flag[31] -= 10;
        
        if (instance_exists(obj_mainchara) && (!krokosha_check_if_game_is_in_cutscene() || arg0))
        {
            if (!krokosha_car_manager.krokosha_dev_test_no_interact)
                global.interact = 0;
            
            obj_mainchara.visible = 1;
            
            if (is_undefined(arg1))
                arg1 = check_if_car_manager_exists().krokosha_current_room_matches([["room_dark7", "room_dark_chase1", "room_forest_chase1", "room_forest_chase2", "room_forest_castlefront"], ["room_dw_cyber_rhythm_slide"], [], ["room_dw_churchc_darkswords"]]);
            
            if (!arg1)
            {
                for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
                {
                    var partymember = instance_find(obj_caterpillarchara, i);
                    partymember.visible = 1;
                }
            }
            
            if (asset_get_index("obj_noelle_city_traffic_2"))
            {
                if (instance_exists(obj_noelle_city_traffic_2))
                {
                    obj_noelle_city_traffic_2.visible = obj_noelle_city_traffic_2.stickToKris;
                    
                    if (obj_noelle_city_traffic_2.mycater != 0)
                    {
                        if (!obj_noelle_city_traffic_2.stickToKris)
                        {
                            with (obj_caterpillarchara)
                            {
                                if (name == "noelle")
                                    visible = true;
                            }
                        }
                    }
                }
            }
        }
        
        is_leaving_car = false;
        return true;
    }
    
    return false;
}

function car_player_dismount_smooth()
{
    if (car_player_dismount() && instance_exists(obj_mainchara))
    {
        if (!krokosha_car_manager.krokosha_dev_test_no_interact)
            global.interact = 1;
        
        set_engine_running(false);
        is_leaving_car = true;
        car_player_door_sound_for_partymembers();
        var GETOUTtime = 0.3;
        var new_x = x + (velocity_x * GETOUTtime);
        var new_y = y + (velocity_y * GETOUTtime);
        var carlook = angle_to_dir(carangle);
        var carlook_x = carlook[0];
        var carlook_y = carlook[1];
        var carside_x = -carlook_y;
        var carside_y = carlook_x;
        var cur_forwardspeed = dot_product(carlook_x, carlook_y, velocity_x, velocity_y);
        var loc_hwby_x = carlook_x * wheelbase_y * 0.75 * krokosha_darkworldscale;
        var loc_hwby_y = carlook_y * wheelbase_y * 0.75 * krokosha_darkworldscale;
        var loc_hwbx_x = carside_x * wheelbase_x * 0.75 * krokosha_darkworldscale;
        var loc_hwbx_y = carside_y * wheelbase_x * 0.75 * krokosha_darkworldscale;
        var hit_front = collision_line(x, y, new_x + loc_hwby_x, new_y + loc_hwby_y, obj_solidblock, true, true);
        
        if (!hit_front)
            hit_front = [new_x + loc_hwby_x, new_y + loc_hwby_y];
        else
            hit_front = false;
        
        var hit_fl = collision_line(x, y, new_x + ((loc_hwby_x * 0.5) - loc_hwbx_x), new_y + ((loc_hwby_y * 0.5) - loc_hwbx_y), obj_solidblock, true, true);
        
        if (!hit_fl)
            hit_fl = [new_x + ((loc_hwby_x * 0.5) - loc_hwbx_x), new_y + ((loc_hwby_y * 0.5) - loc_hwbx_y)];
        else
            hit_fl = false;
        
        var hit_fr = collision_line(x, y, new_x + ((loc_hwby_x * 0.5) + loc_hwbx_x), new_y + ((loc_hwby_y * 0.5) + loc_hwbx_y), obj_solidblock, true, true);
        
        if (!hit_fr)
            hit_fr = [new_x + ((loc_hwby_x * 0.5) + loc_hwbx_x), new_y + ((loc_hwby_y * 0.5) + loc_hwbx_y)];
        else
            hit_fr = false;
        
        var hit_left = collision_line(x, y, new_x + -loc_hwbx_x, new_y + -loc_hwbx_y, obj_solidblock, true, true);
        
        if (!hit_left)
            hit_left = [new_x + -loc_hwbx_x, new_y + -loc_hwbx_y];
        else
            hit_left = false;
        
        var hit_right = collision_line(x, y, new_x + loc_hwbx_x, new_y + loc_hwbx_y, obj_solidblock, true, true);
        
        if (!hit_right)
            hit_right = [new_x + loc_hwbx_x, new_y + loc_hwbx_y];
        else
            hit_right = false;
        
        var hit_rear = collision_line(x, y, new_x + -loc_hwby_x, new_y + -loc_hwby_y, obj_solidblock, true, true);
        
        if (!hit_rear)
            hit_rear = [new_x + -loc_hwby_x, new_y + -loc_hwby_y];
        else
            hit_rear = false;
        
        var hit_rl = collision_line(x, y, new_x + ((-loc_hwby_x * 0.5) - loc_hwbx_x), new_y + ((-loc_hwby_y * 0.5) - loc_hwbx_y), obj_solidblock, true, true);
        
        if (!hit_rl)
            hit_rl = [new_x + ((-loc_hwby_x * 0.5) - loc_hwbx_x), new_y + ((-loc_hwby_y * 0.5) - loc_hwbx_y)];
        else
            hit_rl = false;
        
        var hit_rr = collision_line(x, y, new_x + ((-loc_hwby_x * 0.5) + loc_hwbx_x), new_y + ((-loc_hwby_y * 0.5) + loc_hwbx_y), obj_solidblock, true, true);
        
        if (!hit_rr)
            hit_rr = [new_x + ((-loc_hwby_x * 0.5) + loc_hwbx_x), new_y + ((-loc_hwby_y * 0.5) + loc_hwbx_y)];
        else
            hit_rr = false;
        
        if (abs(cur_forwardspeed) > 110)
        {
            audio_play_sound(snd_fall, 1, false);
            krokosha_car_manager.krokosha_player_is_exiting_tumbling = true;
        }
        
        krokosha_car_manager.krokosha_player_is_exiting = true;
        krokosha_car_manager.krokosha_player_exiting_starttime = current_time;
        var thing = [hit_fl, hit_fr, hit_left, hit_right, hit_rl, hit_rr, hit_rear, hit_front];
        var my_characters = [1049];
        
        for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
        {
            var partymember = instance_find(obj_caterpillarchara, i);
            array_push(my_characters, partymember);
        }
        
        var char_index = 0;
        global.krokosha_exit_positions_of_car_idk_bruh = [];
        
        for (var i = 0; i < array_length(thing); i++)
        {
            var raycheck = thing[i];
            
            if (raycheck != false)
            {
                if (char_index == 0)
                {
                    var inst = collision_rectangle(raycheck[0] - (krokosha_kris_center_offset_x * krokosha_darkworldscale), raycheck[1] - (krokosha_kris_center_offset_y * krokosha_darkworldscale), raycheck[0] + (krokosha_kris_center_offset_x * krokosha_darkworldscale), raycheck[1] + (krokosha_kris_center_offset_y * krokosha_darkworldscale), obj_solidblock, true, true);
                    
                    if (inst != -4)
                        continue;
                }
                
                array_push(global.krokosha_exit_positions_of_car_idk_bruh, raycheck);
                char_index += 1;
                
                if (char_index >= array_length(my_characters))
                    break;
            }
        }
        
        for (var i = char_index; i < array_length(my_characters); i++)
            array_push(global.krokosha_exit_positions_of_car_idk_bruh, [new_x, new_y]);
        
        entering_car_smooth_timestart = current_time;
    }
}

function krokosha_create_explosion(arg0, arg1, arg2 = true)
{
    var explosion = instance_create(arg0, arg1, obj_animation);
    
    if (arg2)
        snd_play(snd_badexplosion);
    
    explosion.sprite_index = spr_realisticexplosion;
}

function car_explode()
{
    car_player_dismount();
    krokosha_create_explosion(x, y);
    check_if_car_manager_exists();
    krokosha_car_manager.krokosha_remove_car_from_global_tracker(self);
    instance_destroy();
}

function set_engine_running(arg0 = true)
{
    running = arg0;
}

function car_player_enter_now(arg0 = true)
{
    is_player_in_the_car = true;
    is_player_the_driver = arg0;
    persistent = true;
    krokosha_car_manager.krokosha_player_is_in_car = true;
    krokosha_car_manager.krokosha_player_current_car = self;
    set_engine_running(true);
    
    if (!krokosha_car_manager.krokosha_dev_test_no_interact)
        global.interact = 1;
    else if (entering_car_smooth)
        global.interact = 0;
    
    if (global.flag[31] < 5)
        global.flag[31] += 10;
    
    if (instance_exists(obj_mainchara))
    {
        obj_mainchara.x = round(x);
        obj_mainchara.y = round(y);
        obj_mainchara.visible = 0;
    }
    
    for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
    {
        var partymember = instance_find(obj_caterpillarchara, i);
        partymember.x = round(x);
        partymember.y = round(y);
        partymember.visible = 0;
        global.krokosha_carmod_susieknows = true;
    }
}

function car_player_door_sound_for_partymembers()
{
    audio_play_sound(591, 1, false, 1.1, 0, random_range(1, 1.2));
    
    for (var i = 0; i < instance_number(obj_caterpillarchara); i++)
    {
        var partymember = instance_find(obj_caterpillarchara, i);
        audio_play_sound(591, 1, false, 1, random(0.1), random_range(0.9, 1.1));
    }
}

function car_player_enter_smooth()
{
    global.interact = 1;
    car_player_door_sound_for_partymembers();
    is_leaving_car = false;
    entering_car_smooth_timestart = current_time;
    entering_car_smooth = true;
}

load_car();
rotation_inertia = vehicle_mass * vec2_length_sq(wheelbase_x, wheelbase_y);
