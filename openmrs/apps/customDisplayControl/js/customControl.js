'use strict';

angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
            var link = function ($scope) {
                var conceptNames = ["HEIGHT"];
                $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/birthCertificate.html";
                spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                    $scope.observations = response.data;
                }));
            };

            return {
                restrict: 'E',
                template: '<ng-include src="contentUrl"/>',
                link: link
            }
    }]).directive('deathCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
        var link = function ($scope) {
            var conceptNames = ["WEIGHT"];
            $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/deathCertificate.html";
            spinner.forPromise(observationsService.fetch($scope.patient.uuid, conceptNames, "latest", undefined, $scope.visitUuid, undefined).then(function (response) {
                $scope.observations = response.data;
            }));
        };

        return {
            restrict: 'E',
            link: link,
            template: '<ng-include src="contentUrl"/>'
        }
    }]).directive('customTreatmentChart', ['appService', 'treatmentConfig', 'TreatmentService', 'spinner', '$q', function (appService, treatmentConfig, treatmentService, spinner, $q) {
    var link = function ($scope) {
        var Constants = Bahmni.Clinical.Constants;
        var days = [
            'Sunday',
            'Monday',
            'Tuesday',
            'Wednesday',
            'Thursday',
            'Friday',
            'Saturday'
        ];
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/customTreatmentChart.html";

        $scope.atLeastOneDrugForDay = function (day) {
            var atLeastOneDrugForDay = false;
            $scope.ipdDrugOrders.getIPDDrugs().forEach(function (drug) {
                if (drug.isActiveOnDate(day.date)) {
                    atLeastOneDrugForDay = true;
                }
            });
            return atLeastOneDrugForDay;
        };

        $scope.getVisitStopDateTime = function () {
            return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
        };

        $scope.getStatusOnDate = function (drug, date) {
            var activeDrugOrders = _.filter(drug.orders, function (order) {
                if ($scope.config.frequenciesToBeHandled.indexOf(order.getFrequency()) !== -1) {
                    return getStatusBasedOnFrequency(order, date);
                } else {
                    return drug.getStatusOnDate(date) === 'active';
                }
            });
            if (activeDrugOrders.length === 0) {
                return 'inactive';
            }
            if (_.every(activeDrugOrders, function (order) {
                    return order.getStatusOnDate(date) === 'stopped';
                })) {
                return 'stopped';
            }
            return 'active';
        };

        var getStatusBasedOnFrequency = function (order, date) {
            var activeBetweenDate = order.isActiveOnDate(date);
            var frequencies = order.getFrequency().split(",").map(function (day) {
                return day.trim();
            });
            var dayNumber = moment(date).day();
            return activeBetweenDate && frequencies.indexOf(days[dayNumber]) !== -1;
        };

        var init = function () {
            var getToDate = function () {
                return $scope.visitSummary.stopDateTime || Bahmni.Common.Util.DateUtil.now();
            };

            var programConfig = appService.getAppDescriptor().getConfigValue("program") || {};

            var startDate = null, endDate = null, getEffectiveOrdersOnly = false;
            if (programConfig.showDetailsWithinDateRange) {
                startDate = $stateParams.dateEnrolled;
                endDate = $stateParams.dateCompleted;
                if (startDate || endDate) {
                    $scope.config.showOtherActive = false;
                }
                getEffectiveOrdersOnly = true;
            }

            return $q.all([treatmentConfig(), treatmentService.getPrescribedAndActiveDrugOrders($scope.config.patientUuid, $scope.config.numberOfVisits,
                $scope.config.showOtherActive, $scope.config.visitUuids || [], startDate, endDate, getEffectiveOrdersOnly)])
                .then(function (results) {
                    var config = results[0];
                    var drugOrderResponse = results[1].data;
                    var createDrugOrderViewModel = function (drugOrder) {
                        return Bahmni.Clinical.DrugOrderViewModel.createFromContract(drugOrder, config);
                    };
                    for (var key in drugOrderResponse) {
                        drugOrderResponse[key] = drugOrderResponse[key].map(createDrugOrderViewModel);
                    }

                    var groupedByVisit = _.groupBy(drugOrderResponse.visitDrugOrders, function (drugOrder) {
                        return drugOrder.visit.startDateTime;
                    });
                    var treatmentSections = [];

                    for (var key in groupedByVisit) {
                        var values = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(groupedByVisit[key]);
                        treatmentSections.push({visitDate: key, drugOrders: values});
                    }
                    if (!_.isEmpty(drugOrderResponse[Constants.otherActiveDrugOrders])) {
                        var mergedOtherActiveDrugOrders = Bahmni.Clinical.DrugOrder.Util.mergeContinuousTreatments(drugOrderResponse[Constants.otherActiveDrugOrders]);
                        treatmentSections.push({
                            visitDate: Constants.otherActiveDrugOrders,
                            drugOrders: mergedOtherActiveDrugOrders
                        });
                    }
                    $scope.treatmentSections = treatmentSections;
                    if ($scope.visitSummary) {
                        $scope.ipdDrugOrders = Bahmni.Clinical.VisitDrugOrder.createFromDrugOrders(drugOrderResponse.visitDrugOrders, $scope.visitSummary.startDateTime, getToDate());
                    }
                });
        };
        spinner.forPromise(init());
    };

    return {
        restrict: 'E',
        link: link,
        scope: {
            config: "=",
            visitSummary: '='
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).directive('patientAppointmentsDashboard', ['$http', '$q', '$window','appService', function ($http, $q, $window, appService) {
    var link = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/patientAppointmentsDashboard.html";
        var getUpcomingAppointments = function () {
            var params = {
                q: "bahmni.sqlGet.upComingAppointments",
                v: "full",
                patientUuid: $scope.patient.uuid
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };
        var getPastAppointments = function () {
            var params = {
                q: "bahmni.sqlGet.pastAppointments",
                v: "full",
                patientUuid: $scope.patient.uuid
            };
            return $http.get('/openmrs/ws/rest/v1/bahmnicore/sql', {
                method: "GET",
                params: params,
                withCredentials: true
            });
        };
        $q.all([getUpcomingAppointments(), getPastAppointments()]).then(function (response) {
            $scope.upcomingAppointments = response[0].data;
            for(let i=0; i < $scope.upcomingAppointments.length; i++){
                delete $scope.upcomingAppointments[i].DASHBOARD_APPOINTMENTS_PROVIDER_KEY;
                delete $scope.upcomingAppointments[i].DASHBOARD_APPOINTMENTS_STATUS_KEY;
                $scope.upcomingAppointments[i].DASHBOARD_APPOINTMENTS_SLOT_KEY = $scope.setBlock($scope.upcomingAppointments[i].DASHBOARD_APPOINTMENTS_SLOT_KEY)
            }
            $scope.upcomingAppointmentsHeadings = _.keys($scope.upcomingAppointments[0]);
            $scope.pastAppointments = response[1].data;
            for(let i=0; i < $scope.pastAppointments.length; i++){
                delete $scope.pastAppointments[i].DASHBOARD_APPOINTMENTS_PROVIDER_KEY;
                delete $scope.pastAppointments[i].DASHBOARD_APPOINTMENTS_STATUS_KEY;
                $scope.pastAppointments[i].DASHBOARD_APPOINTMENTS_SLOT_KEY = $scope.setBlock($scope.pastAppointments[i].DASHBOARD_APPOINTMENTS_SLOT_KEY)
            }
            $scope.pastAppointmentsHeadings = _.keys($scope.pastAppointments[0]);
        });

        $scope.goToListView = function () {
            $window.open('/bahmni/appointments/#/home/manage/appointments/list');
        };

        $scope.setBlock = function (timeInterval) {
            if(timeInterval === "12:00 AM - 8:59 AM"){
                return "APP_BLOCK_1"
            } else
            if(timeInterval === "9:00 AM - 11:59 AM" ){
                return "APP_BLOCK_2"
            } else
            if(timeInterval === "12:00 PM - 3:29 PM" ){
                return "APP_BLOCK_3"
            } else {
                return "APP_BLOCK_4"
            }
        }
    };
    return {
        restrict: 'E',
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    };
}]).directive('positivePreventionDashboard', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
    var link = function ($scope) {
        var patientUuid = $scope.patient.uuid;
        var conceptNames = $scope.section.conceptNames;
        var scope = undefined;
        var visitUuid = undefined;
        var obsIgnoreList = undefined;
        var filterObsWithOrders = undefined;
        var patientProgramUuid = undefined;

        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/positivePreventionDashboard.html";
        spinner.forPromise(observationsService.fetch(patientUuid, conceptNames, scope, 0, visitUuid, obsIgnoreList, filterObsWithOrders, patientProgramUuid).then(function (response) {
            var apiVisits = 0;

            $scope.observations = response.data;
            if($scope.section.conceptsWithYes.length > 0){
                $scope.section.visitDomId = [];
                $scope.section.visitDateTime = [];
                $scope.section.conceptsWithYes = [];
            }
            $scope.observations.forEach(observation => {
                var groupMembersWithYes = [];

                observation.groupMembers.forEach(member => {
                    if(member.value.name.endsWith('_Yes')){
                        groupMembersWithYes.push(member.conceptNameToDisplay);
                    }
                })

                if(groupMembersWithYes.length > 0){
                    $scope.section.visitDateTime.push(observation.observationDateTime);
                    $scope.section.conceptsWithYes.push(groupMembersWithYes);
                    if(apiVisits === 0){
                        $scope.section.isOpen.push(true);
                    }else{
                        $scope.section.isOpen.push(false);
                    }
                    apiVisits += 1;
                }
            });
        }));
    };

    return {
        restrict: 'E',
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).controller('PositivePreventionDetailsController', ['$scope',function ($scope) {
    $scope.title = $scope.ngDialogData.title;
    $scope.visitsList = $scope.ngDialogData.visitDateTime;
    $scope.conceptsWithYes = $scope.ngDialogData.conceptsWithYes;
    $scope.isOpen = $scope.ngDialogData.isOpen;

    $scope.isOpen.forEach(function (value, index) {
        if(index === 0){
            value = true;
            $scope.isOpen[index] = true;
        }else{
            value = false;
            $scope.isOpen[index] = false;
        }
    });
}]).directive('confidentDetails', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
    var link = function ($scope) {
        var patientUuid = $scope.patient.uuid;
        var conceptNames = $scope.section.conceptNames;
        var scope = undefined;
        var visitUuid = undefined;
        var obsIgnoreList = undefined;
        var filterObsWithOrders = undefined;
        var patientProgramUuid = undefined;

        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/confidentDetails.html";
        spinner.forPromise(observationsService.fetch(patientUuid, conceptNames, scope, 0, visitUuid, obsIgnoreList, filterObsWithOrders, patientProgramUuid).then(function (response) {
            var apiVisits = 0;
            $scope.observations = response.data;

            if($scope.section.confidentDetailsData.length > 0){
                $scope.section.visitDomId = [];
                $scope.section.visitDateTime = [];
                $scope.section.confidentDetailsData = [];
            }

            $scope.observations.forEach(observation => {
                var groupMembersConfidentName = [];
                var groupMembersConfidentSurname = [];
                var groupMembersConfidentTelephone = [];
                var groupMembersConfidentRelationship = [];

                observation.groupMembers.forEach(member => {
                    if (member.concept.name === "CONFIDENT_NAME"){
                        groupMembersConfidentName.push(member);
                    }
                    if (member.concept.name === "CONFIDENT_SURNAME"){
                        groupMembersConfidentSurname.push(member);
                    }
                    if (member.concept.name === "CONFIDENT_RELATIONSHIP"){
                        groupMembersConfidentRelationship.push(member);
                    }
                    if (member.concept.name === "CONFIDENT_TELEPHONE1"){
                        groupMembersConfidentTelephone.push(member);
                    }
                })

                if (groupMembersConfidentName || groupMembersConfidentSurname || groupMembersConfidentRelationship || groupMembersConfidentTelephone) {
                    $scope.section.visitDateTime.push(observation.observationDateTime);
                    $scope.section.confidentDetailsData.push(groupMembersConfidentName.concat(groupMembersConfidentSurname).concat(groupMembersConfidentRelationship).concat(groupMembersConfidentTelephone));
                    if (apiVisits === 0) {
                        $scope.section.isOpen.push(true);
                    } else {
                        $scope.section.isOpen.push(false);
                    }
                    apiVisits += 1;
                }
            });
        }));
    };

    return {
        restrict: 'E',
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).controller('ConfidentDetailsController', ['$scope',function ($scope) {
    $scope.title = $scope.ngDialogData.title;
    $scope.visitsList = $scope.ngDialogData.visitDateTime;
    $scope.confidentDetailsData = $scope.ngDialogData.confidentDetailsData;
    $scope.isOpen = $scope.ngDialogData.isOpen;

    $scope.isOpen.forEach(function (value, index) {
        console.log(index);
        if(index === 0){
            value = true;
            $scope.isOpen[index] = true;
        }else{
            value = false;
            $scope.isOpen[index] = false;
        }
    });
    }]

).directive('labResultsDashboard', ['labOrderResultService', 'appService', 'spinner', function (labOrderResultService, appService, spinner) {
    var link = function ($scope) {
        $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/labResultsDashboard.html";

        var defaultParams = {
            showTable: true,
            showChart: true,
            numberOfVisits: 0
        };

        $scope.params = angular.extend(defaultParams, $scope.params);
        $scope.section.params = angular.extend(defaultParams, $scope.params);

        var params = {
            patientUuid: $scope.patient.uuid,
            numberOfVisits: defaultParams.numberOfVisits,
            visitUuids: $scope.params.visitUuids,
            initialAccessionCount: $scope.params.initialAccessionCount,
            latestAccessionCount: $scope.params.latestAccessionCount
        };

        var apiVisits = 0;

        if($scope.section.accessions.length > 0){
            $scope.section.visitDateTime = [];
            $scope.section.accessions = [];
        }

        spinner.forPromise(labOrderResultService.getAllForPatient(params).then(function (results) {
            $scope.section.labAccessions = results.labAccessions;
            $scope.section.tabular = results.tabular;

            results.labAccessions.forEach(accessionsByDate => {
                var accessionDateLevel = [];
                accessionsByDate.forEach(accession => {
                    accessionDateLevel.push(accession.orderName);
                });

                if(accessionDateLevel.length > 0){
                    $scope.section.visitDateTime.push(accessionsByDate[0].accessionDateTime);
                    $scope.section.accessions.push(accessionDateLevel);
                    if(apiVisits === 0){
                        $scope.section.isOpen.push(true);
                    }else{
                        $scope.section.isOpen.push(false);
                    }
                    apiVisits += 1;
                }
            });
            
        }));
    };

    return {
        restrict: 'E',
        link: link,
        scope: {
            patient: "=",
            section: "="
        },
        template: '<ng-include src="contentUrl"/>'
    }
}]).controller('LabResultsDashboardController', ['$scope',function ($scope) {
    var accessionConfig = {
        initialAccessionCount: undefined,
        latestAccessionCount: undefined
    };

    $scope.tabular = new Bahmni.Clinical.TabularLabOrderResults($scope.ngDialogData.tabular.tabularResult, accessionConfig);
    $scope.title = $scope.ngDialogData.title;
    $scope.showChart = $scope.ngDialogData.showChart;
    $scope.showTable = $scope.ngDialogData.showTable;
    $scope.visitsList = $scope.ngDialogData.visitDateTime;
    $scope.accessions = $scope.ngDialogData.accessions;
    $scope.labAccessions = $scope.ngDialogData.labAccessions;
    $scope.params = $scope.ngDialogData.params;
}])
