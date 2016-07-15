'use strict';
angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificates', ['$q','observationsService','appService', 'spinner','$sce', function ($q,observationsService, appService, spinner, $sce)
    {
        var link = function ($scope)
        {

            var conceptNames = ["Delivery Note, Liveborn infant details"];
            spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "previous", undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;


                }));
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/birthCertificatepo.html";
            $scope.curDate=new Date();


        };
        var controller = function($scope){
                $scope.htmlLabel = function(label){
                        return $sce.trustAsHtml(label)
                }
        }
        return {
            restrict: 'E',
            link: link,
            controller : controller,
            template: '<ng-include src="contentUrl"/>'
        }
    }]);