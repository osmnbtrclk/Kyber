import 'package:kyber_launcher/gen/assets.gen.dart';

enum GameVehicle {
  armor,
  artillery,
  speeder,
  fighter,
  interceptor,
  bomber
  ;

  bool get isGroundVehicle =>
      this == GameVehicle.armor ||
      this == GameVehicle.artillery ||
      this == GameVehicle.speeder;

  SvgGenImage get icon {
    switch (this) {
      case GameVehicle.armor || GameVehicle.artillery || GameVehicle.speeder:
        return Assets.icons.classes.classVehicleGround;
      case GameVehicle.fighter:
        return Assets.icons.classes.classVehicleGunship;
      case GameVehicle.interceptor:
        return Assets.icons.classes.classVehicleInterceptor;
      case GameVehicle.bomber:
        return Assets.icons.classes.classVehicleBomber;
    }
  }

  String get thumbnail {
    switch (this) {
      case GameVehicle.armor:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-first-order-at-st-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
      case GameVehicle.artillery:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-mtt-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
      case GameVehicle.speeder:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-ski-speeder-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
      case GameVehicle.fighter:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-x-wing-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
      case GameVehicle.interceptor:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-rz1-a-wing-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
      case GameVehicle.bomber:
        return 'https://media.contentapi.ea.com/content/dam/star-wars-battlefront-2/images/2019/08/swbf2-refresh-hero-medium-vehicles-page-btl-a4-y-wing-7x2-xl.jpg.adapt.crop7x2.1920w.jpg';
    }
  }

  String get name {
    switch (this) {
      case GameVehicle.armor:
        return 'Ground Vehicle';
      case GameVehicle.speeder:
        return 'Speeder';
      case GameVehicle.artillery:
        return 'Artillery';
      case GameVehicle.fighter:
        return 'Fighter';
      case GameVehicle.interceptor:
        return 'Interceptor';
      case GameVehicle.bomber:
        return 'Bomber';
    }
  }

  String get prefix {
    switch (this) {
      case GameVehicle.armor:
        return 'c_avrallsfam_';
      case GameVehicle.speeder:
        return 'c_avrallsfsp_';
      case GameVehicle.artillery:
        return 'c_avrallsfar_';
      case GameVehicle.fighter:
        return 'c_avrmr_';
      case GameVehicle.interceptor:
        return 'c_avrint_';
      case GameVehicle.bomber:
        return 'c_avrbomb_';
    }
  }
}
