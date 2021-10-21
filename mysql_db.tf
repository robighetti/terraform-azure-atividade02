resource "azurerm_storage_account" "storage_account_mysql" {
  name                     = "storageaccountmysql"
  resource_group_name      = azurerm_resource_group.impactaES22Atividade02.name
  location                 = "eastus"
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_mysql_server" "mysqles22atividade02" {
  name                = "mysqles22atividade02"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name

  administrator_login          = "mysqladminun"
  administrator_login_password = "H@Sh1CoR3!"

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_database" "mbadbmysql" {
  name                = "mbadbmysql"
  resource_group_name = azurerm_resource_group.impactaES22Atividade02.name
  server_name         = azurerm_mysql_server.mysqles22atividade02.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "null_resource" "upload_db" {
  provisioner "file" {
    connection {
      type     = "ssh"
      user     = var.user
      password = var.password
      host     = data.azurerm_public_ip.ip_atividade_data_db.ip_address
    }
    source      = "mysql"
    destination = "/home/azureuser"
  }
  depends_on = [time_sleep.wait_30_seconds_db]
}

resource "null_resource" "deploy_db" {
  triggers = {
    order = null_resource.upload_db.id
  }
  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = var.user
      password = var.password
      host     = data.azurerm_public_ip.ip_atividade_data_db.ip_address
    }
    inline = [
      "sudo apt-get update",
      "sudo apt-get install -y mysql-server-5.7",
      "sudo mysql < /home/azureuser/mysql/script/user.sql",
      "sudo cp -f /home/azureuser/mysql/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf",
      "sudo service mysql restart",
      "sleep 20",
    ]
  }
}
