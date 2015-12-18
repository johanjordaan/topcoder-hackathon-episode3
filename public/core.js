// public/core.js
var scotchTodo = angular.module('scotchTodo', []);

function mainController($scope, $http) {
   $scope.searchString = "";

   $scope.searchResult = []

   $scope.search = function() {
      $http.post('/api/search', $scope.searchForm)
          .success(function(data) {
             console.log(data);
             $scope.searchResult = data.items;
          })
          .error(function(data) {
             console.log('Error: ' + data);
          });
   };
}
