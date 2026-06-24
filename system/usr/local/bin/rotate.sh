#!/bin/sh
# GPD Pocket 3 screen rotation with hotkeys
# Cycles: right -> inverted -> left -> normal

id_touchscreen="16"
id_stylus="17"
R_0="0 1 0 -1 0 1 0 0 1"
R_90="-1 0 1 0 -1 1 0 0 1"
R_180="0 -1 1 1 0 0 0 0 1"
R_270="1 0 0 0 1 0 0 0 1"

screen_orientation=$(xrandr --query --verbose | grep DSI-1 | awk '{print $5}')

case "$screen_orientation" in
  "right" )
    xinput set-prop $id_touchscreen 'Coordinate Transformation Matrix' $R_90
    xinput set-prop $id_stylus 'Coordinate Transformation Matrix' $R_90
    xrandr --output DSI-1 --rotate inverted
    ;;
  "inverted" )
    xinput set-prop $id_touchscreen 'Coordinate Transformation Matrix' $R_180
    xinput set-prop $id_stylus 'Coordinate Transformation Matrix' $R_180
    xrandr --output DSI-1 --rotate left
    ;;
  "left" )
    xinput set-prop $id_touchscreen 'Coordinate Transformation Matrix' $R_270
    xinput set-prop $id_stylus 'Coordinate Transformation Matrix' $R_270
    xrandr --output DSI-1 --rotate normal
    ;;
  "normal" )
    xinput set-prop $id_touchscreen 'Coordinate Transformation Matrix' $R_0
    xinput set-prop $id_stylus 'Coordinate Transformation Matrix' $R_0
    xrandr --output DSI-1 --rotate right
    ;;
esac
