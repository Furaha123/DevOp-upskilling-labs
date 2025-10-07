#  AWS S3 Cost Analysis – Task 3.1

##  1. Standard S3 Storage Pricing by Region (S3 Standard Class)

Amazon S3 Standard is designed for frequently accessed data and provides high durability and low latency across all regions.

- **us-east-1 (N. Virginia)** → This is the primary AWS region and serves as the global pricing baseline.  
  The cost is **$0.023 per GB per month**, meaning storing 1 GB for a month costs about **2.3 cents**.

- **eu-west-1 (Ireland)** → This region has similar pricing to the U.S., at **$0.023 per GB per month**.  
  It’s the main AWS hub for European workloads and offers reliable performance with comparable costs.

- **ap-southeast-1 (Singapore)** → This region is slightly more expensive at **$0.025 per GB per month**, due to higher power, infrastructure, and operational expenses in the Asia-Pacific region.

 These rates apply to the **first 50 TB** stored per month in S3 Standard. Beyond that, the price decreases slightly for larger volumes.

---

##  2. Estimated Monthly Cost for 100 GB

Let’s calculate the estimated monthly storage cost for 100 GB of data in each region:

- In **us-east-1 (Virginia)** → 100 × $0.023 = **$2.30 per month**
- In **eu-west-1 (Ireland)** → 100 × $0.023 = **$2.30 per month**
- In **ap-southeast-1 (Singapore)** → 100 × $0.025 = **$2.50 per month**

 The difference between the cheapest and most expensive region is about **$0.20 per month for 100 GB**.  
While this seems small for a lab setup, it becomes significant when storing terabytes or running large-scale production systems.

---

##  3. Data Transfer Costs Between Regions

Apart from storage, data transfer can impact total S3 costs, especially in multi-region setups.

- Uploading data **to** S3 (inbound) → **Free**.  
  AWS does not charge for data uploads.

- Transferring data **between regions** → about **$0.02 per GB**.  
  This charge applies when you replicate or move data between AWS regions (for example, from the U.S. to Europe).

- Transferring data **out to the Internet** → about **$0.09 per GB**.  
  This cost is incurred when your data is downloaded from S3 by external users or systems.

For example:  
→ Moving 10 GB from us-east-1 to eu-west-1 costs around **$0.20**.  
→ Downloading 10 GB from S3 to the Internet costs about **$0.90**.

---

##  4. Observed Pricing Differences

- **us-east-1** and **eu-west-1** have identical base pricing at **$0.023 per GB**.  
- **ap-southeast-1 (Singapore)** is roughly **9% higher** at **$0.025 per GB**.  
- All regions follow the same **volume discount tiers** (after 50 TB, rates drop to $0.022/GB).  
- When applications span multiple regions, **data transfer costs** can quickly outweigh small storage price differences.

---

##  5. Why Prices Differ by Region

AWS pricing varies across regions due to several practical and economic reasons:

 **Infrastructure and Energy Costs** – Running data centers involves costs for electricity, cooling, hardware, and land.  
Regions like Virginia benefit from cheaper power and land, while regions like Singapore face higher operational costs.

 **Taxes and Regulations** – Local tax policies (such as VAT in the EU or GST in Singapore) influence pricing.  
Compliance requirements, such as data sovereignty laws, also add administrative costs.

 **Network Connectivity** – Regions with limited fiber connectivity or fewer peering points have higher bandwidth costs.  
This can make data storage and transfer slightly more expensive.

 **Market Competition** – In regions with more cloud providers (like the U.S.), AWS lowers prices to stay competitive.  
In smaller or high-demand regions, AWS can charge slightly more.

 **Currency Exchange Rates** – AWS bills globally in USD but pays operating expenses in local currencies.  
Exchange rate fluctuations cause slight pricing adjustments between regions.

In summary:  
→ **us-east-1 (Virginia)** → Lowest cost baseline.  
→ **eu-west-1 (Ireland)** → Similar cost structure to the U.S. region.  
→ **ap-southeast-1 (Singapore)** → Slightly higher due to energy, taxes, and operational overhead.

---

##  6. Conclusion

Storing **100 GB** in S3 Standard costs roughly **$2.30 to $2.50 per month**, depending on the AWS region.  
Although the regional price difference appears small for low-volume storage, it becomes meaningful at enterprise scale when managing terabytes or replicating data across continents.