#!/usr/bin/env bash
# Generates small, on-brand *illustrative* demo clips (schematic animations, not
# real screen recordings) for the seed catalog entries, plus a poster still each.
# Output lands in public/videos/ (well under the 5 MB local-clip budget).
#
# Requires ffmpeg with libx264 + drawtext (libfreetype).
#   ./scripts/gen-demo-videos.sh
set -euo pipefail

DIR="$(cd "$(dirname "$0")/.." && pwd)"
OUT="$DIR/public/videos"
mkdir -p "$OUT"

FONT="/System/Library/Fonts/Supplemental/Arial.ttf"
[ -f "$FONT" ] || FONT="/Library/Fonts/Arial.ttf"

PAPER=0xF4F1EA; INK=0x1B1A17; INK2=0x4A473F; MUTE=0x9A968B
ACCENT=0xB4471F; LIT=0xE8EEF2; OFF=0x141310; WHITE=0xFFFFFF
R=30

enc() { ffmpeg -y -hide_banner -loglevel error -f lavfi -i "color=c=${PAPER}:s=1280x720:r=${R}:d=${2}" \
        -vf "$1" -c:v libx264 -pix_fmt yuv420p -crf 30 -movflags +faststart "$3"; }
poster() { ffmpeg -y -hide_banner -loglevel error -ss "$2" -i "$1" -frames:v 1 -q:v 3 "$3"; }

# ---------------------------------------------------------------- display-blackout
F="format=rgb24"
F+=",drawtext=fontfile=${FONT}:text='display-blackout':x=(w-text_w)/2:y=64:fontsize=30:fontcolor=${ACCENT}"
F+=",drawtext=fontfile=${FONT}:text='Keep one screen — black out the rest':x=(w-text_w)/2:y=110:fontsize=40:fontcolor=${INK}"
for i in 0 1 2; do
  x=$((160 + i*340))
  F+=",drawbox=x=${x}:y=250:w=280:h=185:color=${INK}:t=4"
  F+=",drawbox=x=$((x+4)):y=254:w=272:h=177:color=${LIT}:t=fill"
  F+=",drawbox=x=$((x+128)):y=435:w=24:h=26:color=${INK}:t=fill"
  F+=",drawbox=x=$((x+90)):y=461:w=100:h=8:color=${INK}:t=fill"
  n=$((i+1)); cx=$((x+140))
  F+=",drawtext=fontfile=${FONT}:text='${n}':x=${cx}-text_w/2:y=318:fontsize=44:fontcolor=${MUTE}:enable='lt(t,2.6)'"
done
# after 2.6s: black out screens 1 & 3, focus screen 2
F+=",drawbox=x=164:y=254:w=272:h=177:color=${OFF}:t=fill:enable='gte(t,2.6)'"
F+=",drawbox=x=844:y=254:w=272:h=177:color=${OFF}:t=fill:enable='gte(t,2.6)'"
F+=",drawtext=fontfile=${FONT}:text='FOCUS':x=640-text_w/2:y=318:fontsize=40:fontcolor=${ACCENT}:enable='gte(t,2.7)'"
F+=",drawtext=fontfile=${FONT}:text='press  2':x=(w-text_w)/2:y=545:fontsize=40:fontcolor=${INK}:enable='gte(t,1.8)'"
enc "$F" 6 "$OUT/display-blackout.mp4"
poster "$OUT/display-blackout.mp4" 4 "$OUT/display-blackout.jpg"

