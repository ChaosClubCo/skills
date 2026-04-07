---
name: secrets-management
description: name: secrets-management description: Vault, AWS Secrets Manager, key rotation, and secure credential handling. Use when configuring, building, or troubleshooting AI agent workflows.
---

# Secrets Management

---
name: secrets-management
description: Vault, AWS Secrets Manager, key rotation, and secure credential handling
version: 1.0.0
category: infrastructure
tags: [secrets, vault, security, credentials, encryption, compliance]
related_skills: [access-management, ssl-certificates, compliance-automation]
---

## Overview

Secrets Management encompasses the secure storage, access control, rotation, and auditing of sensitive credentials including API keys, database passwords, certificates, and encryption keys. This skill covers implementing enterprise secrets management using HashiCorp Vault, AWS Secrets Manager, and related tools.

Effective secrets management is fundamental to security posture, preventing credential exposure while enabling applications to access the secrets they need. The goal is to eliminate hardcoded credentials and provide centralized, auditable secret access.

### Key Principles

1. **Zero Trust**: Never trust, always verify secret access
2. **Least Privilege**: Grant minimum necessary access
3. **Automatic Rotation**: Secrets should rotate automatically
4. **Audit Everything**: Log all secret access
5. **Encryption at Rest**: Secrets encrypted in storage

## When to Use This Skill

### Appropriate Scenarios

- Setting up centralized secrets management
- Implementing credential rotation policies
- Integrating applications with secrets stores
- Managing database credentials dynamically
- Handling encryption keys securely
- Certificate and PKI management
- Compliance with security standards
- Multi-environment secret management

### When to Consider Alternatives

- **Simple static secrets**: Environment variables may suffice for development
- **Cloud-native apps**: Native cloud secret services may be simpler
- **Single application**: Local secret files with encryption
- **Certificate focus**: Use ssl-certificates skill

## Core Processes

### 1. HashiCorp Vault Setup

```hcl
# vault-config.hcl - Vault server configuration
storage "raft" {
  path = "/vault/data"
  node_id = "vault-1"

  retry_join {
    leader_api_addr = "https://vault-1.internal:8200"
  }
  retry_join {
    leader_api_addr = "https://vault-2.internal:8200"
  }
  retry_join {
    leader_api_addr = "https://vault-3.internal:8200"
  }
}

listener "tcp" {
  address       = "0.0.0.0:8200"
  tls_cert_file = "/vault/certs/vault.crt"
  tls_key_file  = "/vault/certs/vault.key"

  telemetry {
    unauthenticated_metrics_access = true
  }
}

api_addr = "https://vault.internal:8200"
cluster_addr = "https://vault-1.internal:8201"

seal "awskms" {
  region     = "us-east-1"
  kms_key_id = "alias/vault-unseal"
}

telemetry {
  prometheus_retention_time = "30s"
  disable_hostname = true
}

ui = true
log_level = "info"
```

### 2. Vault Policies and Authentication

```hcl
# policies/app-policy.hcl
# Application secret access policy

# Read secrets for specific application
path "secret/data/applications/{{identity.entity.aliases.auth_kubernetes_*.metadata.service_account_name}}/*" {
  capabilities = ["read"]
}

# Read database credentials
path "database/creds/{{identity.entity.aliases.auth_kubernetes_*.metadata.service_account_name}}-role" {
  capabilities = ["read"]
}

# Renew own token
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Lookup own token
path "auth/token/lookup-self" {
  capabilities = ["read"]
}

---

# policies/admin-policy.hcl
# Administrator policy

# Full access to secrets engine
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage policies
path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Manage auth methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage secrets engines
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# View audit logs
path "sys/audit/*" {
  capabilities = ["read", "list"]
}
```

### 3. Dynamic Database Credentials

```bash
#!/bin/bash
# Configure dynamic PostgreSQL credentials in Vault

# Enable database secrets engine
vault secrets enable database

# Configure PostgreSQL connection
vault write database/config/production-db \
  plugin_name=postgresql-database-plugin \
  connection_url="postgresql://{{username}}:{{password}}@db.internal:5432/production?sslmode=verify-full" \
  allowed_roles="api-role,analytics-role" \
  username="vault_admin" \
  password="${DB_ADMIN_PASSWORD}"

# Create role for API service (short TTL)
vault write database/roles/api-role \
  db_name=production-db \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
    GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO \"{{name}}\"; \
    GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO \"{{name}}\";" \
  revocation_statements="REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA public FROM \"{{name}}\"; \
    DROP ROLE IF EXISTS \"{{name}}\";" \
  default_ttl="1h" \
  max_ttl="24h"

# Create role for analytics (read-only)
vault write database/roles/analytics-role \
  db_name=production-db \
  creation_statements="CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}'; \
    GRANT SELECT ON ALL TABLES IN SCHEMA public TO \"{{name}}\";" \
  default_ttl="8h" \
  max_ttl="24h"

echo "Dynamic database credentials configured"
```

