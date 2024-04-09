# resource "azuread_group" "data_analytics_dev_group" {
#   display_name = "Data Analytics Developer Group"
# }

# variable "storage_account_resource_ids" {
#   description = "List of storage account resource IDs to assign the Storage Blob Data Reader role"
#   type        = list(string)
#   default     = [
#     "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name-1}",
#     "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Storage/storageAccounts/{storage-account-name-2}",
#     # Add more storage account resource IDs as needed
#   ]
# }
# # Assign Storage Blob Data Reader role to each storage account for the group
# resource "azurerm_role_assignment" "storage_blob_data_reader" {
#   for_each            = toset(var.storage_account_resource_ids)
#   scope               = each.value
#   role_definition_name = "Storage Blob Data Reader"
#   principal_id         = azuread_group.data_analytics_dev_group.object_id
# }

# resource "azurerm_role_assignment" "log_analytics_reader" {
#   scope                = "/subscriptions/{subscription-id}/resourcegroups/{resource-group-name}/providers/Microsoft.OperationalInsights/workspaces/{log-analytics-workspace-name}"
#   role_definition_name = "Log Analytics Reader"
#   principal_id         = azuread_group.data_analytics_dev_group.object_id
# }
# resource "azurerm_role_assignment" "data_factory_contributor" {
#   scope  = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.DataFactory/factories/{data-factory-name}"
#   role_definition_name = "Data Factory Contributor"
#   principal_id         = azuread_group.data_analytics_dev_group.object_id
# }

# # SQL DB Contributor role assignment to the SQL Server
# resource "azurerm_role_assignment" "sql_db_contributor" {
#   scope                = "/subscriptions/{subscription-id}/resourceGroups/{resource-group-name}/providers/Microsoft.Sql/servers/{sql-server-name}"
#   role_definition_name = "SQL DB Contributor"
#   principal_id         = azuread_group.data_analytics_dev_group.object_id
# }