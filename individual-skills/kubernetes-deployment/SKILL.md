---
name: kubernetes-deployment
description: Deploy and manage Kubernetes applications with production-ready manifests, Helm charts, RBAC, network policies, and GitOps workflows. Use when deploying to Kubernetes, creating k8s manifests, setting up Helm charts, configuring RBAC policies, implementing network security, or managing cluster resources. Triggers on kubectl, k8s, kubernetes, helm, deployment, statefulset, service mesh, ingress, pod security, or namespace isolation.
version: 1.0.0
allowed-tools: "Bash, Read, Write, Grep"
---

# Kubernetes Deployment Skill

Deploy production-ready Kubernetes applications with security, scalability, and observability built-in.

## Common Tasks
- Create deployment manifests with resource limits, health checks, security contexts
- Design Helm charts with values templating and dependencies
- Configure RBAC for least-privilege access control
- Implement network policies for zero-trust networking
- Set up GitOps workflows with ArgoCD/FluxCD

## Core Patterns

### Production Deployment
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api
  namespace: production
spec:
  replicas: 3
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 0
  template:
    spec:
      securityContext:
        runAsNonRoot: true
        runAsUser: 1000
      containers:
      - name: api
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 500m
            memory: 512Mi
        livenessProbe:
          httpGet:
            path: /health
            port: http
        readinessProbe:
          httpGet:
            path: /ready
            port: http
```

### RBAC — Least Privilege
```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: api-role
  namespace: production
rules:
- apiGroups: [""]
  resources: ["configmaps", "secrets"]
  verbs: ["get", "list", "watch"]
```

### Network Policy — Default Deny + Allowlist
```yaml
# Default deny all ingress
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-ingress
  namespace: production
spec:
  podSelector: {}
  policyTypes:
  - Ingress
```

### HPA
```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
spec:
  minReplicas: 3
  maxReplicas: 10
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70
```

## Key Concepts

**Pod Security Standards**: Restricted > Baseline > Privileged (avoid Privileged in production)

**Resource Management**: Requests = guaranteed minimum; Limits = enforced maximum

**Health Checks**: Liveness (restart unhealthy) → Readiness (remove from service) → Startup (slow start apps)

## References

- `references/helm-chart-structure.md` — Complete Helm chart layout
- `references/rbac-patterns.md` — Common RBAC configurations
- `references/network-policies.md` — Zero-trust network examples
- `references/gitops-workflows.md` — ArgoCD/FluxCD setup

---

**Security**: Always use RBAC, network policies, pod security standards
**Testing**: Use `kubectl dry-run`, `helm template`, `kubeval` before applying