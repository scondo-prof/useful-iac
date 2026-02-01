locals {
  name_prefix = var.name_suffix == "" ? "${var.project}-" : "${var.project}-${var.name_suffix}-"
}
