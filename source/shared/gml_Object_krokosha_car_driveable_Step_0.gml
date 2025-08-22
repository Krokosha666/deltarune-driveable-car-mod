update_car();

if (is_player_the_driver)
{
    if (keyboard_check(ord("H")))
    {
        if (!krokosha_pressing_honk_button)
        {
            if (!audio_is_playing(snd_carhonk))
                audio_play_sound(snd_carhonk, 1, false);
        }
        
        krokosha_pressing_honk_button = true;
    }
    else
    {
        krokosha_pressing_honk_button = false;
    }
}
