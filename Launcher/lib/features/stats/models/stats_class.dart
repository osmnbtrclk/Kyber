import 'package:kyber_launcher/gen/assets.gen.dart';

enum GameClass {
  assault,
  heavy,
  officer,
  specialist,
  aerial,
  enforcer,
  infiltrator
  ;

  SvgGenImage get icon {
    switch (this) {
      case GameClass.assault:
        return Assets.icons.classes.classTroopersAssault01;
      case GameClass.heavy:
        return Assets.icons.classes.classTroopersHeavy01;
      case GameClass.officer:
        return Assets.icons.classes.classTroopersOfficer01;
      case GameClass.specialist:
        return Assets.icons.classes.classTroopersSpecialist01;
      case GameClass.aerial:
        return Assets.icons.classes.classJumpTrooper;
      case GameClass.enforcer:
        return Assets.icons.classes.classEnforcer;
      case GameClass.infiltrator:
        return Assets.icons.classes.classInfiltrator;
    }
  }

  String get thumbnail {
    switch (this) {
      case GameClass.assault:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-classes-page-assault-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.heavy:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-classes-page-heavy-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.officer:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/07/swbf2-refresh-hero-large-classes-page-officer-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.specialist:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-large-classes-page-specialist-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.aerial:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/11/swbf2-hero-large-reinforcement-aerial-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.enforcer:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/11/swbf2-hero-large-reinforcement-enforcer-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
      case GameClass.infiltrator:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/12/swbf2-hero-lg-reinforcements-page-infiltrator-16x9-xl.jpg.adapt.crop16x9.1920w.jpg';
    }
  }

  String get name {
    switch (this) {
      case GameClass.assault:
        return 'Assault';
      case GameClass.heavy:
        return 'Heavy';
      case GameClass.officer:
        return 'Officer';
      case GameClass.specialist:
        return 'Specialist';
      case GameClass.aerial:
        return 'Aerial';
      case GameClass.enforcer:
        return 'Enforcer';
      case GameClass.infiltrator:
        return 'Infiltrator';
    }
  }

  String get prefix {
    switch (this) {
      case GameClass.assault:
        return 'c_cta_';
      case GameClass.heavy:
        return 'c_cth_';
      case GameClass.officer:
        return 'c_cto_';
      case GameClass.specialist:
        return 'c_cts_';
      case GameClass.aerial:
        return 'c_chspallair_';
      case GameClass.enforcer:
        return 'c_chspallenf_';
      case GameClass.infiltrator:
        return 'c_chspallinf_';
    }
  }
}
