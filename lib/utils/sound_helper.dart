import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();

void playSound(String sound) async {
  await player.play(AssetSource("sounds/$sound"));
}
