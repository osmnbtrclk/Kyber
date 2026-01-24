import 'dart:convert';
import 'dart:typed_data';

import 'package:kyber_collection/kyber_collection.dart';

const _kFrostyMagic = 0x46434F4C;
const _kCollectionVersion = 1;

class FrostyCollectionWriter extends ByteWriter {
  final FrostyCollection collection;

  FrostyCollectionWriter(this.collection);

  factory FrostyCollectionWriter.test() {
    final testJson =
        """{"link":"","title":"Battlefront Plus","author":"Battlefront Plus Team","version":"10.0-beta73","description":"","category":"Gameplay","mods":["KYBER - Anticheat.fbmod","RemoveBadConnectionInputBlocking.fbmod","StateMachine Improvements and Additions 3.19.1.fbmod","BF+ AudioSystem StreamPool.fbmod","BF+ Purple Cards.fbmod","BF+ Team Data.fbmod","BF+ Weapon Stats Removal.fbmod","BF+ Voiceover Labels.fbmod","PM Grounded Supremacy.fbmod","PM Arcade STAR Wars.fbmod","PM IA Combat Engineer.fbmod","PM IA Clone Flametrooper by BlueNade.fbmod","PM IA Clone Sharpshooter.fbmod","PM IA Gungan Warrior by EldeBH and Priscilla.fbmod","PM IA Republic Gunner.fbmod","PM IA Aqua Droid by EldeBH and Priscilla.fbmod","PM IA Combat MagnaGuard by EldeBH and Priscilla.fbmod","PM IA MagnaGuard Protector by EldeBH and Priscilla.fbmod","PM IA Tactical Droid by EldeBH and Priscilla.fbmod","PM IA Honor Guard.fbmod","PM IA Rebel Commando.fbmod","PM IA Rebel Pilot.fbmod","PM IA Rebel Saboteur.fbmod","PM IA Purge Trooper Commander by EldeBH.fbmod","PM IA Royal Guard.fbmod","PM IA Shock Trooper.fbmod","PM IA Viper Probe Droid.fbmod","PM IA Combat Medic.fbmod","PM IA Smuggler.fbmod","PM IA Guavian Security by Darth Iron.fbmod","PM IA Riot Control Trooper.fbmod","PM IA Stormtrooper Commander.fbmod","PM IA Ahsoka Tano by Mandalo.fbmod","PM IA Captain Rex by BlueNade.fbmod","PM IA Commander Cody by BlueNade.fbmod","PM IA Hunter by BlueNade.fbmod","PM IA Padme Amidala by Acribro.fbmod","PM IA Asajj Ventress by AmWhitey - FegeeWaters - HammieFlap8D.fbmod","PM IA Jango Fett by DeggialNox.fbmod","PM IA Ben Kenobi by AmWhitey and Hammie.fbmod","PM IA Cal Kestis.fbmod","PM IA Din Djarin - The Mandalorian by AlexPo.fbmod","PM IA Nightsister Merrin.fbmod","PM IA Heroes Of The Outer Rim.fbmod","PM IA Dagan Gera.fbmod","PM IA Dengar.fbmod","PM IA Grand Admiral Thrawn by Aurel.fbmod","PM IA Second Sister.fbmod","PM IA Maz Kanata by Acribro.fbmod","PM IA Shriv Suurgav.fbmod","PM IA Captain Cardinal.fbmod","PM IA Commander Pyre.fbmod","PM IA Gideon Hask.fbmod","BF+ AI Enhanced.fbmod","Gamemode - Bounty Hunt.fbmod","PM IA Battlefront Gameplay Rework - Heroes.fbmod","PM IA Battlefront Gameplay Rework - Reinforcements.fbmod","IOI-V5.9.7.fbmod","PM IA Battlefront Gameplay Rework - Troopers.fbmod","PM IA New Appearances - Republic Troopers.fbmod","PM IA New Appearances - Separatist Troopers.fbmod","PM IA New Appearances - Rebel and Resistance Troopers.fbmod","PM IA New Appearances - Imperial Troopers.fbmod","PM IA New Appearances - Ewok Hunter.fbmod","PM IA New Appearances - First Order Troopers.fbmod","PM IA New Appearances - Heroes.fbmod","YES.fbmod","Zaddmospheric Lighting - Ajan Kloss.fbmod","Zaddmospheric Lighting - Crait.fbmod","Zaddmospheric Lighting - Felucia.fbmod","Zaddmospheric Lighting - Hoth.fbmod","Zaddmospheric Lighting - Jakku.fbmod","Zaddmospheric Lighting - Kamino.fbmod","Zaddmospheric Lighting - Kashyyyk.fbmod","Zaddmospheric Lighting - Naboo.fbmod","Zaddmospheric Lighting - SKB.fbmod","IOI Addon - Endor Ewok Village Improved.fbmod","EwokHuntLighting.fbmod","BF+ No Crait TrenchFade.fbmod","BF+ SpawnScreen Fix.fbmod","BF+ BGR - IOI Screens Patch.fbmod","BF+ Modded Skin Rarity Patch.fbmod","BF+ Affectors Shared Blueprints.fbmod","BF+ IsHeroHidden Shared.fbmod","BF+ Frontend Screens.fbmod","BF+ UnlockGroups.fbmod"],"modVersions":["Test Version 1","1.0","3.19.1","1.1","2.1","111024","1.0","Alpha-010125","Alpha-0.01","Alpha 0.2.5","3.8.4","1.5.0","1.8.5","2.0.4","3.2.4a","2.0.4","1.4.6","2.1.4","3.1.2","4.1.9","2.1.5","1.4.2","3.1.1","1.6.2","1.5.1","6.0.2","1.5.4","1.7.2","3.1.9","1.5.1","3.0.6","2.3.8","1.7.6","1.7.4","1.7.2a","1.5.0","1.7.0","1.2.5","1.1.0","1.3.4","1.9.8","2.4.0","1.3.0","1.4.4","1.3.6","1.5.6","1.5.8","1.7.7","1.6.0","1.5.3","2.0.9","2.0.7","1.5.4","021224","1.2.2","1.6.5","6.2.8","5.9.7","7.2.0","1.9.7","1.5.8","1.3.6","1.8.5","1.4.0","1.5.0","1.6.4","Beta 1.5","0.2","0.11","0.3","0.11","0.11","0.1","0.11","0.1","0.2","1.0","1.0","1.0","1.2","240924-1","1.2","021224","150824","171024","191224"]}""";
    final manifest = FrostyCollectionManifest.fromJson(
      jsonDecode(testJson) as Map<String, Object?>,
    );
    return FrostyCollectionWriter(FrostyCollection(manifest: manifest));
  }

