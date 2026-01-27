import XMonad
import XMonad.Util.EZConfig (additionalKeysP)
import XMonad.Util.SpawnOnce (spawnOnce)
import XMonad.Layout.Spacing
import XMonad.Hooks.ManageDocks
import XMonad.Layout.MultiToggle
import XMonad.Layout.MultiToggle.Instances
import XMonad.Hooks.EwmhDesktops
import XMonad.Layout.NoBorders
import qualified XMonad.StackSet as W
import qualified Data.Map as M


myLayout =
    avoidStruts
    $ smartBorders
    $ mkToggle (single FULL)
    $ spacingWithEdge 4
    $ Tall 1 (3/100) (1/2)


myStartup :: X ()
myStartup = do
    spawnOnce "picom &"
    spawnOnce "feh --bg-fill ~/Downloads/613357.png"
    spawnOnce "xmobar"

toggleFloat :: Window -> X ()
toggleFloat w =
    windows $ \s ->
        if M.member w (W.floating s)
           then W.sink w s
           else W.float w (W.RationalRect 0.1 0.1 0.8 0.8) s



myKeys :: [(String, X ())]
myKeys =
    [ ("M-<Return>", spawn "alacritty")
    , ("M-d", spawn "rofi -show drun")
    , ("M-q", kill)
    , ("M-r", spawn "xmonad --recompile && xmonad --restart")
    , ("M-b", spawn "firefox")
    , ("M-f", sendMessage $ Toggle FULL)
    , ("M-t", withFocused toggleFloat)
    ]

main :: IO ()
main = xmonad
     $ ewmhFullscreen
     $ ewmh
     $ def
        { terminal           = "alacritty"
        , modMask            = mod1Mask
        , borderWidth        = 1
        , normalBorderColor  = "#222222"
        , focusedBorderColor = "#3c3836"
        , startupHook        = myStartup
        , layoutHook         = myLayout
        }
     `additionalKeysP` myKeys

