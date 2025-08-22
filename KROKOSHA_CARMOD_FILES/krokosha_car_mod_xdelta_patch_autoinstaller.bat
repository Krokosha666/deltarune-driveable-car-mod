@echo off

echo  --------------------
echo This is Car Mod installer script for when you don't have any mod managers.
echo  --------------------

echo ARE YOU SURE YOU BACKED UP ALL ORIGINAL "data.win" FILES ???????????????????
echo PRESS ENTER WHEN YOU ARE SURE
PAUSE


cd ..


if exist "DELTARUNE.exe" (

    echo  --------------------
    echo GETTING READY TO PATCH DELTARUNE
    echo  --------------------

    if exist "chapter1_windows\data.backup_before_krokosha_car_mod.win" (
        echo DETECTED BACKUP MADE BY THIS SCRIPT, USING THE "chapter1_windows\data.backup_before_krokosha_car_mod.win" AND REPLACING "chapter1_windows\data.win" 
    ) else (
        echo CREATING ANOTHER BACKUP: "chapter1_windows\data.backup_before_krokosha_car_mod.win"
        copy "chapter1_windows\data.win" "chapter1_windows\data.backup_before_krokosha_car_mod.win"
    )

    if exist "chapter2_windows\data.backup_before_krokosha_car_mod.win" (
        echo DETECTED BACKUP MADE BY THIS SCRIPT, USING THE "chapter2_windows\data.backup_before_krokosha_car_mod.win" AND REPLACING "chapter2_windows\data.win" 
    ) else (
        echo CREATING ANOTHER BACKUP: "chapter2_windows\data.backup_before_krokosha_car_mod.win"
        copy "chapter2_windows\data.win" "chapter2_windows\data.backup_before_krokosha_car_mod.win"
    )

    if exist "chapter3_windows\data.backup_before_krokosha_car_mod.win" (
        echo DETECTED BACKUP MADE BY THIS SCRIPT, USING THE "chapter3_windows\data.backup_before_krokosha_car_mod.win" AND REPLACING "chapter3_windows\data.win" 
    ) else (
        echo CREATING ANOTHER BACKUP: "chapter3_windows\data.backup_before_krokosha_car_mod.win"
        copy "chapter3_windows\data.win" "chapter3_windows\data.backup_before_krokosha_car_mod.win"
    )

    if exist "chapter4_windows\data.backup_before_krokosha_car_mod.win" (
        echo DETECTED BACKUP MADE BY THIS SCRIPT, USING THE "chapter4_windows\data.backup_before_krokosha_car_mod.win" AND REPLACING "chapter4_windows\data.win" 
    ) else (
        echo CREATING ANOTHER BACKUP: "chapter4_windows\data.backup_before_krokosha_car_mod.win"
        copy "chapter4_windows\data.win" "chapter4_windows\data.backup_before_krokosha_car_mod.win"
    )


    echo  --------------------
    echo PATCHING DELTARUNE
    echo  --------------------

    echo PATCHING CHAPTER 1
    "KROKOSHA_CARMOD_FILES\xdelta\xdelta.exe" -d -f -s "chapter1_windows\data.backup_before_krokosha_car_mod.win" "KROKOSHA_CARMOD_FILES\krokosha_car_mod_xdelta_patches\ch1.xdelta" "chapter1_windows\data.win"

    echo PATCHING CHAPTER 2
    "KROKOSHA_CARMOD_FILES\xdelta\xdelta.exe" -d -f -s "chapter2_windows\data.backup_before_krokosha_car_mod.win" "KROKOSHA_CARMOD_FILES\krokosha_car_mod_xdelta_patches\ch2.xdelta" "chapter2_windows\data.win"

    echo PATCHING CHAPTER 3
    "KROKOSHA_CARMOD_FILES\xdelta\xdelta.exe" -d -f -s "chapter3_windows\data.backup_before_krokosha_car_mod.win" "KROKOSHA_CARMOD_FILES\krokosha_car_mod_xdelta_patches\ch3.xdelta" "chapter3_windows\data.win"

    echo PATCHING CHAPTER 4
    "KROKOSHA_CARMOD_FILES\xdelta\xdelta.exe" -d -f -s "chapter4_windows\data.backup_before_krokosha_car_mod.win" "KROKOSHA_CARMOD_FILES\krokosha_car_mod_xdelta_patches\ch4.xdelta" "chapter4_windows\data.win"


    echo  --------------------
    echo SCRIPT ENDED !!!!!!!! YOU CAN NOW PLAY THE GAME -if there was no errors above- !!!!!
    echo PRESS ENTER TO EXIT
    PAUSE
) else (
    echo  --------------------
    echo CANT FIND DELTARUNE.exe, PLEASE, READ THE INSTRUCTIONS CAREFULLY !!!!!
    echo PRESS ENTER TO EXIT
    PAUSE
)

