module "rds" {
  source = "./modules/rds"

  application = var.application
  rds_name = "${var.application}"
  db_apply_immediately = var.db_apply_immediately
  db_backup_retention_period = var.db_backup_retention_period
  db_engine = var.db_engine
  db_engine_version =  var.db_engine_version
  db_family_group =  var.db_family_group
  db_instance_count =  var.db_instance_count
  db_instance_type =  var.db_instance_type
  db_port =  var.db_port
  db_storage_encrypted =  var.db_storage_encrypted
  db_user = var.db_user
  vpc_id = data.aws_vpc.main.id
  serverless_config = var.serverless_config
  db_subnet_group_ids = data.aws_subnets.privates.ids

  ingress_rules =  [  { from_port = "${var.db_port}", to_port = "${var.db_port}", protocol = "tcp", cidr_blocks = [for subnet in data.aws_subnet.each_private : subnet.cidr_block] }
  ]
  egress_rules = [
    { from_port = "0", to_port = "0", protocol = "-1", cidr_blocks = ["0.0.0.0/0"] }
  ]
}