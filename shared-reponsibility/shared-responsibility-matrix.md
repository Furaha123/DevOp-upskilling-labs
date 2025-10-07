# 🛡️ AWS Shared Responsibility Model Matrix
**Understanding Security and Compliance Responsibilities**

The AWS Shared Responsibility Model defines the division of security responsibilities between AWS and the customer. AWS is responsible for the security **OF** the cloud, while customers are responsible for security **IN** the cloud.

---

## Shared Responsibility Overview

- **AWS Responsibility**: Security **OF** the cloud (infrastructure, hardware, software, networking, and facilities)
- **Customer Responsibility**: Security **IN** the cloud (data, applications, identity and access management, operating systems, network configuration)

---

## Detailed Responsibility Matrix

| Service | AWS Responsibility | Customer Responsibility |
|---------|-------------------|------------------------|
| **EC2 (Elastic Compute Cloud)** | • Physical infrastructure and hypervisor<br>• Hardware maintenance and replacement<br>• Network infrastructure and Availability Zones<br>• Hypervisor patching and security<br>• Physical security of data centers | • Operating system patching and updates<br>• Application software and utilities<br>• Security group and firewall configuration<br>• IAM roles and policies for instances<br>• Data encryption at rest and in transit<br>• Network configuration (VPC, subnets)<br>• Backup and snapshot management |
| **RDS (Relational Database Service)** | • Database engine patching and updates<br>• Hardware and infrastructure maintenance<br>• Automated backups (if enabled)<br>• High availability (Multi-AZ) infrastructure<br>• Physical security of data centers<br>• Hypervisor security | • Database access controls and user permissions<br>• Network configuration (VPC, security groups)<br>• Data encryption configuration (at rest/in transit)<br>• Database parameter groups and configuration<br>• IAM policies for RDS access<br>• Backup retention settings<br>• Application-level security |
| **S3 (Simple Storage Service)** | • Infrastructure durability (11 9's)<br>• Hardware and facility management<br>• Data replication across Availability Zones<br>• Platform maintenance and patching<br>• Physical security of storage systems | • Bucket policies and access controls<br>• IAM policies for user/role access<br>• Object encryption (SSE-S3, SSE-KMS, SSE-C)<br>• Versioning and lifecycle policies<br>• Data classification and sensitivity<br>• MFA Delete configuration<br>• Logging and monitoring (S3 Access Logs) |
| **Lambda** | • Compute infrastructure and scaling<br>• Operating system maintenance<br>• Runtime environment patching<br>• Availability and fault tolerance<br>• Physical security<br>• Hypervisor and container security | • Function code security and vulnerability management<br>• IAM execution roles and permissions<br>• Environment variables and secrets management<br>• VPC configuration (if using VPC)<br>• Third-party dependencies and libraries<br>• Data encryption in environment variables<br>• Logging and monitoring configuration |
| **ECS/Fargate** | **Fargate**:<br>• Complete infrastructure management<br>• OS patching and maintenance<br>• Container runtime security<br>• Underlying compute resources<br><br>**ECS (EC2 launch type)**:<br>• Control plane management<br>• Container orchestration platform | **Fargate**:<br>• Container images and vulnerabilities<br>• Application code security<br>• Task IAM roles and policies<br>• Network configuration and security groups<br><br>**ECS (EC2 launch type)**:<br>• EC2 instance OS patching<br>• Host security configuration<br>• Container images and security<br>• IAM roles for tasks and instances |
| **VPC (Virtual Private Cloud)** | • Network infrastructure and hardware<br>• AWS global network security<br>• Availability Zone isolation<br>• Physical network infrastructure<br>• DDoS protection infrastructure | • VPC design and IP addressing (CIDR blocks)<br>• Subnet configuration (public/private)<br>• Route table configuration<br>• Network ACL rules<br>• Security group rules<br>• Internet Gateway and NAT Gateway setup<br>• VPN and Direct Connect configuration<br>• VPC Flow Logs configuration |
| **IAM (Identity and Access Management)** | • IAM service infrastructure and availability<br>• MFA token infrastructure<br>• IAM service security and compliance<br>• Platform maintenance | • User account management and lifecycle<br>• Password policies and enforcement<br>• MFA enablement for users<br>• IAM roles and policies creation<br>• Principle of least privilege implementation<br>• Access key rotation<br>• Permission boundary definitions<br>• Federation configuration (if used) |
| **CloudFront** | • Edge location infrastructure and maintenance<br>• Global CDN network management<br>• DDoS protection (AWS Shield Standard)<br>• Physical security of edge locations<br>• Content delivery optimization | • Origin configuration (S3, ALB, custom)<br>• SSL/TLS certificate management<br>• Cache behavior and TTL configuration<br>• Access restrictions (signed URLs/cookies)<br>• WAF rules (if using AWS WAF)<br>• Logging and monitoring configuration<br>• Content encryption requirements |
| **DynamoDB** | • Infrastructure scaling and performance<br>• Data replication across AZs<br>• Hardware and facility maintenance<br>• Backup infrastructure (for on-demand backups)<br>• Platform patching and updates<br>• Physical security | • Data modeling and schema design<br>• Access control via IAM policies<br>• Encryption at rest configuration<br>• Point-in-time recovery enablement<br>• DynamoDB Streams configuration<br>• Global table setup and management<br>• Application-level data validation<br>• Query optimization and design |
| **EBS (Elastic Block Store)** | • Physical storage infrastructure<br>• Hardware replacement and maintenance<br>• Replication within Availability Zone<br>• Snapshot storage infrastructure<br>• Physical security of data centers | • Volume encryption configuration (using KMS)<br>• Snapshot creation and management<br>• Volume attachment to EC2 instances<br>• Backup and retention policies<br>• Data lifecycle management<br>• Volume type selection (gp3, io2, etc.)<br>• Performance monitoring and optimization |
| **CloudTrail** | • Service infrastructure and availability<br>• Log delivery infrastructure<br>• Platform security and maintenance<br>• Multi-region trail capability | • Trail configuration and enablement<br>• S3 bucket for log storage and permissions<br>• Log file encryption configuration<br>• CloudWatch Logs integration setup<br>• Log file validation enablement<br>• Event selector configuration<br>• Log analysis and alerting |
| **KMS (Key Management Service)** | • Hardware Security Module (HSM) management<br>• Key storage infrastructure security<br>• Platform availability and durability<br>• Physical security of key storage<br>• FIPS 140-2 compliance | • Customer Master Key (CMK) creation and management<br>• Key policies and access controls<br>• Key rotation configuration<br>• Grant management for temporary permissions<br>• Key usage monitoring and auditing<br>• Data encryption implementation in applications |

---

## Responsibility Categories

### Infrastructure Services (Higher Customer Responsibility)
**Examples**: EC2, ECS (EC2 launch type), VPC

Customers have more control and therefore more responsibility, including:
- Operating system management
- Network configuration
- Security patching
- Application stack

### Container Services (Shared Responsibility)
**Examples**: ECS with Fargate, Lambda

AWS manages more infrastructure, but customers still responsible for:
- Container/function code security
- IAM permissions
- Network configuration
- Dependencies

### Abstracted Services (Lower Customer Responsibility)
**Examples**: S3, DynamoDB, RDS, CloudFront

AWS manages most infrastructure, customers focus on:
- Data security and encryption
- Access control policies
- Configuration settings
- Data classification

---

## Key Principles

### AWS Manages: "Security OF the Cloud"
- ✅ Physical infrastructure (data centers, hardware, networking)
- ✅ Hypervisor and virtualization layer
- ✅ Global infrastructure (regions, AZs, edge locations)
- ✅ Managed service platforms and software
- ✅ Physical security and environmental controls

### Customer Manages: "Security IN the Cloud"
- ✅ Data encryption (at rest and in transit)
- ✅ Identity and Access Management (IAM)
- ✅ Operating systems and patching (for EC2)
- ✅ Network configuration (security groups, NACLs)
- ✅ Application security and code
- ✅ Data classification and protection

---

## Security Best Practices by Service

### EC2
- Enable encryption for EBS volumes
- Regularly patch OS and applications
- Use IAM roles instead of access keys
- Implement least-privilege security groups
- Enable CloudWatch monitoring and logging

### RDS
- Enable encryption at rest using KMS
- Enable automated backups with appropriate retention
- Use SSL/TLS for connections
- Implement security groups with least privilege
- Enable Multi-AZ for production databases

### S3
- Enable versioning for critical data
- Use bucket policies with least privilege
- Enable server-side encryption (SSE-S3 or SSE-KMS)
- Enable MFA Delete for sensitive buckets
- Enable access logging and CloudTrail

### Lambda
- Use environment variables for configuration
- Store secrets in AWS Secrets Manager
- Implement least-privilege IAM execution roles
- Enable X-Ray for tracing and debugging
- Regularly update function dependencies

### VPC
- Use private subnets for sensitive resources
- Implement network segmentation with multiple subnets
- Use security groups as primary firewall
- Enable VPC Flow Logs for traffic monitoring
- Use NAT Gateways for private subnet internet access

---

## Compliance Considerations

Both AWS and customers share compliance responsibilities:

| Compliance Aspect | AWS Responsibility | Customer Responsibility |
|------------------|-------------------|------------------------|
| **Infrastructure Compliance** | Maintain certifications (SOC 2, ISO 27001, PCI DSS) | Implement compliant configurations |
| **Data Residency** | Provide regional infrastructure | Choose appropriate regions for data |
| **Audit Logs** | Provide CloudTrail service | Enable and analyze CloudTrail logs |
| **Encryption** | Provide encryption capabilities | Configure and manage encryption |
| **Access Control** | Provide IAM service | Implement least-privilege policies |

---

## Summary

The Shared Responsibility Model varies by service type:

- **IaaS (Infrastructure as a Service)**: EC2, VPC - Customer has highest responsibility
- **PaaS (Platform as a Service)**: RDS, ECS - Shared responsibility increases for AWS
- **SaaS (Software as a Service)**: Lambda, S3, DynamoDB - AWS handles most infrastructure

**Key Takeaway**: As you move up the stack from IaaS to PaaS to SaaS, AWS takes on more responsibility for security and management, but customers always remain responsible for their data, access controls, and proper service configuration.

---

## References

- [AWS Shared Responsibility Model](https://aws.amazon.com/compliance/shared-responsibility-model/)
- [AWS Security Best Practices](https://aws.amazon.com/architecture/security-identity-compliance/)
- [AWS Well-Architected Framework - Security Pillar](https://docs.aws.amazon.com/wellarchitected/latest/security-pillar/welcome.html)