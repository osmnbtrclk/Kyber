import 'package:kyber_launcher/gen/assets.gen.dart';

enum GameHero {
  bobaFett,
  bossk,
  darthVader,
  emperor,
  grievous,
  iden,
  kyloRen,
  maul,
  phasma,
  dooku,
  bb9E,
  chewbacca,
  hanSolo,
  lando,
  leia,
  luke,
  rey,
  yoda,
  finn,
  obiWan,
  anakin,
  bb8
  ;

  bool get isLightSide {
    switch (this) {
      case GameHero.bobaFett:
      case GameHero.bossk:
      case GameHero.darthVader:
      case GameHero.emperor:
      case GameHero.grievous:
      case GameHero.iden:
      case GameHero.kyloRen:
      case GameHero.maul:
      case GameHero.phasma:
      case GameHero.dooku:
      case GameHero.bb9E:
        return false;
      default:
        return true;
    }
  }

  AssetGenImage get portrait {
    switch (this) {
      case GameHero.bobaFett:
        return Assets.icons.heroes.portraitBobaFett;
      case GameHero.bossk:
        return Assets.icons.heroes.portraitBossk;
      case GameHero.darthVader:
        return Assets.icons.heroes.portraitDarthVader;
      case GameHero.emperor:
        return Assets.icons.heroes.portraitPalpatine;
      case GameHero.grievous:
        return Assets.icons.heroes.portraitGrievous;
      case GameHero.iden:
        return Assets.icons.heroes.portraitIdenVersio;
      case GameHero.kyloRen:
        return Assets.icons.heroes.portraitKyloRen;
      case GameHero.maul:
        return Assets.icons.heroes.portraitDarthMaul;
      case GameHero.phasma:
        return Assets.icons.heroes.portraitPhasma;
      case GameHero.dooku:
        return Assets.icons.heroes.portraitDooku;
      case GameHero.bb9E:
        return Assets.icons.heroes.portraitBB9E;
      case GameHero.chewbacca:
        return Assets.icons.heroes.portraitChewbacca;
      case GameHero.hanSolo:
        return Assets.icons.heroes.portraitHanSolo;
      case GameHero.lando:
        return Assets.icons.heroes.portraitLandoCalrissian;
      case GameHero.leia:
        return Assets.icons.heroes.portraitLeiaOrgana;
      case GameHero.luke:
        return Assets.icons.heroes.portraitLukeSkywalker;
      case GameHero.rey:
        return Assets.icons.heroes.portraitRey;
      case GameHero.yoda:
        return Assets.icons.heroes.portraitYoda;
      case GameHero.finn:
        return Assets.icons.heroes.portraitFinn;
      case GameHero.obiWan:
        return Assets.icons.heroes.portraitObiWan;
      case GameHero.anakin:
        return Assets.icons.heroes.portraitAnakin;
      case GameHero.bb8:
        return Assets.icons.heroes.portraitBB8;
    }
  }

  String get thumbnail {
    switch (this) {
      case GameHero.anakin:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-anakin-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.obiWan:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-obi-wan-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.yoda:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-yoda-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.maul:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-darth-maul-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.dooku:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-dooku-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.grievous:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-grievous-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.luke:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-luke-skywalker-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.leia:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-leia-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.hanSolo:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-han-solo-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.chewbacca:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-chewie-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.lando:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-lando-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.darthVader:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-darth-vader-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.emperor:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-emperor-palpatine-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.iden:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-iden-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.bobaFett:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-boba-fett-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.bossk:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-bossk-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.rey:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-rey-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.finn:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-finn-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.kyloRen:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-kylo-ren-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.phasma:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-heroes-page-phasma-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.bb9E:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2020/01/swbf2-hero-lg-hero-bb-8-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameHero.bb8:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2020/01/swbf2-hero-lg-hero-bb-9e-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
    }
  }

  String get name {
    switch (this) {
      case GameHero.bobaFett:
        return 'Boba Fett';
      case GameHero.bossk:
        return 'Bossk';
      case GameHero.darthVader:
        return 'Darth Vader';
      case GameHero.emperor:
        return 'Emperor';
      case GameHero.grievous:
        return 'Grievous';
      case GameHero.iden:
        return 'Iden';
      case GameHero.kyloRen:
        return 'Kylo Ren';
      case GameHero.maul:
        return 'Maul';
      case GameHero.phasma:
        return 'Phasma';
      case GameHero.dooku:
        return 'Dooku';
      case GameHero.bb9E:
        return 'BB9E';
      case GameHero.chewbacca:
        return 'Chewbacca';
      case GameHero.hanSolo:
        return 'Han Solo';
      case GameHero.lando:
        return 'Lando';
      case GameHero.leia:
        return 'Leia';
      case GameHero.luke:
        return 'Luke';
      case GameHero.rey:
        return 'Rey';
      case GameHero.yoda:
        return 'Yoda';
      case GameHero.finn:
        return 'Finn';
      case GameHero.obiWan:
        return 'Obi Wan';
      case GameHero.anakin:
        return 'Anakin';
      case GameHero.bb8:
        return 'BB8';
    }
  }

  // String get portrait {
  //   String getFileName(String name) {
  //     switch (this) {
  //       case GameHero.emperor:
  //         return "Palpatine";
  //       case GameHero.iden:
  //         return "IdenVersio";
  //       case GameHero.maul:
  //         return "DarthMaul";
  //       case GameHero.lando:
  //         return "LandoCalrissian";
  //       case GameHero.leia:
  //         return "LeiaOrgana";
  //       case GameHero.luke:
  //         return "LukeSkywalker";
  //       default:
  //         return name.replaceAll(" ", "");
  //     }
  //   }
  //
  //   return "heros/Portrait_${getFileName(name)}.png";
  // }

  String get prefix {
    switch (this) {
      case GameHero.bobaFett:
        return 'c_chbf_';
      case GameHero.bossk:
        return 'c_chbo_';
      case GameHero.darthVader:
        return 'c_chdv_';
      case GameHero.emperor:
        return 'c_chem_';
      case GameHero.grievous:
        return 'c_chgr_';
      case GameHero.iden:
        return 'c_cgid_';
      case GameHero.kyloRen:
        return 'c_chkr_';
      case GameHero.maul:
        return 'c_chma_';
      case GameHero.phasma:
        return 'c_chph_';
      case GameHero.dooku:
        return 'c_chdo_';
      case GameHero.bb9E:
        return 'c_ch9e_';
      case GameHero.chewbacca:
        return 'c_chch_';
      case GameHero.hanSolo:
        return 'c_chhs_';
      case GameHero.lando:
        return 'c_chla_';
      case GameHero.leia:
        return 'c_chle_';
      case GameHero.luke:
        return 'c_chlu_';
      case GameHero.rey:
        return 'c_chre_';
      case GameHero.yoda:
        return 'c_chyo_';
      case GameHero.finn:
        return 'c_chfi_';
      case GameHero.obiWan:
        return 'c_chob_';
      case GameHero.anakin:
        return 'c_chan_';
      case GameHero.bb8:
        return 'c_chbb_';
      default:
        return '';
    }
  }
}
