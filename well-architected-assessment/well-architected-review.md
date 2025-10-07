#  Well-Architected Framework Assessment
**Lab 1.2 – Three-Tier Web Application Architecture**

This assessment evaluates the 3-tier AWS architecture (ALB → EC2 Web/App → RDS) deployed across two Availability Zones against the **AWS Well-Architected Framework**.  
Each pillar identifies the current implementation, observed risks, and actionable improvements.

---

## 1. Operational Excellence

### Current State
- Multi-AZ deployment across us-east-1a and us-east-1b for redundancy.
- Application Load Balancer distributing traffic to web servers in public subnets.
- VPC architecture with proper subnet segmentation (public, private app, private DB).
- NAT Gateways (one per AZ) for private subnet outbound connectivity.
- RDS Multi-AZ enabled for automatic database failover.
- Basic CloudWatch integration for metrics and logs.

### Risks
- No Infrastructure as Code (IaC) - Manual provisioning leads to configuration drift and inconsistent deployments.
- Lack of automated CI/CD pipeline - Manual deployments increase human error and slow release cycles.
- No centralized logging strategy - Difficult to troubleshoot issues across multiple instances without log aggregation.

### Improvements
- Implement **Infrastructure as Code (IaC)** using AWS CloudFormation or Terraform for consistent, repeatable deployments.
- Establish **CI/CD pipeline** using AWS CodePipeline, CodeBuild, and CodeDeploy for automated testing and deployment.
- Deploy **centralized logging** with CloudWatch Logs Insights or ELK stack for aggregated log analysis.
- Create **operational runbooks** documenting deployment, scaling, backup, and incident response procedures.

---

## 2. Security

### Current State
- Network segmentation with public and private subnets across two AZs.
- Security groups acting as virtual firewalls for EC2 and RDS instances.
- Private subnets for application and database tiers (no direct internet access).
- NAT Gateways providing controlled outbound internet access for private subnets.
- RDS deployed in private subnets and not publicly accessible.
- Internet Gateway for public subnet access.

### Risks
- No encryption at rest - Data on EBS volumes and RDS not encrypted, vulnerable if physically compromised.
- No encryption in transit - Internal communication between tiers not encrypted (HTTP instead of HTTPS).
- Overly permissive security groups - May allow unnecessary access (e.g., 0.0.0.0/0 for SSH).

### Improvements
- Enable **encryption at rest** for EBS volumes and RDS using AWS KMS with customer-managed keys.
- Enable **encryption in transit** by deploying SSL/TLS certificates from ACM on ALB and enforcing HTTPS.
- Harden **security groups** following least-privilege principle (allow only required ports from specific security groups).
- Implement **AWS Secrets Manager** for database credentials instead of hardcoding in application configuration.
- Enable **VPC Flow Logs**, **CloudTrail**, and **AWS GuardDuty** for security monitoring and threat detection.

---

## 3. Reliability

### Current State
- Multi-AZ deployment across 2 Availability Zones (us-east-1a, us-east-1b).
- Application Load Balancer distributing traffic across multiple web servers.
- RDS Multi-AZ with automatic failover to standby replica.
- Redundant NAT Gateways (one per AZ) to avoid single point of failure.
- Separate subnets for each tier in each AZ.

### Risks
- No Auto Scaling configured - Cannot handle traffic spikes automatically; potential for service degradation.
- Lack of automated backup strategy - No documented backup procedures for application data and configurations.
- No disaster recovery plan - No documented RTO/RPO targets or recovery procedures.

### Improvements
- Implement **Auto Scaling Groups** for web and application tiers with scaling policies based on CPU/memory utilization.
- Configure **automated RDS backups** with 7-day retention and enable point-in-time recovery (PITR).
- Establish **disaster recovery strategy** with cross-region RDS snapshot replication and documented failover procedures.
- Implement **enhanced health checks** on ALB that verify application-level health (e.g., /health endpoint).

