import QtQuick
import QtQuick.Layouts
import org.kde.plasma.plasmoid
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

PlasmoidItem {
  id: root

  Plasmoid.backgroundHints: PlasmaCore.Types.ShadowBackground
                          | PlasmaCore.Types.ConfigurableBackground

  // Local properties general
  property string stopPlaceId: plasmoid.configuration.stopPlaceId
  property int numberOfDepartures: plasmoid.configuration.numberOfDepartures
  property int refreshInterval: plasmoid.configuration.refreshInterval
  property bool showDestination: plasmoid.configuration.showDestination
  property bool showLineCode: plasmoid.configuration.showLineCode

  // Data
  property string statusText: ""
  property var departures: []


  // 
  preferredRepresentation: fullRepresentation

  function formatTime(isoString) {
    if (!isoString) {
      return "-"
    }

    var date = new Date(isoString)
    return Qt.formatTime(date)
  }

  function fetchDepartures() {
    statusText = "Loading…"

    var query = `
      query Departures($id: String!, $numberOfDepartures: Int!) {
        stopPlace(id: $id) {
          name
          estimatedCalls(timeRange: 72100, numberOfDepartures: $numberOfDepartures) {
            realtime
            aimedDepartureTime
            expectedDepartureTime
            destinationDisplay {
              frontText
            }
            serviceJourney {
              journeyPattern {
                line {
                  publicCode
                  name
                  transportMode
                }
              }
            }
          }
        }
      }
    `

    const body = JSON.stringify({
      query: query,
      variables: {
        id: root.stopPlaceId,
        numberOfDepartures: root.numberOfDepartures
      }
    })

    const xhr = new XMLHttpRequest()
    xhr.open("POST", "https://api.entur.io/journey-planner/v3/graphql")
    xhr.setRequestHeader("Content-Type", "application/json")
    xhr.setRequestHeader("ET-Client-Name", "thomasbirk-plasmaEnturWidget")

    xhr.onreadystatechange = function () {
      if (xhr.readyState !== XMLHttpRequest.DONE) {
          return
      }

      if (xhr.status !== 200) {
          statusText = "Entur error: HTTP " + xhr.status
          departures = []
          return
      }

      try {
        const json = JSON.parse(xhr.responseText)

        if (json.errors && json.errors.length > 0) {
          statusText = "GraphQL error"
          console.log(JSON.stringify(json.errors))
          departures = []
          return
        }

        const stopPlace = json.data.stopPlace

        if (!stopPlace) {
          statusText = "Stop not found"
          departures = []
          return
        }

        departures = stopPlace.estimatedCalls || []
        statusText = stopPlace.name || "Departures"
      } catch (e) {
        statusText = "Could not parse Entur response"
        departures = []
        console.log(e)
      }
    }

    xhr.send(body)
  }

  function transportStyle(mode) {
    if (!mode) {
      return {
        color: plasma.configuration.colorDefault,
        icon: Qt.resolvedUrl("../icons/question-circle-fill.svg")
      }
    }

    switch (mode.toLowerCase()) {
      case "rail":
        return {
          color: plasmoid.configuration.colorRail,
          icon: Qt.resolvedUrl("../icons/train-front-fill.svg")
        }
      case "bus":
        return {
          color: plasmoid.configuration.colorBus,
          icon: Qt.resolvedUrl("../icons/bus-front-fill.svg")
        }
      case "tram":
        return {
          color: plasmoid.configuration.colorTram,
          icon: ""
        }
      case "metro":
        return {
          color: plasmoid.configuration.colorMetro,
          icon: ""
        } 
      case "water":
        return {
          color: plasmoid.configuration.colorWater,
          icon: ""
        }
      case "air":
        return {
          color: plasmoid.configuration.colorAir,
          icon: Qt.resolvedUrl("../icons/airplane-fill.svg")
        }
      default:
        return {
          color: plasmoid.configuration.colorDefault,
          icon: Qt.resolvedUrl("../icons/question-circle-fill.svg")
        }
      
    }
  }

  function lineFromCall(call) {
    if (call
        && call.serviceJourney
        && call.serviceJourney.journeyPattern
        && call.serviceJourney.journeyPattern.line
    ) {
      return call.serviceJourney.journeyPattern.line
    }

    return null
  }

  function lineCodeFromCall(call) {
    var line = lineFromCall(call)
    return line && line.publicCode ? line.publicCode : "..."
  }

  function transportModeFromCall(call) {
    var line = lineFromCall(call)
    return line && line.transportMode ? line.transportMode : ""
  }

  Timer {
    id: refreshTimer
    interval: root.refreshInterval *1000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: root.fetchDepartures()
  }

  Connections {
    target: plasmoid.configuration

    function onStopPlaceIdChanged() {
      root.fetchDepartures()
    }

    function onNumberOfDeparturesChanged() {
      root.fetchDepartures()
    }

    function onRefreshIntervalChanged() {
      refreshTimer.restart()
    }
  }

  fullRepresentation: ColumnLayout {
    spacing: 6

    // Header
    PlasmaComponents.Label {
      id: display_status
      text: root.statusText
      font.bold: true
      Layout.fillWidth: true
      elide: Text.ElideRight
    }

    // List with departures
    Repeater {
      model: root.departures

      delegate: RowLayout {
        Layout.fillWidth: true
        spacing: 8

        // Line code
        Rectangle {
          id: lineCodeBox
          visible: root.showLineCode
          Layout.preferredWidth: (lineCodeRow.implicitWidth + 16)
          Layout.preferredHeight: 24
          radius: 5

          property string transportMode: root.transportModeFromCall(modelData)
          property var modeStyle: root.transportStyle(transportMode)

          color: lineCodeBox.modeStyle.color

          RowLayout {
            id: lineCodeRow
            anchors.centerIn: parent
            spacing: 8

            Kirigami.Icon {
              visible: lineCodeBox.modeStyle.icon !== ""
              source: lineCodeBox.modeStyle.icon
              Layout.preferredWidth: (lineCodeLabel.implicitHeight - 4)
              Layout.preferredHeight: (lineCodeLabel.implicitHeight - 4)
              color: "white"
            }

            PlasmaComponents.Label {
              id: lineCodeLabel
              text: root.lineCodeFromCall(modelData)
              color: "white"
              font.bold: true
            }
          }

        }

        // Destination
        PlasmaComponents.Label {
          visible: root.showDestination
          text: modelData.destinationDisplay
                ? modelData.destinationDisplay.frontText
                : "..."
          Layout.fillWidth: true
          elide: Text.ElideRight
        }

        // Time
        PlasmaComponents.Label {
          text: formatTime(modelData.expectedDepartureTime || modelData.aimedDepartureTime)
        }
      }
    }

  }

}