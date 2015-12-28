var app = angular.module('app', []);

function mainController($scope, $http) {
   $scope.rows = [[{},{},{}],[{},{},{}],[{},{},{}]];
   $scope.dates = [];
   $scope.atEnd = true;
   $scope.currentDateIndex = -1;
   $scope.currentDate = "";

   $scope.refresh = function() {
      if($scope.currentDateIndex == -1)
         if($scope.dates.length>0) {
            $scope.currentDateIndex = $scope.dates.length-1;
            $scope.atEnd = true;
         } else {
            return;
         }

      $scope.currentDate =  $scope.dates[$scope.currentDateIndex];

      $http.get('/api/load/'+$scope.currentDate)
          .success(function(data) {
             console.log(data);
             for(var r=0;r<3;r++) {
                row = $scope.rows[r];
                for(var c=0;c<3;c++) {
                   row[c] = data[r*3+c];
                   row[c].src = "data/"+row[c].id+".gif";
                }
             }
             $scope.searchResult = data.items;
          })
          .error(function(data) {
             console.log('Error: ' + data);
          });
   };

   $scope.getDates = function() {
      $http.get('/api/list_dates')
         .success(function(data) {
            console.log(data);
            $scope.dates = data;
            $scope.refresh();
         })
         .error(function(data) {
           console.log('Error: ' + data);
         });
   };

   $scope.reset = function() {
      $scope.currentDateIndex = -1;
      $scope.refresh();
   }

   $scope.backward = function() {
      $scope.currentDateIndex -= 1;
      if($scope.currentDateIndex < 0)
         $scope.currentDateIndex = 0;
      $scope.refresh();
   }

   $scope.forward = function() {
      $scope.currentDateIndex += 1;
      if($scope.currentDateIndex >= ($scope.dates.length -1))
         $scope.currentDateIndex = -1;
      $scope.refresh();
   }

   $scope.getDates();
}
