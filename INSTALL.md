# Installing Blink

Tested on macOS 15.5, Apple silicon. Needs macOS 14 or later.

## 1. Unzip and install

    cd ~/Downloads
    unzip blink-mac.zip -d blink
    cd blink
    ./install.sh

`install.sh` does three things:

- copies the Eye model weights into `~/Library/Caches/desert-ant-models`
  (about 49 MB, so no download happens on first run)
- clears the quarantine flag on the unsigned app
- prints the path to the app

## 2. Open the app

    open Blink.app

Then press `Cmd+O` and choose a folder of photos. To open straight into a folder:

    open Blink.app --args ~/Pictures/Holiday

If macOS still refuses the first launch, right click `Blink.app`, choose **Open**,
then **Open** again in the dialog. That is the usual one-time gatekeeper prompt for
an app without a notarized signature.

## 3. Command line tools

    ./bin/blink-cli ~/Pictures/Holiday --best 30 --json out.json
    ./bin/blink-snap ~/Pictures/Holiday ~/Desktop/blink.png moments

Copy both into `/usr/local/bin` if you want them on your PATH:

    sudo cp bin/blink-cli bin/blink-snap /usr/local/bin/

## 4. Try it before your own library

    open Blink.app --args "$PWD/sample"

That folder has 10 photos plus a screenshot, a receipt and a whiteboard, so
Moments, Junk Drawer and Best Of all have something to show.

## Reading the numbers

- **keeper** — Eye's overall score for the frame, 0 to 1
- **beauty** — aesthetic score, independent of the keeper logic
- **blinkers** — how many faces in that frame have their eyes closed
- **faces** — detected faces
- **percentage chip in the Junk Drawer** — Eye's confidence that the image is
  that kind of clutter

## Uninstall

    rm -rf Blink.app
    rm -rf ~/Library/Application\ Support/Blink
    rm -rf ~/Library/Caches/desert-ant-models

## Rebuilding from source

Only needed if you want to change the code. The zip runs as-is.

    git clone --depth 1 https://github.com/Desert-Ant-Labs/desert-ant-core.git sdk
    swift build -c release --product Blink
    swift build -c release --product blink-cli
    swift build -c release --product blink-snap

Requires the Command Line Tools (Swift 6.1+). The package pins the Eye SDK as a
local path dependency in `sdk/`, and every target builds in Swift language mode 5
because the SDK's own sources are not strict-concurrency clean.

---

Built By Harish Kotra — https://harishkotra.me

Checkout my other builds — https://dailybuild.xyz
