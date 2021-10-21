resource "azurerm_public_ip" "public_ip_mySQL" {
  name                = "public_ip_mySQL"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "ntwInterfaceMySQL" {
  name                = "ntwInterfaceMySQL"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name

  ip_configuration {
    name                          = "myNicConfiguration"
    subnet_id                     = azurerm_subnet.subVnetMySQL.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_mySQL.id
  }
}

data "azurerm_public_ip" "ip_atividade_data_db" {
  name                = azurerm_public_ip.public_ip_mySQL.name
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name
}

resource "azurerm_linux_virtual_machine" "vm_mysql" {
  name                  = "vm_mysql"
  location              = "eastus"
  resource_group_name   = azurerm_resource_group.impactaES22Atividade02.name
  network_interface_ids = [azurerm_network_interface.ntwInterfaceMySQL.id]
  size                  = "Standard_DS1_v2"

  os_disk {
    name                 = "myOsDiskMySQL"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  computer_name                   = "mysqlvm"
  admin_username                  = var.user
  admin_password                  = var.password
  disable_password_authentication = false

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account_mysql.primary_blob_endpoint
  }

  depends_on = [azurerm_resource_group.impactaES22Atividade02]
}

output "public_ip_address_mysql" {
  value = azurerm_public_ip.public_ip_mySQL.ip_address
}

resource "azurerm_mysql_firewall_rule" "mysql-fw-rule" {
  name                = "mysql-fw-rule"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name
  server_name         = azurerm_mysql_server.mysqles22atividade02.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "time_sleep" "wait_30_seconds_db" {
  depends_on      = [azurerm_linux_virtual_machine.vm_mysql]
  create_duration = "30s"
}


