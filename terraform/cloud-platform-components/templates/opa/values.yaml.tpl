
opa:
  # services:
  #   controller:
  #     url: "https://www.openpolicyagent.org"
  # bundle:
  #   service: controller
  #   name: "helm-kubernetes-quickstart"
  # default_decision: "/helm_kubernetes_quickstart/main"

# To enforce mutating policies, change to MutatingWebhookConfiguration.
admissionControllerKind: ValidatingWebhookConfiguration

# To _fail closed_ on failures, change to Fail. During initial testing, we
# recommend leaving the failure policy as Ignore.
admissionControllerFailurePolicy: Fail
# Adds a namespace selector to the admission controller webhook
admissionControllerNamespaceSelector:
  matchExpressions:
    - {key: openpolicyagent.org/webhook, operator: NotIn, values: [ignore]}
# To restrict the kinds of operations and resources that are subject to OPA
# policy checks, see the settings below. By default, all resources and
# operations are subject to OPA policy checks.
admissionControllerRules:
  - operations: ["CREATE", "UPDATE"]
    apiGroups: ["extensions"]
    apiVersions: ["*"]
    resources: ["ingresses"]
  - operations: ["CREATE", "UPDATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["services"]
  - operations: ["CREATE", "UPDATE"]
    apiGroups: [""]
    apiVersions: ["v1"]
    resources: ["pods"]

mgmt:
  configmapPolicies:
    enabled: true
    namespaces: [opa] # kube-mgmt automatically discovers policies stored in ConfigMaps,created in a namespace listed here.
    requireLabel: true
  replicate:
# NOTE IF you use these, remember to update the RBAC rules above to allow
#      permissions to replicate these things
    cluster:
      - "v1/namespaces"
    namespace:
      - "extensions/v1beta1/ingresses"
    path: kubernetes

# Number of OPA replicas to deploy. OPA maintains an eventually consistent
# cache of policies and data. If you want high availability you can deploy two
# or more replicas.
replicas: 2

rbac:
  # If true, create & use RBAC resources
  #
  create: true
  rules:
    cluster:
    - apiGroups:
        - ""
      resources:
      - configmaps
      verbs:
      - update
      - patch
      - get
      - list
      - watch
    - apiGroups:
        - ""
      resources:
      - namespaces
      verbs:
      - get
      - list
      - watch
    - apiGroups:
        - extensions
      resources:
      - ingresses
      verbs:
      - get
      - list
      - watch
