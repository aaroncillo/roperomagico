// app/javascript/controllers/show_controller.js
import { Controller } from 'stimulus';

export default class extends Controller {
  connect() {
    $(document).ready(function() {
      // Verificar si el elemento ya existe antes de agregarlo
      if ($('#example_wrapper').length === 0) {
        var table = $('#example').DataTable({
          "order": [[0, "asc"]],
          "pagingType": "full_numbers",
          "pageLength": 5,
          "lengthMenu": [5, 10, 25, 50]
        });
        $("#searchBtn").on("click", function() {
          table.draw();
        });
      }
    });
  }
}
