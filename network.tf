resource "azurerm_virtual_network" "suhail_vn" {
  name                = "suhail-network"
  resource_group_name = azurerm_resource_group.suhail_rg.name
  location            = azurerm_resource_group.suhail_rg.location
  address_space       = ["10.10.0.0/16"]

  tags = {
    environment = "dev"
  }
}

resource "azurerm_subnet" "suhail_subnet" {
  name                 = "suhail-subnet"
  resource_group_name  = azurerm_resource_group.suhail_rg.name
  virtual_network_name = azurerm_virtual_network.suhail_vn.name
  address_prefixes     = ["10.10.10.0/24"]
}

resource "azurerm_network_security_group" "suhail_sg" {
  name                = "suhail-sg"
  location            = azurerm_resource_group.suhail_rg.location
  resource_group_name = azurerm_resource_group.suhail_rg.name
  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_security_rule" "suhail_nsg" {
  name                        = "suhail-nsg-rule"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = var.public_ip
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.suhail_rg.name
  network_security_group_name = azurerm_network_security_group.suhail_sg.name
}

resource "azurerm_subnet_network_security_group_association" "suhail_nsg_assoc" {
  subnet_id                 = azurerm_subnet.suhail_subnet.id
  network_security_group_id = azurerm_network_security_group.suhail_sg.id
}

resource "azurerm_public_ip" "suhail_public_ip" {
  name                = "suhail-public-ip"
  resource_group_name = azurerm_resource_group.suhail_rg.name
  location            = azurerm_resource_group.suhail_rg.location
  allocation_method   = "Dynamic"

  tags = {
    environment = "dev"
  }
}

resource "azurerm_network_interface" "suhail_nic" {
  name                = "suhail-nic"
  location            = azurerm_resource_group.suhail_rg.location
  resource_group_name = azurerm_resource_group.suhail_rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.suhail_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.suhail_public_ip.id
  }
  tags = {
    environment = "dev"
  }
}

data "azurerm_public_ip" "suhail_ip_data" {
  name                = azurerm_public_ip.suhail_public_ip.name
  resource_group_name = azurerm_resource_group.suhail_rg.name
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.suhail_vm.name}: ${data.azurerm_public_ip.suhail_ip_data.ip_address}"
}
