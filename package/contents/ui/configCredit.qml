import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import org.kde.kirigami as Kirigami

ColumnLayout {
    id: aboutPage

    spacing: Kirigami.Units.largeSpacing
    width: parent ? parent.width : implicitWidth

    Item {
        Layout.fillWidth: true
        Layout.preferredHeight: Kirigami.Units.largeSpacing
    }

    Rectangle {
      Layout.preferredWidth: (enturLogo.implicitWidth + 16)
      Layout.preferredHeight: (enturLogo.implicitHeight + 16)
      Layout.alignment: Qt.AlignHCenter
      radius: 5
      color: "#f6f6f9"

      Image {
        id: enturLogo
        source: Qt.resolvedUrl("../images/Enturlogo_Blue_RGB.svg")
        sourceSize.width: 220
        fillMode: Image.PreserveAspectFit
        Layout.preferredWidth: 220
        Layout.preferredHeight: 80
        anchors.centerIn: parent
      }
    }

    QQC2.Label {
        text: i18n("Public transport data provided by Entur.")
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    QQC2.Label {
        text: i18n('Visit <a href="https://entur.no/">entur.no</a>')
        textFormat: Text.RichText
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true

        onLinkActivated: function(link) {
            Qt.openUrlExternally(link)
        }
    }

    QQC2.Label {
        text: i18n("This widget is not affiliated with or endorsed by Entur.")
        opacity: 0.7
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    Kirigami.Separator {
        Layout.fillWidth: true
    }

    QQC2.Label {
        text: i18n("Plasma Entur Widget")
        font.bold: true
        horizontalAlignment: Text.AlignHCenter

        Layout.fillWidth: true
    }

    QQC2.Label {
        text: i18n("Shows upcoming public transport departures using Entur's open APIs.")
        opacity: 0.8
        horizontalAlignment: Text.AlignHCenter
        wrapMode: Text.WordWrap

        Layout.fillWidth: true
    }

    Item {
        Layout.fillHeight: true
    }
}