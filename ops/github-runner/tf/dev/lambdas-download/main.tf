module "lambdas" {
  source  = "philips-labs/github-runner/aws//modules/download-lambda"
  version = "0.10.0"

  lambdas = [
    {
      name = "webhook"
      tag  = "v0.2.0"
    },
    {
      name = "runners"
      tag  = "v0.2.0"
    },
    {
      name = "runner-binaries-syncer"
      tag  = "v0.2.0"
    }
  ]
}

output "files" {
  value = module.lambdas.files
}
