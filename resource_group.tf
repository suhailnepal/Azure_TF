resource "azurerm_resource_group" "suhail_rg" {
  name     = "suhail_rg"
  location = "Australia East"
  tags = {
    environment = "dev"
  }
}