// app/javascript/controllers/daterangepicker_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    new DateRangePicker(this.element, {
      alwaysShowCalendars: true,
      autoApply: true,
      ranges: {
          'Today': [moment().startOf('day'), moment().endOf('day')],
          'Yesterday': [moment().subtract(1, 'days').startOf('day'), moment().subtract(1, 'days').endOf('day')],
          'Last 7 Days': [moment().subtract(6, 'days').startOf('day'), moment().endOf('day')],
          'This Month': [moment().startOf('month').startOf('day'), moment().endOf('month').endOf('day')],
          'All time': [moment('2010-11-15'), moment()],
      },
    })
  }
}
