pragma Singleton

import Quickshell
import Quickshell.Services.Mpris
import QtQuick

Singleton {
  id: root

  readonly property MprisPlayer active: {
    const players = Mpris.players.values;
    for (const p of players) {
      if (p.playbackState === MprisPlaybackState.Playing) return p;
    }
    return players.length > 0 ? players[0] : null;
  }

  readonly property bool hasPlayer: active !== null
  readonly property bool isPlaying: hasPlayer && active.isPlaying
  readonly property string title: hasPlayer ? (active.trackTitle || "Unknown Title") : "Nothing playing"
  readonly property string artist: hasPlayer ? (active.trackArtist || "Unknown Artist") : ""
  readonly property string artUrl: hasPlayer ? active.trackArtUrl : ""

  function togglePlaying() {
    if (hasPlayer) active.togglePlaying();
  }

  function next() {
    if (hasPlayer && active.canGoNext) active.next();
  }

  function previous() {
    if (hasPlayer && active.canGoPrevious) active.previous();
  }
}
