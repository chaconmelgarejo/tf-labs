
# tf-labs 
# create with good vibes by: @chaconmelgarejo
# description: create with tf simple vm using azure

resource "azurerm_virtual_network" "dev-network" {
  name                = var.network_name
  resource_group_name = azurerm_resource_group.dev_rg.name
  location            = azurerm_resource_group.dev_rg.location
  address_space       = [var.network]
}

resource "azurerm_subnet" "internal" {
  name                 = var.subnet_private_name
  resource_group_name  = azurerm_resource_group.dev_rg.name
  virtual_network_name = azurerm_virtual_network.dev-network.name
  address_prefix       = var.subnet_private
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  ip_configuration {
    name                          = "testip"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_ip.id
  }
}

resource "azurerm_network_security_group" "my_sg" {
  name                = "ssh-access"
  location            = azurerm_resource_group.dev_rg.location
  resource_group_name = azurerm_resource_group.dev_rg.name

  security_rule {
    name                       = "ssh2bastion"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "web2bastion"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface_security_group_association" "my_rules" {
  network_interface_id      = azurerm_network_interface.main.id
  network_security_group_id = azurerm_network_security_group.my_sg.id
}

resource "azurerm_public_ip" "my_ip" {
  name                    = "test-ip"
  location                = azurerm_resource_group.dev_rg.location
  resource_group_name     = azurerm_resource_group.dev_rg.name
  allocation_method       = "Dynamic"
  idle_timeout_in_minutes = 30

  tags = {
    environment = "test-ip"
  }
}