### 4. Kubernetes Integration

```yaml
# Vault Agent Injector for Kubernetes
apiVersion: apps/v1
kind: Deployment
metadata:
  name: api-service
spec:
  template:
    metadata:
      annotations:
        vault.hashicorp.com/agent-inject: "true"
        vault.hashicorp.com/role: "api-service"
        vault.hashicorp.com/agent-inject-secret-database: "database/creds/api-role"
        vault.hashicorp.com/agent-inject-template-database: |
          {{- with secret "database/creds/api-role" -}}
          export DATABASE_URL="postgresql://{{ .Data.username }}:{{ .Data.password }}@db.internal:5432/production"
          {{- end }}
        vault.hashicorp.com/agent-inject-secret-config: "secret/data/applications/api-service/config"
        vault.hashicorp.com/agent-inject-template-config: |
          {{- with secret "secret/data/applications/api-service/config" -}}
          {
            "api_key": "{{ .Data.data.api_key }}",
            "encryption_key": "{{ .Data.data.encryption_key }}"
          }
          {{- end }}
    spec:
      serviceAccountName: api-service
      containers:
        - name: api
          image: api-service:latest
          command: ["/bin/sh", "-c"]
          args:
            - source /vault/secrets/database && exec node server.js
          volumeMounts:
            - name: vault-secrets
              mountPath: /vault/secrets
              readOnly: true
---
# Vault Kubernetes auth configuration
apiVersion: v1
kind: ServiceAccount
metadata:
  name: api-service
---
# ClusterRoleBinding for Vault auth
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: vault-auth-binding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:auth-delegator
subjects:
  - kind: ServiceAccount
    name: vault
    namespace: vault
```

### 5. AWS Secrets Manager Integration

```python
# secrets_manager.py - AWS Secrets Manager client
import json
import boto3
from botocore.exceptions import ClientError
from functools import lru_cache
from typing import Dict, Any, Optional
import time

class SecretsManager:
    """AWS Secrets Manager client with caching and rotation support."""

    def __init__(self, region: str = "us-east-1"):
        self.client = boto3.client('secretsmanager', region_name=region)
        self._cache: Dict[str, tuple] = {}
        self._cache_ttl = 300  # 5 minutes

    def get_secret(self, secret_name: str, version_stage: str = "AWSCURRENT") -> Dict[str, Any]:
        """Retrieve a secret with caching."""
        cache_key = f"{secret_name}:{version_stage}"

        # Check cache
        if cache_key in self._cache:
            value, timestamp = self._cache[cache_key]
            if time.time() - timestamp < self._cache_ttl:
                return value

        try:
            response = self.client.get_secret_value(
                SecretId=secret_name,
                VersionStage=version_stage
            )
        except ClientError as e:
            error_code = e.response['Error']['Code']
            if error_code == 'ResourceNotFoundException':
                raise ValueError(f"Secret {secret_name} not found")
            elif error_code == 'DecryptionFailure':
                raise PermissionError(f"Cannot decrypt secret {secret_name}")
            else:
                raise

        # Parse secret value
        if 'SecretString' in response:
            secret = json.loads(response['SecretString'])
        else:
            secret = response['SecretBinary']

        # Update cache
        self._cache[cache_key] = (secret, time.time())

        return secret

    def create_secret(self, name: str, value: Dict[str, Any], description: str = "") -> str:
        """Create a new secret."""
        response = self.client.create_secret(
            Name=name,
            Description=description,
            SecretString=json.dumps(value),
            Tags=[
                {'Key': 'ManagedBy', 'Value': 'application'},
                {'Key': 'Environment', 'Value': 'production'}
            ]
        )
        return response['ARN']

    def rotate_secret(self, secret_name: str, rotation_lambda_arn: str) -> None:
        """Enable automatic rotation for a secret."""
        self.client.rotate_secret(
            SecretId=secret_name,
            RotationLambdaARN=rotation_lambda_arn,
            RotationRules={
                'AutomaticallyAfterDays': 30
            }
        )

    def invalidate_cache(self, secret_name: Optional[str] = None) -> None:
        """Clear cached secrets."""
        if secret_name:
            keys_to_remove = [k for k in self._cache if k.startswith(secret_name)]
            for key in keys_to_remove:
                del self._cache[key]
        else:
            self._cache.clear()


# Rotation Lambda function
def rotation_handler(event, context):
    """Lambda function for secret rotation."""
    arn = event['SecretId']
    token = event['ClientRequestToken']
    step = event['Step']

    client = boto3.client('secretsmanager')

    if step == "createSecret":
        # Generate new secret
        new_password = generate_password()
        client.put_secret_value(
            SecretId=arn,
            ClientRequestToken=token,
            SecretString=json.dumps({'password': new_password}),
            VersionStages=['AWSPENDING']
        )

    elif step == "setSecret":
        # Apply the pending secret to the service
        pending = client.get_secret_value(
            SecretId=arn,
            VersionId=token,
            VersionStage='AWSPENDING'
        )
        # Update the service with new credentials
        apply_new_credentials(json.loads(pending['SecretString']))

    elif step == "testSecret":
        # Verify the new secret works
        pending = client.get_secret_value(
            SecretId=arn,
            VersionId=token,
            VersionStage='AWSPENDING'
        )
        test_credentials(json.loads(pending['SecretString']))

    elif step == "finishSecret":
        # Finalize rotation
        metadata = client.describe_secret(SecretId=arn)
        current_version = None
        for version, stages in metadata['VersionIdsToStages'].items():
            if 'AWSCURRENT' in stages:
                current_version = version
                break

        client.update_secret_version_stage(
            SecretId=arn,
            VersionStage='AWSCURRENT',
            MoveToVersionId=token,
            RemoveFromVersionId=current_version
        )
```

