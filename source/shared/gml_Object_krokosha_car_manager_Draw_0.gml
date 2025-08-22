var chunk_keys = ds_map_keys_to_array(active_chunks);
draw_set_colour(c_red);

for (var kyii = 0; kyii < array_length(chunk_keys); kyii++)
{
    var chunk = ds_map_find_value(active_chunks, chunk_keys[kyii]);
    
    if (keyboard_check(ord("Y")))
    {
        draw_rectangle(chunk.x, chunk.y, real_chunk_size, real_chunk_size, true);
        draw_text(chunk.x + (real_chunk_size * 0.5), chunk.y + (real_chunk_size * 0.5), string(depth));
        draw_text(chunk.x + (real_chunk_size * 0.5), chunk.y + (real_chunk_size * 0.5) + 20, string(layer));
        
        for (var i = 0; i < array_length(skid_points); i++)
        {
            var mark = skid_points[i];
            draw_line_width(mark.x1, mark.y1, mark.x2, mark.y2, 5);
        }
    }
    
    if (!surface_exists(chunk.surface))
        chunk.surface = surface_create(chunk_size, chunk_size, 12);
    
    if (surface_exists(chunk.surface))
    {
        surface_set_target(chunk.surface);
        
        for (var i = 0; i < array_length(skid_points); i++)
        {
            var mark = skid_points[i];
            draw_line_width((mark.x1 - chunk.x) / chunk_scale, (mark.y1 - chunk.y) / chunk_scale, (mark.x2 - chunk.x) / chunk_scale, (mark.y2 - chunk.y) / chunk_scale, 2);
        }
        
        surface_reset_target();
    }
}

array_delete(skid_points, 0, array_length(skid_points));
var cam = camera_get_active();
var view_x = camera_get_view_x(cam);
var view_y = camera_get_view_y(cam);
var view_w = camera_get_view_width(cam);
var view_h = camera_get_view_height(cam);
var min_chunk_x = floor(view_x / real_chunk_size) - 1;
var min_chunk_y = floor(view_y / real_chunk_size) - 1;
var max_chunk_x = floor((view_x + view_w) / real_chunk_size) + 1;
var max_chunk_y = floor((view_y + view_h) / real_chunk_size) + 1;
shader_set(krokosha_skidmarks_shader);

for (var cx = min_chunk_x; cx <= max_chunk_x; cx++)
{
    for (var cy = min_chunk_y; cy <= max_chunk_y; cy++)
    {
        var key = string(cx) + "," + string(cy);
        
        if (ds_map_exists(active_chunks, key))
        {
            var chunk = ds_map_find_value(active_chunks, key);
            
            if (surface_exists(chunk.surface))
            {
                chunk.last_used = current_time;
                draw_surface_stretched(chunk.surface, chunk.x, chunk.y, real_chunk_size, real_chunk_size);
            }
        }
    }
}

shader_reset();

if ((current_time % 690) == 0)
    clean_chunks();
