resource "azurerm_virtual_network" "vNetMySQL" {
  name                = "vNetMySQL"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name

  depends_on = [azurerm_resource_group.impactaES22Atividade02]
}

resource "azurerm_subnet" "subVnetMySQL" {
  name                 = "subVnetMySQL"
  resource_group_name  = azurerm_resource_group.impactaES22Atividade02.name
  virtual_network_name = azurerm_virtual_network.vNetMySQL.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_security_group" "nsgMySQL" {
  name                = "nsgMySQL"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name

  security_rule {
    name                       = "mysql"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "SSH"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "netintersecgroupassoc01" {
  network_interface_id      = azurerm_network_interface.ntwInterfaceMySQL.id
  network_security_group_id = azurerm_network_security_group.nsgMySQL.id
}
