resource "aws_route53_record" "ws-primary" {
  provider = aws.ops-prod

  zone_id = "Z00181711MSGSTUK0LEP7"
  name    = "efd-dev.malt.warnerbros.com"
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_api_gateway_domain_name.efd_ws_api_domainname.regional_domain_name
  ]

}


resource "aws_route53_record" "surly-primary" {
  provider = aws.ops-prod

  zone_id = "Z00181711MSGSTUK0LEP7"
  name    = "surly-dev.malt.warnerbros.com"
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_api_gateway_domain_name.efd_surly_api_domainname.regional_domain_name
  ]

}
