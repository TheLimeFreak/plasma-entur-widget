import QtQuick
import org.kde.plasma.configuration

ConfigModel {
  ConfigCategory {
    name: i18n("General")
    icon: "configure"
    source: "config/configGeneral.qml"
  }

  ConfigCategory {
    name: i18n("Appearance")
    icon: "applications-graphics"
    source: "config/configAppearance.qml"
  }

  ConfigCategory {
    name: i18n("Credit")
    icon: "help-about"
    source: "config/configCredit.qml"
  }
}