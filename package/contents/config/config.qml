import QtQuick
import org.kde.plasma.configuration

ConfigModel {
  ConfigCategory {
    name: i18n("General")
    icon: "configure"
    source: "configGeneral.qml"
  }

  ConfigCategory {
    name: i18n("Colors")
    icon: "applications-graphics"
    source: "configColors.qml"
  }

  ConfigCategory {
    name: i18n("Credit")
    icon: "help-about"
    source: "configCredit.qml"
  }
}