$(document).ready(function() {
  var refreshId = setInterval( function(){
    $.ajax(
      { url: "/status",
        dataType: "script",
      }
    )
  }, 1000  );
})
