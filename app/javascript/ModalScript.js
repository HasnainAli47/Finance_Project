
// JavaScript code to handle modal open/close
document.addEventListener("DOMContentLoaded", function() {
  const filterButton = document.getElementById("filterButton");
  const filterModal = document.getElementById("filterModal");

  filterButton.addEventListener("click", function() {
    filterModal.classList.remove("hidden");
  });

  filterModal.addEventListener("click", function(event) {
    if (event.target === filterModal) {
      filterModal.classList.add("hidden");
    }
  });
});
