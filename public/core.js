var app = angular.module('app', []);

function mainController($scope, $http) {
   $scope.searchString = "";

   $scope.rows = [[{},{},{}],[{},{},{}],[{},{},{}]]

   $scope.refresh = function() {
      $http.get('/api/load/20151226')
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

   $scope.refresh();
}
