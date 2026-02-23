module "database" {
  source       = "./modules/database"
  project_name = var.project_name
}

module "api" {
  source        = "./modules/api"
  project_name  = var.project_name
  table_name    = module.database.table_name
  table_arn     = module.database.table_arn
}

module "website" {
  source       = "./modules/website"
  project_name = var.project_name
  api_url      = module.api.api_url
}

module "cloudfront" {
  source                 = "./modules/cloudfront"
  project_name           = var.project_name
  bucket_domain_name     = module.website.bucket_regional_domain
  bucket_id              = module.website.bucket_id
}