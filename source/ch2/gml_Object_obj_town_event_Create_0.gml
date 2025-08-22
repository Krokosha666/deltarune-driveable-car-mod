choicetimer = 0;
flush = 0;
con = 0;

if (room == room_town_mid)
{
    if (global.chapter == 1)
    {
        if (global.flag[271] == 0)
        {
            bnpc = instance_create(x, y, obj_npc_room_animated);
            bnpc.sprite_index = spr_npc_icemascot1;
        }
        else
        {
            bnpc = instance_create(x + 7, y + 4, obj_npc_room);
            bnpc.sprite_index = spr_npc_burgerpants;
        }
    }
    else if (global.chapter == 2)
    {
        var snail_guy = instance_create(170, 65, obj_npc_room);
        snail_guy.sprite_index = spr_npc_snailcar;
        var donut_guy = instance_create(91, 65, obj_npc_room);
        donut_guy.sprite_index = spr_npc_donutcar;
        var scarflady = instance_create(1155, 85, obj_npc_room);
        scarflady.sprite_index = spr_npc_scarflady;
        var conbini = scr_marker_animated(940, -50, spr_lw_conbini_open, 0.05);
        conbini.depth = 980000;
    }
}

if (room == room_town_south)
{
    policewindow = scr_marker(292, 57, spr_policewindow);
    
    with (policewindow)
        depth = 940000;
}

if (room == room_graveyard)
{
    overlay = instance_create(0, 0, obj_backgrounder_sprite);
    
    with (obj_mainchara)
        bg = 1;
    
    with (overlay)
    {
        image_alpha = 0.4;
        ss = 0.1;
        sprite_index = spr_graveyard_overlay;
        depth = 1000;
    }
}

function krokosha_calculate_the_graycar_id(ex,uay) {
    return 1000 + round(abs(ex) + abs((abs(ex)+1) * uay));
}
function krokosha_delete_car_if_already_exist(car) {
    if (!krokosha_car_manager.check_if_car_with_spawn_id_doesnt_already_exist(krokosha_calculate_the_graycar_id(car.x,car.y))) {
        instance_destroy(car);
    }
}

if (room == room_town_south)
{
    if (global.chapter == 2 && global.plot >= 15 && global.plot < 200)
    {

        if (!instance_exists(krokosha_car_manager))
            instance_create_depth(0, 0, 4000, krokosha_car_manager);

        
        var cardowna = instance_create(847, 51, obj_npc_room);
        cardowna.sprite_index = spr_lw_car_gray_down; 
        krokosha_delete_car_if_already_exist(cardowna);
       
        var cardownb = instance_create(842, 230, obj_npc_room);
        cardownb.sprite_index = spr_lw_car_gray_down;
        krokosha_delete_car_if_already_exist(cardownb);
        
        var cardownc = instance_create(667, 147, obj_npc_room);
        cardownc.sprite_index = spr_lw_car_gray_down;
        krokosha_delete_car_if_already_exist(cardownc);

        var carrighta = instance_create(815, 4, obj_npc_room);
        carrighta.sprite_index = spr_lw_car_gray_right;
        krokosha_delete_car_if_already_exist(carrighta);

        var carrightb = instance_create(815, 196, obj_npc_room); // dis good
        carrightb.sprite_index = spr_lw_car_gray_right;
        krokosha_delete_car_if_already_exist(carrightb);

        var carrightc = instance_create(593, 130, obj_npc_room);
        carrightc.sprite_index = spr_lw_car_gray_right;
        krokosha_delete_car_if_already_exist(carrightc);

        var carlefta = instance_create(812, 100, obj_npc_room);
        carlefta.sprite_index = spr_lw_car_gray_left;
        krokosha_delete_car_if_already_exist(carlefta);

        var carleftb = instance_create(593, 160, obj_npc_room);
        carleftb.sprite_index = spr_lw_car_gray_left;
        krokosha_delete_car_if_already_exist(carleftb);

        var carupa = instance_create(815, 38, obj_npc_room);
        carupa.sprite_index = spr_lw_car_gray_up;
        krokosha_delete_car_if_already_exist(carupa);

        var carupb = instance_create(707, 137, obj_npc_room);
        carupb.sprite_index = spr_lw_car_gray_up;
        krokosha_delete_car_if_already_exist(carupb);

        var carupc = instance_create(840, -50, obj_npc_room);
        carupc.sprite_index = spr_lw_car_gray_up;
        krokosha_delete_car_if_already_exist(carupc);

        var carupd = instance_create(548, 138, obj_npc_room);
        carupd.sprite_index = spr_lw_car_gray_up;
        krokosha_delete_car_if_already_exist(carupd);

        if (krokosha_car_manager.check_if_car_with_spawn_id_doesnt_already_exist(50)){
            var carsnail = instance_create(832, 130, obj_npc_room);
            carsnail.sprite_index = spr_npc_snailcar;
        }
        if (krokosha_car_manager.check_if_car_with_spawn_id_doesnt_already_exist(70)){
            var cardonut = instance_create(750, 130, obj_npc_room);
            cardonut.sprite_index = spr_npc_donutcar;
        }
        var undyne = instance_create(910, 57, obj_npc_room_animated);
        undyne.sprite_index = spr_undyne_benchpress;
    }
}
