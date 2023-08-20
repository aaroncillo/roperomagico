// app/javascript/controllers/daterangepicker_controller.js
import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    new DateRangePicker(this.element, {
      alwaysShowCalendars: true,
      autoApply: true,
      ranges: {
          'Hoy': [moment().startOf('day'), moment().endOf('day')],
          'Ayer': [moment().subtract(1, 'days').startOf('day'), moment().subtract(1, 'days').endOf('day')],
          'Ultimos 7 dias': [moment().subtract(6, 'days').startOf('day'), moment().endOf('day')],
          'Este mes': [moment().startOf('month').startOf('day'), moment().endOf('month').endOf('day')],
          'Este año': [moment().startOf('year').startOf('day'), moment().endOf('day')],
          'Año anterior': [
            moment().subtract(1, 'year').startOf('year').startOf('day'),
            moment().subtract(1, 'year').endOf('year').endOf('day')
          ],
          'All time': [moment('2018-01-01'), moment()],
      },
    })
  }
}