### 6. Key Rotation Automation

```python
# key_rotation.py - Automated key rotation
import hashlib
import secrets
from datetime import datetime, timedelta
from typing import List, Dict
import hvac

class KeyRotationManager:
    """Manages encryption key rotation."""

    def __init__(self, vault_addr: str, vault_token: str):
        self.vault = hvac.Client(url=vault_addr, token=vault_token)

    def rotate_encryption_key(self, key_name: str) -> Dict:
        """Rotate an encryption key while maintaining backward compatibility."""
        # Get current key version
        current = self.vault.secrets.transit.read_key(name=key_name)
        current_version = current['data']['latest_version']

        # Rotate to new key version
        self.vault.secrets.transit.rotate_key(name=key_name)

        # Get new key info
        new_key = self.vault.secrets.transit.read_key(name=key_name)
        new_version = new_key['data']['latest_version']

        # Update minimum decryption version after grace period
        # This should be scheduled, not immediate
        return {
            'key_name': key_name,
            'previous_version': current_version,
            'new_version': new_version,
            'rotated_at': datetime.utcnow().isoformat()
        }

    def rewrap_data(self, key_name: str, ciphertext: str) -> str:
        """Re-encrypt data with the latest key version."""
        response = self.vault.secrets.transit.rewrap_data(
            name=key_name,
            ciphertext=ciphertext
        )
        return response['data']['ciphertext']

    def batch_rewrap(self, key_name: str, ciphertexts: List[str]) -> List[str]:
        """Re-encrypt multiple values efficiently."""
        batch_input = [{'ciphertext': ct} for ct in ciphertexts]
        response = self.vault.secrets.transit.rewrap_data(
            name=key_name,
            batch_input=batch_input
        )
        return [item['ciphertext'] for item in response['data']['batch_results']]

    def set_min_decryption_version(self, key_name: str, min_version: int) -> None:
        """Set minimum version for decryption (invalidates older versions)."""
        self.vault.secrets.transit.update_key_configuration(
            name=key_name,
            min_decryption_version=min_version
        )

    def generate_data_key(self, key_name: str, context: bytes = None) -> Dict:
        """Generate a data encryption key for envelope encryption."""
        kwargs = {'name': key_name}
        if context:
            kwargs['context'] = context.decode() if isinstance(context, bytes) else context

        response = self.vault.secrets.transit.generate_data_key(
            **kwargs,
            key_type='plaintext'
        )

        return {
            'plaintext': response['data']['plaintext'],
            'ciphertext': response['data']['ciphertext']
        }


# Rotation scheduler
class RotationScheduler:
    """Schedules and tracks secret rotations."""

    def __init__(self, secrets_manager: SecretsManager):
        self.secrets_manager = secrets_manager

    def get_secrets_due_for_rotation(self, max_age_days: int = 30) -> List[Dict]:
        """Find secrets that need rotation based on age."""
        secrets = self.secrets_manager.list_secrets()
        due_for_rotation = []

        for secret in secrets:
            last_rotated = secret.get('LastRotatedDate')
            if last_rotated:
                age = (datetime.utcnow() - last_rotated.replace(tzinfo=None)).days
                if age >= max_age_days:
                    due_for_rotation.append({
                        'name': secret['Name'],
                        'arn': secret['ARN'],
                        'last_rotated': last_rotated,
                        'age_days': age
                    })

        return due_for_rotation
```

