// [WriteFile Name=ServiceFeatureTable_ManualCache, Category=Features]
// [Legal]
// Copyright 2016 Esri.

// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0

// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// [Legal]

import QtQuick 2.6
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import Esri.ArcGISRuntime 100.4
import Esri.ArcGISExtras 1.1

Rectangle {
    width: 800
    height: 600

    property real scaleFactor: System.displayScaleFactor

    // Map view UI presentation at top
    MapView {
        id: mv

        anchors.fill: parent
        wrapAroundMode: Enums.WrapAroundModeDisabled

        Map {
            BasemapTopographic {}
            initialViewpoint: viewPoint

            FeatureLayer {
                id: featureLayer

                ServiceFeatureTable {
                    id: featureTable
                    url: "https://sampleserver6.arcgisonline.com/arcgis/rest/services/SF311/FeatureServer/0"
                    featureRequestMode: Enums.FeatureRequestModeManualCache

                    onPopulateFromServiceStatusChanged: {
                        if (populateFromServiceStatus === Enums.TaskStatusCompleted) {
                            if (!populateFromServiceResult.iterator.hasNext) {
                                return;
                            }

                            var count = populateFromServiceResult.iterator.features.length;
                            console.log("Retrieved %1 features".arg(count));
                        }
                    }
                }
            }
        }

        ViewpointCenter {
            id: viewPoint
            center: Point {
                x: -13630484
                y: 4545415
                spatialReference: SpatialReference {
                    wkid: 102100
                }
            }
            targetScale: 300000
        }
    }

    QueryParameters {
        id: params
        whereClause: "req_Type = \'Tree Maintenance or Damage\'"
    }

    Row {
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
            margins: 5 * scaleFactor
            bottomMargin: 25 * scaleFactor
        }
        spacing: 5

        // button to populate from service
        Button {
            text: "Populate"
            enabled: featureTable.loadStatus === Enums.LoadStatusLoaded
            onClicked: {
                featureTable.populateFromService(params, true, ["*"]);
            }
        }
    }
}
