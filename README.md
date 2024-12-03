# TrimUI Brick Easy Setup

The TrimUI Brick may not come with a microSD card.

In those cases, you need to manually download and unzip the contents that will make the TrimUI Brick more useful than said brick.

I found this a bit convoluted, so with the help of ChatGPT (PowerShell is not fun!) I bring you an all-in-one solution.

## Pre-Requisites
* microSD Card - this can be any size, but make sure its large enough to store your games!
* 7zip - Download and install 7zip on your computer
* ~2gb of free space on your computer

## Steps to install
1. Insert your microSD card into your computer. Take note of what drive the microSD card is located at. You will need this later
2. Open PowerShell
3. Copy and paste this into PowerShell:
```
iex (iwr -Uri "https://github.com/scatteredbra1n/TrimUIBrickEasySetup/blob/master/TrimUIBrickSetup.ps1")
```
4. Type in the drive of your microSD card, DO NOT include the trailing `\`
5. Hit enter - and wait! This process takes about 20 minutes :-)