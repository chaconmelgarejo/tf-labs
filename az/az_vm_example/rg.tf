# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using azure
resource "azurerm_resource_group" "dev_rg" {
  name     = var.rg_name
  location = var.region
}