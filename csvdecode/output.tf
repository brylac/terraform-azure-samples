output "adminpw" {
  description = "The password for the admin user"
  value = "${random_string.pw.result}"
}