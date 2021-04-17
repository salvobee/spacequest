# SpaceQuest
A small experiment started (and not finished yet) in 2017 to write a Commodore 64 platformer game in machine language.
The game is almost unplayable, the main goal was to setup a basic platform engine with a multi-screen map, while I managed to reach the first I didn't had time to complete the latter.
I've included some notes, spreadsheets and flowcharts (badly designed) that at the time of development helped me to design the logic and perform calculations

## Dev Stack
I've started the development on Windows, so I've setup a small dev enviroment using a plain text editor and a batch script to build and exomize the binary, I've used [ACME](https://github.com/meonwax/acme) as cross assembler.

## How to Build
I've included in the repository a copy of the [ACME](https://github.com/meonwax/acme) cross assembler binary for windows and of the [Exomizer](https://bitbucket.org/magli143/exomizer/wiki/Home) compressor, plus the `build.bat` script that I've used to cross-compile the binary.