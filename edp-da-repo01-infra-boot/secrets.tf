# Define environment configurations in variables
variable "environments" {
  default = {
    dev = {
      git_pat                    = ""
      dbt_doc_container_name     = "doc"
      dbt_log_container_name     = "log"
      dbt_mssql_server_ehs       = "att-edp-da-sql01-dw.database.windows.net"
      dbt_mssql_database_sn_ehs  = "att-edp-da-sqldb01-dw-sn"
      dbt_mssql_database_dcs_ehs = "att-edp-da-sqldb01-dw-dcs"
      dbt_mssql_schema_ehs       = "staging"
      dbt_user_ehs               = "sqladmin"
      dbt_password_ehs           = "P@ssword1234"
      storage_conn_str           = ""
      daprod_servicenow_password = "Dummy"    
    }
    tst = {
      git_pat                    = " "
      dbt_doc_container_name     = "doc"
      dbt_log_container_name     = "log"
      dbt_mssql_server_ehs       = "att-edp-da-sql01-dw-tst.database.windows.net"
      dbt_mssql_database_sn_ehs  = "att-edp-da-sqldb01-dw-sn"
      dbt_mssql_database_dcs_ehs = "att-edp-da-sqldb01-dw-sn"
      dbt_mssql_schema_ehs       = "staging"
      dbt_user_ehs               = "sqladmin"
      dbt_password_ehs           = "P@ssword1234"
      storage_conn_str           = ""
      daprod_servicenow_password = "Dummy"
    }
    prod = {
      git_pat                    = " "
      dbt_doc_container_name     = "doc"
      dbt_log_container_name     = "log"
      dbt_mssql_server_ehs       = "att-edp-da-sql01-dw-orod.database.windows.net"
      dbt_mssql_database_sn_ehs  = "att-edp-da-sqldb01-dw-sn"
      dbt_mssql_database_dcs_ehs = "att-edp-da-sqldb01-dw-sn"
      dbt_mssql_schema_ehs       = "staging"
      dbt_user_ehs               = "sqladmin"
      dbt_password_ehs           = "P@ssword1234"
      storage_conn_str           = ""
      daprod_servicenow_password = "Dummy"
    }
  }
}

locals {
  //merge all variables from each env into a single variable key,value pair
  env_secrets = merge([
    for env, config in var.environments : {
      //replace _ with - in each secret name and convert it to upper case
      for key, value in config : upper(replace("${key}-${env}", "_", "-")) => value
    }
  ]...)
}

//Iterate over each key,value and create a secret
resource "azurerm_key_vault_secret" "environment_secrets" {
  for_each     = local.env_secrets
  name         = "${each.key}"
  value        = each.value
  key_vault_id = azurerm_key_vault.edp_kv.id
}