  Uint8List write() {
    writeUint32(_kFrostyMagic);
    writeUint32(_kCollectionVersion);

    for (var i = 0; i < 5; i++) {
      writeUint32(0);
    }

    final manifestOffset = offset;
    final manifestBytes = utf8.encode(jsonEncode(collection.manifest.toJson()));
    writeByteData(ByteData.view(Uint8List.fromList(manifestBytes).buffer));
    final manifestSize = offset - manifestOffset;

    final iconOffset = offset;
    if (collection.icon != null) {
      writeByteData(ByteData.view(Uint8List.fromList(collection.icon!).buffer));
    }
    final iconSize = offset - iconOffset;

    final screenshotsOffset = offset;
    writeUint32(collection.screenshots.length);
    for (final screenshot in collection.screenshots) {
      writeUint32(screenshot.length);
      writeByteData(ByteData.view(Uint8List.fromList(screenshot).buffer));
    }

    final lastOffset = offset;

    offset = 8;
    writeUint32(manifestOffset);
    writeUint32(manifestSize);
    writeUint32(iconOffset);
    writeUint32(iconSize);
    writeUint32(screenshotsOffset);
    offset = lastOffset;

    return toBytes();
  }
}

class FrostyCollection {
  final FrostyCollectionManifest manifest;
  final List<int>? icon;
  final List<List<int>> screenshots;

  FrostyCollection({
    required this.manifest,
    this.icon,
    this.screenshots = const [],
  });
}
