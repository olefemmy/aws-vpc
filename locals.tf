locals {
  environment = coalesce(var.service_name, var.environment)
  account     = coalesce(var.account, var.environment)

  default_tag_keys = compact(
    [
      local.environment == "" ? "" : "Environment",
      local.account == "" ? "" : "Account",
    ],
  )

  default_tag_values = compact([local.environment, local.account])

  default_tags = zipmap(local.default_tag_keys, local.default_tag_values)
  tags         = merge(local.default_tags, var.tags)
}