## Tools and Technologies

### Secrets Management Platforms
| Platform | Strengths | Best For |
|----------|-----------|----------|
| HashiCorp Vault | Feature-rich, multi-cloud | Enterprise, hybrid |
| AWS Secrets Manager | AWS native, simple | AWS workloads |
| Azure Key Vault | Azure native | Azure workloads |
| GCP Secret Manager | GCP native | GCP workloads |

### Key Management
| Service | Use Case | Integration |
|---------|----------|-------------|
| AWS KMS | Encryption keys | AWS services |
| Vault Transit | Encryption as service | Multi-cloud |
| HSM | Hardware security | High compliance |
| SOPS | Git-encrypted secrets | GitOps |

### Secret Injection
| Tool | Method | Platform |
|------|--------|----------|
| Vault Agent | Sidecar | Kubernetes |
| External Secrets | CRD sync | Kubernetes |
| Chamber | CLI | AWS |
| Berglas | References | GCP |

## Metrics and Monitoring

### Secret Access Monitoring

```yaml
# Prometheus alerting for secrets management
groups:
  - name: secrets_alerts
    rules:
      - alert: VaultSealed
        expr: vault_core_unsealed == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Vault cluster is sealed"

      - alert: SecretAccessAnomaly
        expr: |
          rate(vault_secret_kv_count{mount="secret"}[5m])
          > 10 * avg_over_time(vault_secret_kv_count{mount="secret"}[1h])
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Unusual secret access pattern detected"

      - alert: SecretRotationOverdue
        expr: |
          time() - vault_secret_lease_creation_time > 86400 * 30
        for: 1h
        labels:
          severity: warning
        annotations:
          summary: "Secret {{ $labels.secret }} overdue for rotation"

      - alert: HighDeniedSecretRequests
        expr: |
          rate(vault_token_create_count{auth_method!="token"}[5m]) > 0
          and rate(vault_audit_log_request_failure[5m]) > 1
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High rate of denied secret access requests"
```

## Common Pitfalls

### 1. Hardcoded Secrets
**Problem**: Secrets committed to source control
**Solution**: Use secret management and scanning tools

### 2. Long-Lived Credentials
**Problem**: Static credentials that never rotate
**Solution**: Implement automatic rotation

### 3. Over-Privileged Access
**Problem**: Applications have access to unnecessary secrets
**Solution**: Fine-grained policies and least privilege

### 4. Missing Audit Logs
**Problem**: Cannot track who accessed what secrets
**Solution**: Enable comprehensive audit logging

### 5. Single Point of Failure
**Problem**: Secrets infrastructure unavailability breaks apps
**Solution**: High availability and caching strategies

## Integration Points

### Upstream Dependencies
- **Identity Providers**: Authentication sources
- **Cloud KMS**: Encryption key management
- **Certificate Authorities**: PKI integration
- **LDAP/AD**: Enterprise identity

### Downstream Consumers
- **Applications**: Secret retrieval
- **CI/CD Pipelines**: Deployment credentials
- **Infrastructure**: Service accounts
- **Databases**: Dynamic credentials

### Secrets Flow
```
[Identity Provider] --> [Vault/Secrets Manager] <-- [KMS]
                              |
              +---------------+---------------+
              |               |               |
         [Agent/SDK]    [CI/CD Secrets]  [K8s Secrets]
              |               |               |
         [Application]   [Deployment]    [Pods]
```

## Best Practices Checklist

- [ ] No secrets in source control (scanning enabled)
- [ ] All secrets stored in centralized platform
- [ ] Automatic rotation configured
- [ ] Least privilege access policies
- [ ] Audit logging enabled and monitored
- [ ] High availability deployment
- [ ] Encryption at rest and in transit
- [ ] Dynamic credentials where possible
- [ ] Secret access alerts configured
- [ ] Regular access review process
