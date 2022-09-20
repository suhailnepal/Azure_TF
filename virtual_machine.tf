resource "azurerm_linux_virtual_machine" "suhail_vm" {
  name                  = "suhail-machine"
  resource_group_name   = azurerm_resource_group.suhail_rg.name
  location              = azurerm_resource_group.suhail_rg.location
  size                  = "Standard_B1s"
  admin_username        = "suhailadmin"
  network_interface_ids = [azurerm_network_interface.suhail_nic.id]
  custom_data           = filebase64("customdata.tpl")
  admin_ssh_key {
    username   = "suhailadmin"
    public_key = file("~/.ssh/id_rsa.pub")
  }
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  tags = {
    environment = "dev"
  }
}

output "public_ip_address" {
  value = "${azurerm_linux_virtual_machine.suhail_vm.name}: ${data.azurerm_public_ip.suhail_ip_data.ip_address}"
}