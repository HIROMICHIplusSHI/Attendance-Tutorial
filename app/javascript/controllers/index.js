// Import and register all your controllers

import { application } from "controllers/application"
import DropdownController from "controllers/dropdown_controller"
import EditBasicInfoController from "controllers/edit_basic_info_controller"

application.register("dropdown", DropdownController)
application.register("edit-basic-info", EditBasicInfoController)
