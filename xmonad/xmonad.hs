{-# LANGUAGE FlexibleContexts #-}

import XMonad
import qualified XMonad.StackSet as W
import qualified Data.Map as M
import XMonad.Hooks.EwmhDesktops
import XMonad.Util.SpawnOnce
import XMonad.Util.EZConfig
import XMonad.Util.NamedScratchpad
import XMonad.Layout.Spacing
import XMonad.Layout.Grid
import XMonad.Layout.NoBorders
import XMonad.Layout.ResizableTile
import XMonad.Layout.Fullscreen
import XMonad.Layout.ThreeColumns
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import System.Exit (exitSuccess)

myModMask = mod1Mask
myTerminal = "st"
myBorderWidth = 3
myNormalBorderColor  = "#3c3836"  
myFocusedBorderColor = "#4A3609"  
myWorkspaces = ["1","2","3","4","5","6","7","8","9"]

mySpacing =
    spacingRaw
        False
        (Border 15 15 15 15)
        True
        (Border 10 10 10 10)
        True

tiled = ResizableTall 1 (3/100) (55/100) []
vertical = Mirror tiled
gridLayout = Grid
monocle = Full
threeCol = ThreeCol 1 (3/100) (1/2)

myLayoutHook =
    avoidStruts $
    mySpacing $
        tiled
        ||| vertical
        ||| gridLayout
        ||| threeCol
        ||| monocle

myScratchpads =
  [ NS "scratchpad"
    "alacritty --title scratchpad"
    (title =? "scratchpad")
    (customFloating $ W.RationalRect 0.1 0.05 0.8 0.9)
  ]

myManageHook =
    composeAll
        [ className =? "Rofi" --> doFloat
        , className =? "Pavucontrol" --> doFloat
        , isDialog --> doFloat
        , isFullscreen --> doFullFloat
        ]
    <+> namedScratchpadManageHook myScratchpads

myStartupHook = do
    spawnOnce "picom --config ~/.config/picom/picom.conf"
    -- Clean up and restart the audio stack
    spawn "pkill pipewire; pkill pipewire-pulse; pkill wireplumber"
    spawn "pipewire & sleep 1 && pipewire-pulse & sleep 1 && wireplumber"
    spawnOnce "polybar"
    spawnOnce "feh --bg-fill ~/Downloads/jankozizak.jpg"

myKeys =
  [ ("M-<Return>", spawn myTerminal)
  , ("M-d", spawn "rofi -show drun")
  , ("M-b", spawn "while ! pactl info > /dev/null 2>&1; do sleep 0.1; done; firefox")
  , ("M-f", spawn "thunar")
  , ("M-q", kill)
  , ("M-<Tab>", windows W.focusDown)
  , ("M-n", sendMessage NextLayout)
  , ("M-S-Up", sendMessage Shrink)
  , ("M-S-Down", sendMessage Expand)
  , ("M-e", namedScratchpadAction myScratchpads "scratchpad")
  , ("M-S-r", spawn "xmonad --recompile; xmonad --restart")
  , ("M-S-q", io exitSuccess)
  ]
  ++
  [ ("M-" ++ show i, windows $ W.greedyView (show i))
    | i <- [1..9]
  ]
  ++
  [ ("M-S-" ++ show i, windows $ W.shift (show i))
    | i <- [1..9]
  ]

myMouseBindings (XConfig {XMonad.modMask = modMask}) =
    M.fromList
        [ ((modMask, button1), \w -> focus w >> mouseMoveWindow w)
        , ((modMask, button3), \w -> focus w >> mouseResizeWindow w)
        ]

main =
  xmonad $
  ewmh $
  docks (def
    { modMask = myModMask
    , terminal = myTerminal
    , borderWidth = myBorderWidth
    , normalBorderColor = myNormalBorderColor
    , focusedBorderColor = myFocusedBorderColor
    , workspaces = myWorkspaces
    , layoutHook = myLayoutHook
    , manageHook = myManageHook
    , startupHook = myStartupHook
    , mouseBindings = myMouseBindings
    }) `additionalKeysP` myKeys
