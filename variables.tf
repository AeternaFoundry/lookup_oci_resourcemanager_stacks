variable "resourcemanager_stacks_lookup" {
  description = <<EOT
Map of resourcemanager_stacks_lookup, attributes below
Required:
    - compartment_id
Optional:
    - display_name
    - state
    - filter (block):
        - name (required)
        - regex (optional)
        - values (required)
EOT

  type = map(object({
    compartment_id = string
    display_name   = optional(string)
    state          = optional(string)
    filter = optional(list(object({
      name   = string
      regex  = optional(bool)
      values = list(string)
    })))
  }))
  validation {
    condition = alltrue([
      for k, v in var.resourcemanager_stacks_lookup : (
        alltrue([for item in v.stacks : (item.config_source == null || alltrue([for item in item.config_source : (item.config_source_type == null || (contains([for v in ["ZIP_UPLOAD"] : lower(v)], lower(item.config_source_type))))]))])
      )
    ])
    error_message = "must be one of: \"ZIP_UPLOAD\""
  }
}

