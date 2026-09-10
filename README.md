# InfiniteWorld - a KPump-inspired OutFox theme based on Infinitesimal
## **This branch is a work-in-progress and requires the latest test builds of OutFox Alpha V to function as intended.**
### Make sure to drop by the Project OutFox Discord server and grab the appropriate tester roles to gain access to the latest builds, and remember to properly report bugs and issues while you're at it!

![logo](https://github.com/user-attachments/assets/2b48e6c5-02c5-4110-b1da-e3cefcd9b1a3)

## [Visit the Infinitesimal Discord server, give the folks the support and love they deserve!](https://discord.gg/ex6e4jNm6s)

## About InfiniteWorlds
This theme is inspired by K-Pump games, From Andamiro's mainline Pump It Up series. The current goals are to replicate the feel of KPump while sprinkling in some additions, better animations, utilizing original assets when possible, bringing high performance + cross-platform support to the table with Project OutFox and widening the idea and accessibility of custom Pump It Up content.

## Requirements
* [Project OutFox Alpha 0.5.0-pre042 or newer](https://projectoutfox.com/downloads)

Older StepMania versions such as `5.0.12`, `5.1b2` and `5.1-new` are not supported due to the lack of maintenance to `pump/piu` and the engine in general. Support the developers from Team OutFox who are currently doing the heavy lifting!

## Installing
Since this theme is currently on a rolling release, we highly recommend downloading the theme through GitHub Desktop (or `git` for Linux users) and pull subsequent updates that are pushed to the repository. If you're unable to do so, you can also download from the `Code > Download ZIP` button on the main page and extract the .zip file to your OutFox [Themes](https://outfox.wiki/user-guide/config/folders/#themes) folder.

**If you are upgrading from a previous version by `Download ZIP`, fully delete the old folder first. Do not merge the new folder into the old.**

## Theme Features
* Accurate asymmetrical timing windows scoring and lifebar mechanics to K-Pump
* INFWORLDS: Refreshed Animations and familiar K-Pump Interface (Mirrored Lifebars, etc.)
* Additional timing windows available (StepMania, ITG, Infinity, Pro, Jump)
* Basic Mode can be accessed by starting a game with no profiles present, or by using the "Guest" profile
* Customizable appearance options and modifiers such as arrow size and rush
* Exit to title screen in home/event mode (hold down any red arrow while selecting a folder)
* Fully customizable background filters, choose to filter playfield only or the entire screen
* Measures and song progress display
* Multiply, Automatic and Constant scroll speeds
* Visualize chart information while selecting a song, previews are currently WIP

## Theme-Specific Toggles
The following features can be configured via the Infinitesimal Options submenu of the operator menu:
* Center Chart List: if there are less charts than the maximum visible number, the charts will be centered to the display.
* Chart Preview: preview the selected chart on the select music screen.
* Image Preview Only: videos will not be displayed while selecting a song, helps with performance on low-end hardware and/or memory usage.
* Pause With Select Button: use the button mapped to "Select" to open the pause menu during gameplay.
* Use Video Background: use a pre-rendered video for the animated theme background, requires restart.
* 3x Center to Exit Evaluation: press the center panel 3 times to exit the results screen like in official games, otherwise exit on one press.
* Show Big Difficulty Icon: display a larger icon while selecting a difficulty, aspect ratios higher than 4:3 only.
* Show UCS Charts: allow UCS charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Show Quest Charts: allow Quest charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Show Hidden Charts: allow Hidden charts to be selected, if a song has no standard charts disabling might not be effective to it.
* Autogen Basic Mode: allow the game to auto generate the list of songs for Basic Mode, disable this if you plan to use a handpicked list.
* Wrap Chart List Scrolling: when scrolling past the beginning or end of the chart list, wrap the current selection to the opposite end.

## Screenshots
![Title](https://github.com/user-attachments/assets/660322a2-ea12-4f33-a787-0befde84f0dc)
![Profile](https://github.com/user-attachments/assets/e442b086-2e6e-49c0-97a3-7c40571839b1)
![BasicMode](https://github.com/user-attachments/assets/d9e9f2f1-2416-43fa-bf2f-d25a5d07964f)
![SelectMusic](https://github.com/user-attachments/assets/b7b86413-0a26-44af-bd53-28c0e08a2a01)
![Command](https://github.com/user-attachments/assets/dc6a7953-5bc2-43ac-ba6f-72ea447d3b8f)
![Gameplay_SP](https://github.com/user-attachments/assets/38d20ecc-49c3-4bce-9685-f55f42e68b6e)
![Eval](https://github.com/user-attachments/assets/1c22736e-827c-477e-baeb-aa0a27ff508c)


## Languages:
Currently, InfiniteWorlds/Infinitesimal supports the following languages:
* English
* Brazilian Portuguese
* Polish

## Additional Resources
If you're looking for assets such as more noteskins or folder icons from StepF2/P1, you can grab them [here](https://drive.google.com/drive/folders/1pO9rbaPUwTTDFuEo_4tX8S1BEwmfukeF?usp=sharing). Keep in mind these are independent from the theme and are only here for accessibility purposes to newcomers.

## Current Limitations and Issues
The theme currently has a few limitations that are beyond our reach. Here is a list of known limitations and issues:
* Some chart effects will be missing or broken from incomplete parsing
* Chart previews are very experimental - some styles might not load/show properly and your game might crash on edge cases
* Switching timing modes does not update the list of judgement graphics, simply reloading the current screen or changing screens will regenerate the list
* Infinitesimal makes use of OutFox Alpha V exclusive features. It is NOT recommended to use it with Alpha 4 LTS

Hopefully all of these should be gone soon with future Project OutFox developments and improvements!

## Special thanks (Infinitesimal)
This theme wouldn't be here if it weren't for the help of the following people:
* JoseVarelaP (loads of code optimization and refactoring, suggestions and development assistance)
* Luizsan (creator of PIU Delta / member of Team Infinity and SSC, many notes and examples taken from his work)
* Jousway and Squirrel (development assistance, pump bug squashing)
* Accelerator/Rhythm Lunatic and Engine_Machiner (theme assistance)
* Bedrock Solid (music, suggestions and playtesting)
* Jehezukiel and Lintoast (music, sound effects and announcer)
* 4199, daryen, djgrs, Enally, SHRMP0 and Sushi (suggestions and playtesting)
* CrackItUp group (original home of the theme's development)
* Team Infinity (setting a landmark in PIU's interface and graphics design)
* RGAB Community

## Special thanks (InfiniteWorlds)
* tinygoat (Graphics, Lua animations, Sound Effects)
* the4kman (Menu music, also, very sick sound design, you should go check their works out!)

And at last, you for trying out our theme!
