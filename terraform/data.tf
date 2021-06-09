data "aws_acm_certificate" "atlantis_amazon_issued" {
  domain      = "atlantis.jmvbxx.com"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}
