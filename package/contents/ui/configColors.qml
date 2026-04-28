import QtQuick
import QtQuick.Dialogs
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
  id: colorsPage

  property alias cfg_colorDefault: colorDefault.color
  property alias cfg_colorRail: colorRail.color
  property alias cfg_colorBus: colorBus.color
  property alias cfg_colorTram: colorTram.color
  property alias cfg_colorMetro: colorMetro.color
  property alias cfg_colorWater: colorWater.color
  property alias cfg_colorAir: colorAir.color

  ColorDialog {
    id: colorDefault
    color: cfg_colorDefault
  }

  ColorDialog {
    id: colorRail
    color: cfg_colorRail
  }

  ColorDialog {
    id: colorBus
    color: cfg_colorBus
  }

  ColorDialog {
    id: colorTram
    color: cfg_colorTram
  }

  ColorDialog {
    id: colorMetro
    color: cfg_colorMetro
  }
  
  ColorDialog {
    id: colorWater
    color: cfg_colorWater
  }
  
  ColorDialog {
    id: colorAir
    color: cfg_colorAir
  }
}