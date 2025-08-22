car_player_dismount();

if (audio_exists(car_tirescreech_sound))
    audio_stop_sound(car_tirescreech_sound);

if (audio_exists(car_engine_sound))
    audio_stop_sound(car_engine_sound);

if (has_custom_engine_sound)
    audio_destroy_stream(car_engine_sound_stream);

if (car_modelresourcefound)
{
    if (vertex_buffer != -1)
    {
        try
        {
            vertex_delete_buffer(vertex_buffer);
        }
        catch (_)
        {
        }
        
        vertex_buffer = -1;
    }
    
    sprite_delete(car_texture_as_sprite);
    
    if (surface_exists(car_low_res_surface))
        surface_free(car_low_res_surface);
}
