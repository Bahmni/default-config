
'use strict';
angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificates', ['$q','observationsService','appService', 'spinner','$sce', function ($q,observationsService, appService, spinner, $sce)
    {
        var link = function ($scope)
        {

            var conceptNames = ["Delivery Note, Liveborn infant details"];
            spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "previous", undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                                            if ($scope.observations==undefined)
                                            { 
                                                console.log("template not filled");
                                                return;
                                            }

	 	     $scope.birthCertificates = [];



                                        function createForm(obs, birthCertificate) {
                                               if (obs.groupMembers.length == 0){
                                                  if (birthCertificate[obs.conceptNameToDisplay] == undefined){
                                                     birthCertificate[""+obs.conceptNameToDisplay] = obs.valueAsString;
                                                  }
                                                  else{
                                                     birthCertificate[""+obs.conceptNameToDisplay] = birthCertificate[""+obs.conceptNameToDisplay] + ' ' + obs.valueAsString;
                                                  }

                                                  if(obs.comment != null){
                                                    birthCertificate[""+obs.conceptNameToDisplay] = birthCertificate[""+obs.conceptNameToDisplay] + ' ' + obs.comment;
                                                  }
                                               }
                                               else{
                                                  for(var i = 0; i < obs.groupMembers.length; i++) {
                                                       createForm(obs.groupMembers[i], birthCertificate);
                                                  }


                                               }

                            }



                            for(var j=0;j<response.data.length;j++){
                                var birthCertificate = [];
                                createForm(response.data[j], birthCertificate);
                                $scope.birthCertificates.push(birthCertificate);
                            }





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
