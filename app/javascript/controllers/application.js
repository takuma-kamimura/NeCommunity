import { Application } from "@hotwired/stimulus"
import { Autocomplete } from 'stimulus-autocomplete' // オートコンプリート機能のため追加

const application = Application.start()
application.register('autocomplete', Autocomplete) // オートコンプリート機能のため追加

application.debug = false
window.Stimulus   = application

export { application }
