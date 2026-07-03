$(document).ready(function () {
  $("#menuToggle").on("click", function () {
    $("#sidebar").addClass("open");
    $("#sidebarOverlay").fadeIn();
  });

  $("#sidebarOverlay").on("click", function () {
    $("#sidebar").removeClass("open");
    $("#sidebarOverlay").fadeOut();
  });
});
