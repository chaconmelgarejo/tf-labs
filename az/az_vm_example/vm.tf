# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using azure

resource "azurerm_virtual_machine" "main-vm" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.dev_rg.location
  resource_group_name   = azurerm_resource_group.dev_rg.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = var.vm_size
  
  # this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = true

  # this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.hostname
    admin_username = var.username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.username}/.ssh/authorized_keys"
      key_data = file(var.path_key)
    }
  }

  tags = {
    environment = "${var.prefix}-vm"
  }
}
output "public_ip_address" {
  value = azurerm_public_ip.my_ip.ip_address
}