buffer += 1;
if (global.interact == 5)
{
    xx = __view_get(e__VW.XView, view_current);
    yy = __view_get(e__VW.YView, view_current) + 10;
    moveyy = yy;
    var stat_right = 263;
    if (global.lang == "ja")
    {
        stat_right = 300;
    }
    if (obj_mainchara.y > (yy + 120))
    {
        moveyy += 135;
    }
    if (global.menuno != 4)
    {
        draw_set_color(c_white);
        draw_rectangle(16 + xx, 16 + moveyy, 86 + xx, 70 + moveyy, false);
        draw_rectangle(16 + xx, 74 + yy, 86 + xx, 147 + yy, false);
        if (global.menuno == 1 || global.menuno == 5 || global.menuno == 6)
        {
            draw_rectangle(94 + xx, 16 + yy, 266 + xx, 196 + yy, false);
        }
        if (global.menuno == 2)
        {
            draw_rectangle(94 + xx, 16 + yy, stat_right + 3 + xx, 224 + yy, false);
        }
        if (global.menuno == 3)
        {
            draw_rectangle(94 + xx, 16 + yy, 266 + xx, 150 + yy, false);
        }
        if (global.menuno == 7)
        {
            draw_rectangle(94 + xx, 16 + yy, 266 + xx, 216 + yy, false);
        }
        draw_set_color(c_black);
        draw_rectangle(19 + xx, 19 + moveyy, 83 + xx, 67 + moveyy, false);
        draw_rectangle(19 + xx, 77 + yy, 83 + xx, 144 + yy, false);
        if (global.menuno == 1 || global.menuno == 5 || global.menuno == 6)
        {
            draw_rectangle(97 + xx, 19 + yy, 263 + xx, 193 + yy, false);
        }
        if (global.menuno == 2)
        {
            draw_rectangle(97 + xx, 19 + yy, stat_right + xx, 221 + yy, false);
        }
        if (global.menuno == 3)
        {
            draw_rectangle(97 + xx, 19 + yy, 263 + xx, 147 + yy, false);
        }
        if (global.menuno == 7)
        {
            draw_rectangle(97 + xx, 19 + yy, 263 + xx, 213 + yy, false);
        }
        draw_set_color(c_white);
        draw_set_font(fnt_small);
        draw_text(23 + xx, 49 + moveyy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_36_0") + string(global.lhp) + "/" + string(global.lmaxhp)));
        draw_text(23 + xx, 40 + moveyy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_37_0") + string(global.llv)));
        draw_text(23 + xx, 58 + moveyy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_39_0") + string(global.lgold)));
        scr_84_set_draw_font("main");
        var _itemTextColor = hasitems ? c_white : c_gray;
        if (global.lang == "ja")
        {
            draw_text(20 + xx, 20 + moveyy, string_hash_to_newline(global.lcharname));
            draw_set_color(_itemTextColor);
            draw_text(40 + xx, 84 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_42_0")));
        }
        else
        {
            draw_text(23 + xx, 20 + moveyy, string_hash_to_newline(global.lcharname));
            draw_set_color(_itemTextColor);
            draw_text(42 + xx, 84 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_42_0")));
        }
        draw_set_color(c_white);
        draw_text(42 + xx, 102 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_43_0")));
        draw_text(42 + xx, 120 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_44_0")));
        if (global.menuno == 1 || global.menuno == 5)
        {
            for (i = 0; i < 8; i += 1)
            {
                draw_text(116 + xx, 30 + yy + (i * 16), string_hash_to_newline(global.litemname[i]));
            }
            draw_text(116 + xx, 170 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_52_0")));
            draw_text(116 + xx + 48, 170 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_53_0")));
            draw_text(116 + xx + 105, 170 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_54_0")));
        }
    }
    if (global.menuno == 3)
    {
        for (i = 0; i < 7; i += 1)
        {
            draw_text(116 + xx, 30 + yy + (i * 16), string_hash_to_newline(global.phonename[i]));
        }
    }
    if (global.menuno == 2)
    {
        draw_text(108 + xx, 32 + yy, string_hash_to_newline(scr_84_get_subst_string(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_66_0"), global.lcharname)));
        draw_text(108 + xx, 62 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_67_0") + string(global.llv)));
        draw_text(108 + xx, 78 + yy, string_hash_to_newline(scr_84_get_subst_string(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_68_0"), string(global.lhp)) + string(global.lmaxhp)));
        draw_text(108 + xx, 110 + yy, string_hash_to_newline(scr_84_get_subst_string(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_70_0"), string(global.lat)) + string(global.lwstrength) + ")"));
        draw_text(108 + xx, 126 + yy, string_hash_to_newline(scr_84_get_subst_string(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_71_0"), string(global.ldf)) + string(global.ladef) + ")"));
        weaponname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_72_0");
        armorname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_73_0");
        if (global.lweapon == 2)
        {
            weaponname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_74_0");
        }
        if (global.lweapon == 6)
        {
            weaponname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_75_0");
        }
        if (global.lweapon == 7)
        {
            weaponname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_76_0");
        }
        if (global.larmor == 3)
        {
            armorname = scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_77_0");
        }
        draw_text(108 + xx, 156 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_80_0") + weaponname));
        draw_text(108 + xx, 172 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_81_0") + armorname));
        draw_text(108 + xx, 192 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_82_0") + string(global.lgold)));
        if (string_length(global.lcharname) >= 7)
        {
            draw_text(192 + xx, 32 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_88_0")));
        }
        nextlevel = 0;
        draw_text(192 + xx, 110 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_91_0") + string(global.lxp)));
        if (global.llv == 1)
        {
            nextlevel = 10 - global.lxp;
        }
        if (global.llv == 2)
        {
            nextlevel = 30 - global.lxp;
        }
        if (global.llv == 3)
        {
            nextlevel = 70 - global.lxp;
        }
        if (global.llv == 4)
        {
            nextlevel = 120 - global.lxp;
        }
        if (global.llv == 5)
        {
            nextlevel = 200 - global.lxp;
        }
        if (global.llv == 6)
        {
            nextlevel = 300 - global.lxp;
        }
        if (global.llv == 7)
        {
            nextlevel = 500 - global.lxp;
        }
        if (global.llv == 8)
        {
            nextlevel = 800 - global.lxp;
        }
        if (global.llv == 9)
        {
            nextlevel = 1200 - global.lxp;
        }
        if (global.llv == 10)
        {
            nextlevel = 1700 - global.lxp;
        }
        if (global.llv == 11)
        {
            nextlevel = 2500 - global.lxp;
        }
        if (global.llv == 12)
        {
            nextlevel = 3500 - global.lxp;
        }
        if (global.llv == 13)
        {
            nextlevel = 5000 - global.lxp;
        }
        if (global.llv == 14)
        {
            nextlevel = 7000 - global.lxp;
        }
        if (global.llv == 15)
        {
            nextlevel = 10000 - global.lxp;
        }
        if (global.llv == 16)
        {
            nextlevel = 15000 - global.lxp;
        }
        if (global.llv == 17)
        {
            nextlevel = 25000 - global.lxp;
        }
        if (global.llv == 18)
        {
            nextlevel = 50000 - global.lxp;
        }
        if (global.llv == 19)
        {
            nextlevel = 99999 - global.lxp;
        }
        if (global.llv >= 20)
        {
            nextlevel = 0;
        }
        draw_text(192 + xx, 126 + yy, string_hash_to_newline(scr_84_get_lang_string("obj_overworldc_slash_Draw_0_gml_112_0") + string(nextlevel)));
    }
    if (global.menuno == 444)
    {
    }
    if (global.menuno == 0)
    {
        draw_sprite(spr_heartsmall, 0, 28 + xx, 88 + yy + (18 * global.menucoord[0]));
    }
    if (global.menuno == 1)
    {
        draw_sprite(spr_heartsmall, 0, 104 + xx, 34 + yy + (16 * global.menucoord[1]));
    }
    if (global.menuno == 3)
    {
        draw_sprite(spr_heartsmall, 0, 104 + xx, 34 + yy + (16 * global.menucoord[3]));
    }
    if (global.menuno == 6)
    {
        draw_sprite(spr_heartsmall, 0, 104 + xx, 34 + yy + (16 * global.menucoord[6]));
    }
    if (global.menuno == 7)
    {
        draw_sprite(spr_heartsmall, 0, 104 + xx, 34 + yy + (16 * global.menucoord[7]));
    }
    if (global.menuno == 5)
    {
        if (global.menucoord[5] == 0)
        {
            draw_sprite(spr_heartsmall, 0, 104 + xx + (45 * global.menucoord[5]), 174 + yy);
        }
        if (global.menucoord[5] == 1)
        {
            draw_sprite(spr_heartsmall, 0, 104 + xx + ((45 * global.menucoord[5]) + 3), 174 + yy);
        }
        if (global.menucoord[5] == 2)
        {
            draw_sprite(spr_heartsmall, 0, 104 + xx + ((45 * global.menucoord[5]) + 15), 174 + yy);
        }
    }
}

enum e__VW
{
    XView,
    YView,
    WView,
    HView,
    Angle,
    HBorder,
    VBorder,
    HSpeed,
    VSpeed,
    Object,
    Visible,
    XPort,
    YPort,
    WPort,
    HPort,
    Camera,
    SurfaceID
}

//patch for the spawner menu


var dwscale = 1;

if (variable_global_exists("darkzone"))
{
    if (global.darkzone) {
        dwscale = 2;
    } else {
        
        try
        {
            xx = __view_get(e__VW.XView, view_current);
            yy = __view_get(e__VW.YView, view_current);
        }
        catch (_)
        {
        }
        
    }
}

var carmod_assetsdirname = program_directory + "KROKOSHA_CARMOD_FILES/" + "krokosha_dr_car_models/";

if (!variable_global_exists("krokosha_car_spawnmenu_tdown"))
{
    global.krokosha_car_partymember_comments = true;
    global.krokosha_car_spawnmenu_tdown = false;
    global.krokosha_car_spawnmenu_bdown = false;
    global.krokosha_car_spawnmenu_active = false;
    global.krokosha_car_spawnmenu_selection = 0;
}

if (keyboard_check(ord("K")) && keyboard_check(ord("R")))
{
    if (!global.krokosha_car_spawnmenu_tdown)
    {
        global.krokosha_car_spawnmenu_active = !global.krokosha_car_spawnmenu_active;
        
        if (global.krokosha_car_spawnmenu_active)
        {
            if (!directory_exists(carmod_assetsdirname))
            {
                audio_play_sound(snd_error, 1, false, 1);
            }
            else
            {
                audio_play_sound(snd_select, 1, false, 1);
                global.krokosha_car_spawnmenu_available_cars = [];
                var find = file_find_first(carmod_assetsdirname + "*", 16);
                
                while (find != "")
                {
                    var full_path = carmod_assetsdirname + find;
                    
                    if (file_attributes(full_path, 16))
                        array_push(global.krokosha_car_spawnmenu_available_cars, find);
                    
                    find = file_find_next();
                }
                
                file_find_close();
                array_push(global.krokosha_car_spawnmenu_available_cars, "DESPAWN ALL");
                if (global.krokosha_car_partymember_comments) {
                    array_push(global.krokosha_car_spawnmenu_available_cars, "DISABLE CRASH COMMENTS");
                } else {
                    array_push(global.krokosha_car_spawnmenu_available_cars, "ENABLE CRASH COMMENTS");
                }
                if (global.krokosha_car_spawnmenu_selection > (array_length(global.krokosha_car_spawnmenu_available_cars) - 1))
                    global.krokosha_car_spawnmenu_selection = 0;
            }
        }
    }
    
    global.krokosha_car_spawnmenu_tdown = true;
}
else
{
    global.krokosha_car_spawnmenu_tdown = false;
}

if (global.krokosha_car_spawnmenu_active && instance_exists(obj_mainchara))
{
    if (!variable_global_exists("krokosha_car_spawnmenu_available_cars"))
    {
        draw_set_colour(c_yellow);
        draw_text(10 + xx, 10 + yy, "KROKOSHA CAR MOD:");
        draw_set_colour(c_red);
        draw_text(10 + xx, 30 + yy, "ERROR: CAN'T LOAD CAR ASSETS");
        draw_set_colour(c_yellow);
        draw_text_transformed(10 + xx, 50 + yy, "HINT: MAKE SURE ASSETS ARE LOCATED IN:", dwscale * 0.5, dwscale * 0.5, 0);
        draw_set_colour(c_red);
        //draw_text_transformed(10 + xx, 50 + 10*dwscale + yy, game_save_id + "krokosha_dr_car_models/", dwscale * 0.4, dwscale * 0.4, 0);
        draw_text_transformed(10 + xx, 50 + 10*dwscale + yy, carmod_assetsdirname, dwscale * 0.4, dwscale * 0.4, 0);
    }
    else
    {
        var anything_down = false;
        
        if (keyboard_check(vk_up))
        {
            if (!global.krokosha_car_spawnmenu_bdown)
            {
                audio_play_sound(snd_menumove, 1, false, 1);
                global.krokosha_car_spawnmenu_selection -= 1;
                
                if (global.krokosha_car_spawnmenu_selection < 0)
                    global.krokosha_car_spawnmenu_selection = array_length(global.krokosha_car_spawnmenu_available_cars) - 1;
            }
            
            anything_down = true;
        }
        
        if (keyboard_check(vk_down))
        {
            if (!global.krokosha_car_spawnmenu_bdown)
            {
                audio_play_sound(snd_menumove, 1, false, 1);
                global.krokosha_car_spawnmenu_selection += 1;
                
                if (global.krokosha_car_spawnmenu_selection > (array_length(global.krokosha_car_spawnmenu_available_cars) - 1))
                    global.krokosha_car_spawnmenu_selection = 0;
            }
            
            anything_down = true;
        }
        
        if (keyboard_check(vk_enter))
        {
            if (!global.krokosha_car_spawnmenu_bdown)
            {
                var selected_car_name = global.krokosha_car_spawnmenu_available_cars[global.krokosha_car_spawnmenu_selection];
                
                if (selected_car_name == "DESPAWN ALL")
                {
                    if (!instance_exists(krokosha_car_manager))
                        instance_create_depth(0, 0, 4000, krokosha_car_manager);
                    krokosha_car_manager.krokosha_despawn_all_cars();
                }
                else if (selected_car_name == "DISABLE CRASH COMMENTS" || selected_car_name == "ENABLE CRASH COMMENTS")
                {

                    global.krokosha_car_partymember_comments = ! global.krokosha_car_partymember_comments;

                }
                else
                {
                    var new_car_angle = 0;
                    if (variable_global_exists("facing")) {
                        if (global.facing == 0)
                            new_car_angle = pi; // down

                        if (global.facing == 1)
                            new_car_angle = pi*0.5; 

                        if (global.facing == 2)
                            new_car_angle = 0; // up

                        if (global.facing == 3)
                            new_car_angle = -pi*0.5;
                    }

                    audio_play_sound(snd_select, 1, false, 0.5);
                    instance_create_depth(obj_mainchara.x, obj_mainchara.y, obj_mainchara.depth, krokosha_car_driveable, 
                    {
                        car_name: selected_car_name,
                        carangle: new_car_angle
                    });
                }
                
                global.krokosha_car_spawnmenu_active = false;
            }
            
            anything_down = true;
        }
        
        if (anything_down)
            global.krokosha_car_spawnmenu_bdown = true;
        else
            global.krokosha_car_spawnmenu_bdown = false;
        
        draw_set_colour(c_yellow);
        draw_text_transformed(10 + xx, 10 + yy, "KROKOSHA CAR MOD SPAWN MENU: (UP/DOWN/ENTER)", 0.5*dwscale, 0.5*dwscale, 0);
        var isfirst = true;
        var voff = 10 + 10*dwscale + yy;
        
        for (var i = global.krokosha_car_spawnmenu_selection; i < array_length(global.krokosha_car_spawnmenu_available_cars); i++)
        {
            var carifo = global.krokosha_car_spawnmenu_available_cars[i];
            
            if (isfirst)
                draw_set_colour(c_red);
            else
                draw_set_colour(c_yellow);
            
            draw_text(10 + xx, voff, carifo);
            isfirst = false;
            voff += 19;
        }
    }
}