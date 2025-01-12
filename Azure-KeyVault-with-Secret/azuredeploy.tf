#backend
terraform {
  backend "azurerm" {
    resource_group_name  = "RG100"
    storage_account_name = "rg100store2021"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}
#Resource Groups
resource "azurerm_resource_group" "rg1" {
  name     = var.azure-rg-1
  location = var.loc1
  tags = {
    Environment = var.environment_tag
  }
}
#Create KeyVault ID
resource "random_id" "kvname" {
  byte_length = 5
  prefix      = "keyvault"
}
#Keyvault Creation
data "azurerm_client_config" "current" {}
resource "azurerm_key_vault" "kv1" {
  depends_on                  = [azurerm_resource_group.rg1]
  name                        = random_id.kvname.hex
  location                    = var.loc1
  resource_group_name         = var.azure-rg-1
  enabled_for_disk_encryption = true
  enabled_for_template_deployment = true
  enabled_for_deployment      = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    #object_id = "18d3f8e0-241f-4fb5-bf27-5dc43a65450f"
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get", "list"
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get", "list"
    ]
  }
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = "18d3f8e0-241f-4fb5-bf27-5dc43a65450f"
    
    key_permissions = [
      "get", "list"
    ]

    secret_permissions = [
      "get", "backup", "delete", "list", "purge", "recover", "restore", "set",
    ]

    storage_permissions = [
      "get", "list"
    ]
  }
  tags = {
    Environment = var.environment_tag
  }
}
#Create KeyVault VM password
resource "random_password" "vmpassword" {
  length  = 20
  special = true
}
#Create Key Vault Secret
resource "azurerm_key_vault_secret" "vmpassword" {
  name         = "vmpassword"
  value        = random_password.vmpassword.result
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
}
#Create Key Vault Secret 2
resource "azurerm_key_vault_secret" "vmpassword2021" {
  name         = "vmpassword2021"
  value        = "my-secret-123"
  key_vault_id = azurerm_key_vault.kv1.id
  depends_on   = [azurerm_key_vault.kv1]
  expiration_date = "2022-12-11T22:00:00Z"
}
