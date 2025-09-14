// Import and register all your controllers

import { application } from "controllers/application"
import DropdownController from "controllers/dropdown_controller"

application.register("dropdown", DropdownController)
