import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
  id: generalPage

  property alias cfg_stopPlaceId: stopPlaceId.text
  property alias cfg_numberOfDepartures: departuresSpinBox.value
  property alias cfg_refreshInterval: refreshSpinBox.value
  property alias cfg_showDestination: showDestinationCheckBox.checked
  property alias cfg_showLineCode: showLineCodeCheckBox.checked

  property var placeSearchResults: []
  property string placeSearchStatus: ""
  property bool selectingPlace: false

  function searchStops(text) {
    if (!text || text.length < 2){
      placeSearchResults = []
      placeSearchStatus = ""
      return
    }

    placeSearchStatus = i18n("Searching...")

    var xhr = new XMLHttpRequest()
    var url = "https://api.entur.io/geocoder/v1/autocomplete"
              + "?text=" + encodeURIComponent(text)
              + "&lang=no"
              + "&size=8"
              + "&layers=venue"
    
    xhr.open("GET", url)
    xhr.setRequestHeader("ET-Client-Name", "thomasbirk-plasmaEnturWidget")

    xhr.onreadystatechange = function () {
      if (xhr.readyState !== XMLHttpRequest.DONE) {
        return
      }

      if (xhr.status !== 200) {
        placeSearchResults = []
        placeSearchStatus = i18n("Entur error: HTTP ") + xhr.status
        return
      }

      try {
        var json = JSON.parse(xhr.responseText)
        placeSearchResults = json.features || []
        placeSearchStatus = placeSearchResults.length > 0
            ? ""
            : i18n("No stops found")
      } catch (e) {
        placeSearchResults = []
        placeSearchStatus = i18n("Could not parse response")
        console.log(e)
      }
    }

    xhr.send()
  }

  QQC2.TextField {
    id: stopSearchField
    Kirigami.FormData.label: i18n("Search stop:")
    placeholderText: i18n("Example: Oslo S, Bergen busstasjon")

    onTextChanged: {
      if (!generalPage.selectingPlace) {
        searchDelay.restart()
      }
    }
  }

  Timer {
    id: searchDelay
    interval: 500
    repeat: false
    onTriggered: generalPage.searchStops(stopSearchField.text)
  }

  QQC2.Label {
    visible: generalPage.placeSearchStatus.length > 0
    text: generalPage.placeSearchStatus
  }

  ListView {
    Kirigami.FormData.label: i18n("Results:")
    visible: generalPage.placeSearchResults.length > 0
    model: generalPage.placeSearchResults
    implicitHeight: Math.min(contentHeight, 220)
    Layout.fillWidth: true
    clip: true

    delegate: QQC2.ItemDelegate {
      width: ListView.view.width
      text: {
        var label = modelData.properties && modelData.properties.label
                    ? modelData.properties.label
                    : "Unknown"

        var id = modelData.properties && modelData.properties.id
                    ? modelData.properties.id
                    : ""
        return id ? label + "  ->  " + id : label
      }
      onClicked: {
        if (modelData.properties && modelData.properties.id) {
          generalPage.selectingPlace = true

          stopPlaceId.text = modelData.properties.id
          stopSearchField.text = modelData.properties.label || ""

          generalPage.placeSearchResults = []
          generalPage.placeSearchStatus = ""
          generalPage.selectingPlace = false
        }
      }
    }
  }

  QQC2.TextField {
    id: stopPlaceId
    Kirigami.FormData.label: i18n("Stop place ID:")
    placeholderText: "NSR:StopPlace:59872"
  }

  QQC2.SpinBox {
    id: departuresSpinBox
    Kirigami.FormData.label: i18n("Departures:")
    from: 1
    to: 20
  }

  QQC2.SpinBox {
    id: refreshSpinBox
    Kirigami.FormData.label: i18n("Refresh interval:")
    from: 15
    to: 3600
    stepSize: 15
    textFromValue: function(value) {
      return value + " s"
    }
    valueFromText: function(text) {
      return parseInt(text)
    }
  }

  QQC2.CheckBox {
    id: showLineCodeCheckBox
    text: i18n("Show line code")
  }

  QQC2.CheckBox {
    id: showDestinationCheckBox
    text: i18n("Show destination")
  } 
}