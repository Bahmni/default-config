'use strict';

angular.module('bahmni.common.displaycontrol.custom')
  .service('erpService', ['$http', '$httpParamSerializer', 'sessionService', function($http, $httpParamSerializer, sessionService) {
    this.getOrder = function(id, representation) {
      var order = $http.get(Bahmni.Common.Constants.openmrsUrl + "/ws/rest/v1/erp/order/" + id + "?" + $httpParamSerializer({
        rep: representation
      }), {});
      return order;
    };
    this.getAllOrders = function(filters, representation) {
      var patientFilter = {
        "field": "uuid",
        "comparison": "=",
        "value": ""
      }
      var orders = $http.post(Bahmni.Common.Constants.openmrsUrl + "/ws/rest/v1/erp/order?" + $httpParamSerializer({
        rep: representation
      }), {
        filters: filters
      });
      return orders;
    };
    this.getInvoice = function(id, representation) {
      var invoice = $http.get(Bahmni.Common.Constants.openmrsUrl + "/ws/rest/v1/erp/invoice/" + id + "?" + $httpParamSerializer({
        rep: representation
      }), {});
      return invoice;
    };
    this.getAllInvoices = function(filters, representation) {
      var patientFilter = {
        "field": "uuid",
        "comparison": "=",
        "value": ""
      }
      var salesInvoiceFilter = {
        "field": "type",
        "comparison": "=",
        "value": "out_invoice"
      }
      filters.push(salesInvoiceFilter)
      var invoices = $http.post(Bahmni.Common.Constants.openmrsUrl + "/ws/rest/v1/erp/invoice?" + $httpParamSerializer({
        rep: representation
      }), {
        params: {
          rep: "full"
        },
        filters: filters
      });
      return invoices;
    };
  }]);
angular.module('bahmni.common.displaycontrol.custom')
  .directive('billingStatus', ['erpService', 'appService', 'spinner', '$q', function(erpService, appService, spinner, $q) {
    var link = function($scope) {
      $scope.contentUrl = appService.configBaseUrl() + "/customDisplayControl/views/billingStatus.html";
      var lines = [];
      $scope.lines = [];
      $scope.debug = [];
      const ORDER = "ORDER"
      const INVOICE = "INVOICE"
      const NON_INVOICED = "NON INVOICED"
      const FULLY_INVOICED = "FULLY_INVOICED"
      const PARTIALLY_INVOICED = "PARTIALLY_INVOICED"
      const PAID = "PAID"
      const NOT_PAID = "NOT_PAID"
      const OVERDUE = "OVERDUE"
      const NOT_OVERDUE = "NOT_OVERDUE"
      var retireLinesConditions = $scope.config.retireLinesConditions
      var nonApprovedConditions = $scope.config.nonApprovedConditions
      var approvedConditions = $scope.config.approvedConditions
      var ordersFilters = [];
      var invoicesFilters = [];
      erpService.getAllOrders(ordersFilters, "full").success(function(orders) {
        erpService.getAllInvoices(invoicesFilters, "full").success(function(invoices) {
          setTagsToOrderLines(orders);
          setTagsToInvoiceLines(invoices);
          setApprovalStatusToLines();
          $scope.lines = lines;
        });
      });
      var setApprovalStatusToLines = function() {
        lines.forEach(function(line) {
          line.approved = false;
          line.retire = false;
          approvedConditions.forEach(function(condition) {
            if (_.difference(condition, line.tags).length == 0) {
              line.approved = line.approved || true;
            }
          })
          nonApprovedConditions.forEach(function(condition) {
            if (_.difference(condition, line.tags).length == 0) {
              line.approved = line.approved || false;
            }
          })
          retireLinesConditions.forEach(function(condition) {
            if (_.difference(condition, line.tags).length == 0) {
              line.retire = line.retire || true;
            }
          })
        })
      };
      var setTagsToOrderLines = function(orders) {
        orders.forEach(function(order) {
          order.order_lines.forEach(function(line) {
            var tags = []
            tags.push(ORDER);
            if (line.qty_invoiced == 0) {
              tags.push(NON_INVOICED);
            } else if (line.qty_invoiced != 0 && line.qty_to_invoice != 0) {
              tags.push(PARTIALLY_INVOICED);
            } else if (line.qty_to_invoice == 0) {
              tags.push(FULLY_INVOICED);
            }
            lines.push({
              "id": line.id,
              "date": order.date_order,
              "document": order.name,
              "tags": tags,
              "displayName": line.display_name
            })
          })
        })
        return orders;
      };
      var setTagsToInvoiceLines = function(invoices) {
        invoices.forEach(function(invoice) {
          invoice.invoice_lines.forEach(function(line) {
            var tags = [];
            tags.push(INVOICE)
            if (invoice.state == "paid") {
              tags.push(PAID);
            } else {
              tags.push(NOT_PAID);
            }
            if (new Date(invoice.date_due).getDate() >= new Date().getDate()) {
              tags.push(OVERDUE);
            } else {
              tags.push(NOT_OVERDUE);
            }
            lines.push({
              "id": line.id,
              "date": invoice.date,
              "document": invoice.number,
              "tags": tags,
              "displayName": line.display_name
            })
          })
          return invoices;
        });
      };
    }
    return {
      restrict: 'E',
      link: link,
      template: '<ng-include src="contentUrl"/>'
    }
  }]);
angular.module('bahmni.common.displaycontrol.custom')
    .directive('birthCertificate', ['observationsService', 'appService', 'spinner', function (observationsService, appService, spinner) {
        var link = function ($scope) {
            console.log("inside birth certificate");
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

                var startDate = null,
                    endDate = null,
                    getEffectiveOrdersOnly = false;
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
                            treatmentSections.push({
                                visitDate: key,
                                drugOrders: values
                            });
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
    }]).directive('patientAppointmentsDashboard', ['$http', '$q', '$window', 'appService', function ($http, $q, $window, appService) {
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
                $scope.upcomingAppointmentsHeadings = _.keys($scope.upcomingAppointments[0]);
                $scope.pastAppointments = response[1].data;
                $scope.pastAppointmentsHeadings = _.keys($scope.pastAppointments[0]);
            });

            $scope.goToListView = function () {
                $window.open('/bahmni/appointments/#/home/manage/appointments/list');
            };
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
    }]);