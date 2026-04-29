import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami
import org.kde.kquickcontrols as KQuickControls

Kirigami.FormLayout {
  id: appearancePage

  
  property alias cfg_colorDefault: colorDefault.color
  property alias cfg_colorRail: colorRail.color
  property alias cfg_colorBus: colorBus.color
  property alias cfg_colorTram: colorTram.color
  property alias cfg_colorMetro: colorMetro.color
  property alias cfg_colorWater: colorWater.color
  property alias cfg_colorAir: colorAir.color

  KQuickControls.ColorButton {
    id: colorDefault
    color: appearancePage.cfg_colorDefault
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorDefault = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }

  KQuickControls.ColorButton {
    id: colorRail
    color: appearancePage.cfg_colorRail
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorRail = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }

  KQuickControls.ColorButton {
    id: colorBus
    color: appearancePage.cfg_colorBus
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorBus = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }

  KQuickControls.ColorButton {
    id: colorTram
    color: appearancePage.cfg_colorTram
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorTram = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }

  KQuickControls.ColorButton {
    id: colorMetro
    color: appearancePage.cfg_colorMetro
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorMetro = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }
  
  KQuickControls.ColorButton {
    id: colorWater
    color: appearancePage.cfg_colorWater
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorWater = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }

  KQuickControls.ColorButton {
    id: colorAir
    color: appearancePage.cfg_colorAir
    showAlphaChannel: false
    onColorChanged: {
      var hex = color.toString()
      appearancePage.cfg_colorAir = (hex.length === 9)
                      ? "#" + hex.substring(3)
                      : hex.substring(0, 7).toUpperCase()
    }
  }
}