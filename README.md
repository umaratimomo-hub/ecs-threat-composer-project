# Production grade end-to-end ECS project
## Deployment of a threat composer web application via AWS using containerisation (Docker), IaC (Terraform), and CI/CD (Github Actions).

---

## Contents

- [Core Technologies](#core-technologies)
- [Automation & Infrastructure as Code](#automation--infrastructure-as-code)
- [DevSecOps & Security](#devsecops--security)
- [AWS Cloud Architecture](#aws-cloud-architecture)
- [Project Overview](#project-overview)
- [What is a threat composer app?](#what-is-a-threat-composer-app)
- [Why I hosted it on ECS with Fargate](#Why-i-hosted-it-on-ecs-with-fargate)
- [Expected traffic and scaling capabilities](#expected-traffic-and-scaling-capabilities)
- [Platform Engineering features](#platform-engineering-features)
- [How it works](#how-it-works)
- [Repository Structure](#repository-structure)
- [Architectural Diagram](#architectural-diagram)
- [Live app demonstration on personalised Domain](#live-app-demonstration-on-personalised-domain)
- [CI/CD Workflows](#cicd-workflows)
- [Achievements](#achievements)
- [Future Improvements](#future-improvements)

---

## Core Technologies
![](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![](https://img.shields.io/badge/GIT-E44C30?style=for-the-badge&logo=git&logoColor=white)
![](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![](https://img.shields.io/badge/Nginx-009639?style=for-the-badge&logo=nginx&logoColor=white)
![](https://img.shields.io/badge/Cloudflare_DNS-F38020?style=for-the-badge&logo=cloudflare&logoColor=white)

---

## Automation & Infrastructure as Code
![](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![](https://img.shields.io/badge/GitHub_Actions-2088FF?style=for-the-badge&logo=github-actions&logoColor=white)

---

## DevSecOps & Security
![](https://img.shields.io/badge/Hadolint_(Dockerfile)-004088?style=for-the-badge&logo=docker&logoColor=white)
![](https://img.shields.io/badge/Trivy_Image_Scanner-008080?style=for-the-badge&logo=aquasecurity&logoColor=white)
![](https://img.shields.io/badge/Trivy_Security_Scanner-008080?style=for-the-badge&logo=aquasecurity&logoColor=white)
![](https://img.shields.io/badge/AWS_ECR_Scan_On_Push-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/AWS_IAM_(OIDC)-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

---

## AWS Cloud Architecture
![](https://img.shields.io/badge/Amazon_ECS_&_Fargate-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Amazon_ECR-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Application_Load_Balancer-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Amazon_VPC-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Subnets_&_IGW-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Security_Groups-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/AWS_ACM-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![](https://img.shields.io/badge/Amazon_S3-FF9900?style=for-the-badge&logo=amazons3&logoColor=white)
![](https://img.shields.io/badge/Amazon_CloudWatch-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)

---

### Project Overview
This project aimed to demonstrate the deployment of a threat composer application from being created by a software developer and working on a local computer, all the way to being shipped live via AWS cloud and accessed by multiple teams within an environment. Along the way best practices were employed to ensure security, reliability, availability and cost were optimised as much as possible according to need and objectives. This project was built with a Platform Engineering mindset—focusing on developer self-service, automated guardrails, and reusable infrastructure to help reduce cognitive load.

---

### What is a threat composer app?
Threat Composer is an open-source threat modeling tool originally developed by AWS. It’s designed to help developers, security engineers, and architects identify and mitigate potential security vulnerabilities during the software design phase by identifying security issues and developing strategies to address them in the system context. A threat model directly supports the ability to define, agree upon, and communicate what is necessary in order to deliver a secure product or service. The Threat Composer provides a structured, dashboard-style interface where teams can document system architecture, identify threats, and assign mitigations. In my deployment, I took the application, containerized it, and hosted it securely behind an Application Load Balancer with strict HTTPS enforcement, integrating it with a fully automated CI/CD pipeline.

---

### Why I chose the Threat Composer app?
I chose the Threat Composer for three main reasons:

- Focus on DevSecOps: As a DevOps engineer, I wanted to deploy an application that reflects a security-first mindset. Deploying a threat modeling tool perfectly complements the secure pipeline I built, which includes Trivy vulnerability scanning and OIDC authentication.

- Real-World Enterprise Relevance: I wanted to move beyond basic 'Hello World' or standard to-do list apps. Threat Composer is a legitimate tool used by enterprise security teams, which proves I can take real-world, production-grade software and operationalize it.

- Containerization: It allowed me to demonstrate my ability to package a modern web application into a Docker container, optimize the Dockerfile, and push it through an Amazon ECR and ECS lifecycle.

---

### Why I hosted it on ECS with Fargate
I specifically chose Amazon ECS (Elastic Container Service) because my goal was to demonstrate deep cloud infrastructure and container orchestration skills, not just frontend hosting like that provided by platforms such as Vercel, which are best used for quick static site deployments. By using ECS, I proved that I can architect the underlying VPC, configure public/private subnets, manage routing, secure an Application Load Balancer, and write the Terraform IaC to provision it all. It shows an understanding of how the cloud actually works beyond surface level. By containerizing the app and using ECS, the deployment is immutable, self-healing (automatically replacing a crashed task), and much easier to scale horizontally without worrying about the underlying operating system.

Several benefits were obtained by using Fargate instead of deploying straight to an EC2 instance which would require manual OS patching, and underlying compute provisioning leading to a higher operational overhead. Fargate managing the server allows for more focus on infrastructure, reliability and security. As the threat composer is a simple static app which requires the user to fetch data and use within their own system, there is not much need for granular customized server control.

---

### Expected traffic and scaling capabilities
Threat Composer is a specialized engineering and security tool, and thus it was architected for an internal enterprise use case, expecting a user base of roughly up to a few hundred developers and security architects.

Traffic Patterns & Scale:

Due to the nature of the app, the load is expected to have various peaks during standard business hours, rather than being in constant demand, particularly during sprint planning or architecture review meetings.

As it is deployed on ECS behind an ALB, the architecture is scalable by default. If a large team is doing a security audit and CPU/Memory utilisation spikes, ECS can easily be configured with Auto Scaling policies to spin up additional container tasks dynamically.

Furthermore, by putting Cloudflare in front of the AWS infrastructure, all the static assets (HTML, CSS, JS) are cached at the edge. This means the actual ECS containers only need to handle core application logic, heavily reducing the compute load and allowing the app to handle hundreds of concurrent users easily.

---

### Platform Engineering features

* **"Golden Path" Deployment Pipelines:** Designed fully automated GitHub Actions workflows (`app.yml` and `infra.yml`) that abstract away AWS authentication (via OIDC) and container orchestration. Developers only need to push their code; the platform handles the build, security scans, and ECS deployment automatically.
* **Automated Guardrails & Shift-Left Security:** Integrated Trivy and Hadolint directly into the CI/CD pipeline to catch vulnerabilities and Dockerfile anti-patterns before they reach the registry. Terraform configuration is automatically verified via `terraform fmt` and `terraform validate` on every push.
* **Modular Infrastructure as Code (IaC):** Structured the Terraform codebase into reusable, logical modules (VPC, ALB, ECS, ECR). This allows for standardized, repeatable provisioning of AWS resources across different environments without duplicating code.
* **Ephemeral Environments & Lifecycle Management:** Built robust, automated teardown logic (`destroy` workflows) that systematically empties versioned S3 state buckets and force-deletes ECR repositories. This allows the team to spin up fully isolated environments for testing and tear them down to $0.00 infrastructure cost with a single click.
* **Secretless Authentication:** Replaced long-lived, static AWS IAM user keys with GitHub Actions OIDC (OpenID Connect). This eliminates the risk of leaked credentials and provides short-lived, dynamically scoped access for the deployment pipelines.

---

### How it works


---

### Repository Structure
<p align="left">
  <img width="600" src="./Images/Repository structure.png">
</p>

---

### Architectural Diagram
<p align="left">
  <img width="1000" src="./Images/architecture diagram.png">
</p> 

---

### Live app demonstration on personalised Domain
<p align="left">
  <img width="1000" src="./Images/app running.png">
</p>

---

### CI/CD Workflows
1. Workflow Linting - This workflow checks the correctness of all other workflows
<p align="left">
  <img width="1000" src="./Images/workflow linting pass.png">
</p>

2. Bootstrap workflow - create - This option of the bootstrap workflow provisions the S3 bucket via AWS CLI allowing for remote state capabilities when main infrastructure is created via terraform
<p align="left">
  <img width="1000" src="./Images/bootsrap workflow pass.png">
</p>

2. Bootstrap workflow - destroy - This option of the bootstrap workflow empties and destroys the S3 bucket upon manual input of the word 'DESTROY'.
<p align="left">
  <img width="1000" src="./Images/bootstrap destroy path pass.png">
</p>

3. Infrasructure workflow - create - This option of the Infrasructure workflow provisions all AWS services and resources via terraform (CD) only after successful testing c stages
<p align="left">
  <img width="1000" src="./Images/infra deploy workflow pass.png">
</p>

3. Infrasructure workflow - destroy - This option of the Infrasructure workflow destroys the S3 bucket upon manual input of the word 'DESTROY'.
<p align="left">
  <img width="1000" src="./Images/infra destroy path pass.png">
</p>

4. Application deploy workflow - This workflow containerises, tests (CI) and deploys (CD) the app to the ECR where it waits for infrastucture-team approval to be pulled by the ECS task service
<p align="left">
  <img width="1000" src="./Images/app-deploy workflow pass.png">
</p>

---

### Achievements
- Docker image size reduced from 840 - 33mb via lighter base image ~ 95% reduction
- Infrastructure deployement time decreased from over 2 hours clicking in console to under 5mins via terraform and Github Actions workflows
- minimising the use of hardcoded values within code by using variables where possible (aids in reducing the access to main code during ammendments, and allows for code to be resuable)
- keeping all code in accordance with DRY principles by refactoring code as much as possible (code is easier to read and follow)
- using modules in terraform (increases resuability, allows faster deployment among others)
- using VPC enpoints to connect to resources internally within AWS thus having no need for a NAT gateway leading to bennefiitss such as reduced attack surface and improved security, reduced monthly billing (NAT ~ $25pm)
- multiple workflows for Developers and DEvOps engineers PR to mimic real production environment.
- Extra environment control gate to approve of modified app before ecs image pull (protect system from breaking etc)

---



#Instructions to reproduce the setup. A short demo - optional.
