
You can install automatically or manually or with a mod manger. 
(automatically and mod manager is one-click install)



=============================================================================================================================================================================
DELTAMod steps: ==============================================================================================================================

This mod is compatible with DELTAMod, just select the zip and install.


=============================================================================================================================================================================
AUTOMATIC steps (ONLY FOR Windows x86-64 !!!): ==============================================================================================================================

1. Extract the zip file.

2. Copy directory "KROKOSHA_CARMOD_FILES" and paste it into DELTARUNE root directory (where the exe is located)
     		Windows:  [SteamLibrary or Steam]/steamapps/common/DELTARUNE/

	DELTARUNE root directory should look something like this:
	- DELTARUNE/
		- - DELTARUNE.exe
		- - data.win
		- - * some config files *
		- - mus/
		- - chapter1_windows/
		- - chapter2_windows/
		- - * more chapter folders *
		- - KROKOSHA_CARMOD_FILES/
			- - - *contents of "KROKOSHA_CARMOD_FILES" are inside "KROKOSHA_CARMOD_FILES"*

3. Go into the "KROKOSHA_CARMOD_FILES" directory and run the "krokosha_car_mod_xdelta_patch_autoinstaller.bat" by double-clicking it.

4. Let the script run and it will tell you if it installed the mod succesfully and you can then close it.

5. Start deltarune.
6. Go into any chapter.
7. Start game or load save.
8. When you are in-game and able to move Kris, Press K + R .
9. If car spawn menu appears, you're good.
10. (optional) Upvote, promote or support the mod.

(BTW DON'T delete the "KROKOSHA_CARMOD_FILES" directory!  It still needs assets for the mod to work! )


TROUBLESHOOTING:

XD3_INVALID_INPUT: ensure original "data.win" and delete the old "data_backup_before_krokosha_car_mod.win" files.


===========================================================================================================================================================
MANUAL steps: =============================================================================================================================================
required:
 - Deltarune - (demo version wasnt tested)
 - xdelta patcher:
   This tutorial focuses on DeltaPatcher. If you are advanced user you can use xdelta.exe CLI tool in the xdelta folder.
   DeltaPatcher - download and extract latest "windows_bin_x86_64.zip" here: https://github.com/marco-calautti/DeltaPatcher/releases


1. Extract the zip file.

2. copy directory "KROKOSHA_CARMOD_FILES" and paste it into DELTARUNE root directory (where the exe is located)
     		Windows:  [SteamLibrary or Steam]/steamapps/common/DELTARUNE/

	DELTARUNE root directory should look something like this:
	- DELTARUNE/
		- - DELTARUNE.exe
		- - data.win
		- - * some config files *
		- - mus/
		- - chapter1_windows/
		- - chapter2_windows/
		- - * more chapter folders *
		- - KROKOSHA_CARMOD_FILES/
			- - - *contents of "KROKOSHA_CARMOD_FILES" are inside "KROKOSHA_CARMOD_FILES"*

3. Open DeltaPatcher 
4. Patch individual chapters "data.win" files with the patches located in "krokosha_car_mod_xdelta_patches/"

5. Start deltarune.
6. Go into any chapter.
7. Start game or load save.
8. When you are in-game and able to move Kris, Press K + R .
9. If car spawn menu appears, you're good.
10. (optional) Upvote, promote or support the mod.

(BTW DON'T delete the "KROKOSHA_CARMOD_FILES" directory!  It still needs assets for the mod to work! )



===========================================================================================================================================================
HOW TO UNINSTALL steps: =============================================================================================================================================

1. It's enough to replace all chapters "data.win" with their backed up versions. 
 - Theres 3 options:
 - - Replace with your own backed up "data.win" files.
 - - Replace with this mods "data.backup_before_krokosha_car_mod.win" as backup.
 - - Use Steam's "Verify Game Files Integrity" feature.
2. Then the "KROKOSHA_CARMOD_FILES" folder is unused and can be deleted completely.
3. (optional) Upvote, promote or support the mod.






-- info about the files:

directory "krokosha_car_mod_sounds" stores sounds, Deltarune reads those files, so don't delete it.
directory "krokosha_dr_car_models" stores assets like 3d models and textures
directory "xdelta" stores xdelta.exe, a minimal tool for applying xdelta patches, used only by the autoinstaller.bat file.
directory "thumbnail" just has the GTA 6 inspired art made for this mod. In full quality.
directory "krokosha_car_mod_xdelta_patches" self-explaining

xdelta file - is a patch file that stores differences between original and modified file


















