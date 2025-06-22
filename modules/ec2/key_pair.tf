resource "tls_private_key" "terraport_key" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "aws_key_pair" "terraport_keypair" {
    key_name   = "terraport_keypair.pem"
    public_key = tls_private_key.terraport_key.public_key_openssh
}

resource "local_file" "terraport_keypair_local" {
    filename        = "./keypair/terraport_keypair.pem"
    content         = tls_private_key.terraport_key.private_key_pem
    file_permission = "0600"
}