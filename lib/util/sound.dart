import 'package:assets_audio_player/assets_audio_player.dart';

class Sound {

  // PLAYボタンの効果音
  void playStart() {
    //AssetsAudioPlayerをインスタンス化
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
    // 音声をセット
    _assetsAudioPlayer.open(Audio("lib/assets/sound/start.mp3"),);
    // 再生
    _assetsAudioPlayer.play();
  }

  // メニュー選択時の効果音
  void playSelectMenu() {
    //AssetsAudioPlayerをインスタンス化
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
    // 音声をセット
    _assetsAudioPlayer.open(Audio("lib/assets/sound/kon.mp3"),);
    // 再生
    _assetsAudioPlayer.play();
  }

  // タップエリアの効果音
  void playTapErea() {
    //AssetsAudioPlayerをインスタンス化
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
    // 音声をセット
    _assetsAudioPlayer.open(Audio("lib/assets/sound/shot.mp3"),);
    // 再生
    _assetsAudioPlayer.play();
  }

  // クリアの効果音
  void playClear() {
    //AssetsAudioPlayerをインスタンス化
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
    // 音声をセット
    _assetsAudioPlayer.open(Audio("lib/assets/sound/clear.mp3"),);
    // 再生
    _assetsAudioPlayer.play();
  }

  // ゲームオーバーの効果音
  void playGameOver() {
    //AssetsAudioPlayerをインスタンス化
    AssetsAudioPlayer _assetsAudioPlayer = AssetsAudioPlayer();
    // 音声をセット
    _assetsAudioPlayer.open(Audio("lib/assets/sound/gameover.mp3"),);
    // 再生
    _assetsAudioPlayer.play();
  }
}