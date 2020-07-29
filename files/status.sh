#!/bin/bash

UNDERVOLTED=0x1
CAPPED=0x2
THROTTLED=0x4
SOFT_TEMPLIMIT=0x8
HAS_UNDERVOLTED=0x10000
HAS_CAPPED=0x20000
HAS_THROTTLED=0x40000
HAS_SOFT_TEMPLIMIT=0x80000

STATUS=$(vcgencmd get_throttled)
STATUS=${STATUS#*=}

((($STATUS&UNDERVOLTED)!=0)) && echo -n "⚡️"
((($STATUS&THROTTLED)!=0)) && echo -n "🐌"
((($STATUS&CAPPED)!=0)) && echo -n "🚩"
((($STATUS&SOFT_TEMPLIMIT)!=0)) && echo -n "🌡" 

STATUS=$(vcgencmd measure_clock arm)
STATUS=${STATUS#*=}

echo -n " $(($STATUS/1000000))MHz"

STATUS=$(vcgencmd measure_temp)
STATUS=${STATUS#*=}

echo -n " $STATUS"