---

## 4. Performance Efficiency

### Current State
- Application Load Balancer distributing traffic across multiple instances.
- Multi-AZ deployment reducing latency for geographically distributed users within region.
- Private subnets for application and database tiers reducing exposure.
- RDS Multi-AZ with potential for read replicas to scale reads.

### Risks
- No content delivery network (CDN) - Static assets served from origin, increasing latency for distant users.
- Lack of caching layer - Every request potentially hits database, causing unnecessary load and slower response times.
- No read replicas for database - All database queries hit primary, limiting read scalability.

### Improvements
- Implement **Amazon CloudFront CDN** for static content delivery and reduced origin load.
- Deploy **Amazon ElastiCache** (Redis or Memcached) for caching frequently accessed data and database query results.
- Create **RDS read replicas** in each AZ to distribute read-heavy workloads and reduce load on primary database.
- Use **AWS Compute Optimizer** to analyze instance utilization and right-size EC2 and RDS instances.

---

## 5. Cost Optimization

### Current State
- On-demand EC2 instances for web and application tiers.
- RDS Multi-AZ database instance running continuously.
- NAT Gateways (2, one per AZ) incurring fixed costs (~$32/month each).
- Application Load Balancer running continuously.
- No cost monitoring or budget alerts configured.

### Risks
- On-demand instance pricing - Paying full price without Reserved Instances or Savings Plans (missing up to 72% savings).
- Over-provisioned resources - Instances may be larger than needed, running 24/7 unnecessarily.
- NAT Gateway costs - Data processing charges ($0.045/GB) can accumulate significantly with high traffic.

### Improvements
- Enable **AWS Cost Explorer** and **AWS Budgets** to monitor spending and set up budget alerts at 80%, 90%, and 100% thresholds.
- Purchase **Reserved Instances or Savings Plans** for predictable baseline workloads (up to 72% savings).
- Implement **cost allocation tags** (Environment, Application, Owner) for detailed cost tracking by team/project.
- Consider **NAT Gateway alternatives** like NAT instances or single NAT Gateway for non-production environments.
- Use **Auto Scaling** to dynamically adjust capacity and reduce idle resources during off-peak hours.

---

## 6. Sustainability

### Current State
- Multi-AZ design ensures high availability but doubles resource usage (and energy consumption).
- Resources run continuously without dynamic scaling based on actual demand.
- No sustainability metrics or carbon impact tracking configured.
- Using current generation instance types.

### Risks
- Continuous operation of NAT Gateways and RDS standby increases energy footprint.
- Lack of visibility into resource utilization and waste.
- Over-provisioned instances increase both cost and environmental impact.

### Improvements
- Implement **Auto Scaling** to dynamically adjust capacity based on demand and reduce idle resources.
- Select **latest-generation instance types** (e.g., Graviton3, C7g, M7g) for better performance per watt (up to 60% better energy efficiency).
- Right-size EC2 and RDS instances using **AWS Compute Optimizer** recommendations to eliminate waste.
- Consider **serverless components** (AWS Lambda, Aurora Serverless) for variable workloads to minimize always-on resources.
- Monitor carbon footprint using **AWS Customer Carbon Footprint Tool** to track and reduce environmental impact.

---

##  Summary

This architecture demonstrates a solid foundation in availability and isolation (multi-AZ, tiered security, network segmentation).  

**Key Strengths:**
- High availability across multiple AZs
- Proper network segmentation (public/private subnets)
- Database redundancy with Multi-AZ RDS

**Priority Improvements:**
- **Automation** (IaC, CI/CD, Auto Scaling)
- **Security hardening** (encryption at rest/transit, secrets management)
- **Cost optimization** (Reserved Instances, monitoring, right-sizing)
- **Operational maturity** (centralized logging, monitoring, runbooks)

Implementing these recommendations aligns the design with AWS Well-Architected best practices for a scalable, secure, reliable, and cost-efficient environment.