# -------------------------------------------------------------------- url-launcher
F="format=rgb24"
F+=",drawtext=fontfile=${FONT}:text='url-launcher':x=(w-text_w)/2:y=60:fontsize=30:fontcolor=${ACCENT}"
F+=",drawtext=fontfile=${FONT}:text='Type a URL — Chrome opens on this screen':x=(w-text_w)/2:y=104:fontsize=36:fontcolor=${INK}"
F+=",drawbox=x=390:y=200:w=500:h=320:color=${INK}:t=4"
F+=",drawbox=x=395:y=205:w=490:h=310:color=${LIT}:t=fill"
F+=",drawbox=x=628:y=520:w=24:h=28:color=${INK}:t=fill,drawbox=x=585:y=548:w=110:h=8:color=${INK}:t=fill"
# URL bar
F+=",drawbox=x=420:y=232:w=440:h=46:color=${WHITE}:t=fill,drawbox=x=420:y=232:w=440:h=46:color=${INK2}:t=2"
F+=",drawtext=fontfile=${FONT}:text='type a url...':x=436:y=244:fontsize=24:fontcolor=${MUTE}:enable='lt(t,1.2)'"
F+=",drawtext=fontfile=${FONT}:text='https\://nasa.gov':x=436:y=242:fontsize=26:fontcolor=${INK}:enable='gte(t,1.2)'"
# chrome window opens on same screen at 3.0
F+=",drawbox=x=420:y=300:w=440:h=200:color=${WHITE}:t=fill:enable='gte(t,3.0)'"
F+=",drawbox=x=420:y=300:w=440:h=28:color=0xE3E0D8:t=fill:enable='gte(t,3.0)'"
F+=",drawbox=x=434:y=310:w=9:h=9:color=0xEB5E57:t=fill:enable='gte(t,3.0)'"
F+=",drawbox=x=450:y=310:w=9:h=9:color=0xF4BF4F:t=fill:enable='gte(t,3.0)'"
F+=",drawbox=x=466:y=310:w=9:h=9:color=0x64C466:t=fill:enable='gte(t,3.0)'"
F+=",drawtext=fontfile=${FONT}:text='nasa.gov':x=520:y=307:fontsize=16:fontcolor=${INK2}:enable='gte(t,3.0)'"
F+=",drawtext=fontfile=${FONT}:text='opened on THIS screen':x=640-text_w/2:y=400:fontsize=28:fontcolor=${ACCENT}:enable='gte(t,3.4)'"
enc "$F" 6 "$OUT/url-launcher.mp4"
poster "$OUT/url-launcher.mp4" 4 "$OUT/url-launcher.jpg"

# ------------------------------------------------------------------- tab-workflows
F="format=rgb24"
F+=",drawtext=fontfile=${FONT}:text='tab-workflows':x=(w-text_w)/2:y=56:fontsize=30:fontcolor=${ACCENT}"
F+=",drawtext=fontfile=${FONT}:text='One command opens your tab set across monitors':x=(w-text_w)/2:y=100:fontsize=34:fontcolor=${INK}"
# terminal
F+=",drawbox=x=340:y=170:w=600:h=140:color=0x14130F:t=fill,drawbox=x=340:y=170:w=600:h=30:color=0x2A2823:t=fill"
F+=",drawbox=x=356:y=181:w=9:h=9:color=0xEB5E57:t=fill,drawbox=x=372:y=181:w=9:h=9:color=0xF4BF4F:t=fill,drawbox=x=388:y=181:w=9:h=9:color=0x64C466:t=fill"
F+=",drawtext=fontfile=${FONT}:text='zsh':x=452:y=179:fontsize=15:fontcolor=${MUTE}"
F+=",drawtext=fontfile=${FONT}:text='> _':x=364:y=232:fontsize=28:fontcolor=${PAPER}:enable='lt(t,1.0)'"
F+=",drawtext=fontfile=${FONT}:text='> tabflow research':x=364:y=232:fontsize=28:fontcolor=${PAPER}:enable='gte(t,1.0)'"
# two monitors appear at 2.6
for x in 210 690; do
  F+=",drawbox=x=${x}:y=360:w=380:h=230:color=${INK}:t=4:enable='gte(t,2.6)'"
  F+=",drawbox=x=$((x+4)):y=364:w=372:h=222:color=${LIT}:t=fill:enable='gte(t,2.6)'"
  F+=",drawbox=x=$((x+4)):y=364:w=372:h=30:color=0xE3E0D8:t=fill:enable='gte(t,2.6)'"
done
# staggered tabs
F+=",drawbox=x=222:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.0)'"
F+=",drawbox=x=308:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.3)'"
F+=",drawbox=x=394:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.6)'"
F+=",drawbox=x=702:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.2)'"
F+=",drawbox=x=788:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.5)'"
F+=",drawbox=x=874:y=369:w=80:h=20:color=${WHITE}:t=fill:enable='gte(t,3.8)'"
F+=",drawtext=fontfile=${FONT}:text='research  workspace':x=(w-text_w)/2:y=620:fontsize=30:fontcolor=${ACCENT}:enable='gte(t,4.2)'"
enc "$F" 6 "$OUT/tab-workflows.mp4"
poster "$OUT/tab-workflows.mp4" 4 "$OUT/tab-workflows.jpg"

echo "Done:"
ls -lh "$OUT"
