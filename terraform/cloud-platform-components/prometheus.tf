
module "prometheus" {
  source = "github.com/ministryofjustice/cloud-platform-terraform-prometheus?ref=helm-3-upgrade"

  alertmanager_slack_receivers               = var.alertmanager_slack_receivers
  iam_role_nodes                             = data.aws_iam_role.nodes.arn
  pagerduty_config                           = var.pagerduty_config
  enable_ecr_exporter                        = terraform.workspace == local.live_workspace ? true : false
  enable_cloudwatch_exporter                 = terraform.workspace == local.live_workspace ? true : false
  enable_thanos_helm_chart                   = terraform.workspace == local.live_workspace ? true : false
  enable_prometheus_affinity_and_tolerations = terraform.workspace == local.live_workspace ? true : false

  dependence_deploy = "nothing-helm-3-is-live-now"
  dependence_opa    = helm_release.open-policy-agent
}

