# Production grade end-to-end ECS project
## Deployment of a threat composer web application via AWS using containerisation (Docker), IaC (Terraform), and CI/CD (Github Actions).

---

## Contents

- [Tech Stack](tech-stack)
- [AWS Resources Used](aws-resources-used)
- [Project Overview](project-overview)
- [What is a threat composer app?](what-is-a-threat-composer-app?)
- [How it works](how-it-works)
- [Repository Structure](achievements)
- [Architectural Diagram](architectural-diagram)
- [Live app demonstration on personalised Domain](live-app-demonstration-on-personalised-domain)
- [CI/CD Workflows](ci/cd-workflows)
- [Achievements](achievements)
- [Future Improvements](future-improvements)

---

## Tech Stack
![](https://img.shields.io/badge/LINUX-yellow?style=for-the-badge&logo=linux&logoColor=black) ![](https://img.shields.io/badge/AWS-orange?style=for-the-badge) ![Docker](https://img.shields.io/badge/-Docker-blue?style=for-the-badge&logo=docker&logoColor=white)  ![Terraform](https://img.shields.io/badge/-Terraform-purple?style=for-the-badge&logo=terraform&logoColor=black) ![GitHub Actions](https://img.shields.io/badge/-GitHub_Actions-blue?style=for-the-badge&logo=github-actions&logoColor=white)

---

## AWS Resources Used
![](https://img.shields.io/badge/ACM-orange?style=for-the-badge)
![](https://img.shields.io/badge/IGW-orange?style=for-the-badge)
![](https://img.shields.io/badge/VPC-orange?style=for-the-badge)
![](https://img.shields.io/badge/ALB-orange?style=for-the-badge)
![](https://img.shields.io/badge/ECR-orange?style=for-the-badge)
![](https://img.shields.io/badge/S3-orange?style=for-the-badge)
![](https://img.shields.io/badge/ECS&Fargate-orange?style=for-the-badge)


---

### Project Overview
This project aimed to demonstrate the deployment of a threat composer application from being created by a software developer and working on a local computer, all the way to being shipped live via AWS cloud and accessed by millions of users over the internet. Along the way best practices were employed to ensure security, reliability, availability and cost were optimised as much as possible according to need and obectives. 

---

### What is a threat composer app?
Threat Composer is a threat modeling ecosystem that helps identify security issues and develop strategies to address them in the system context. The process of threat modeling helps identify security issues and develop a strategy to address them. A threat model directly supports the ability to define, agree upon, and communicate what is necessary in order to deliver a secure product or service.

---

### Why Fargate? 
The threat composer is a simple static app which requires the user to fetch data and use within their own system so no need for granular customized server control for a simple app. Fargate managing the server allows for more focus on infrastructure, reliability and security.

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

2. Bootstrap workflow - This workflow provisions the S3 bucket via aws commands and allows for remote state capabilities when main infrastructure is created via terraform
<p align="left">
  <img width="1000" src="./Images/bootsrap workflow pass.png">
</p>

<p align="left">
  <img width="1000" src="./Images/bootstrap destroy path pass.png">
</p>

<p align="left">
  <img width="1000" src="./Images/infra deploy workflow pass.png">
</p>

<p align="left">
  <img width="1000" src="./Images/infra destroy path pass.png">
</p>

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

1. What is this App?
The application I deployed is Threat Composer, an open-source threat modeling tool originally developed by AWS. It’s designed to help developers, security engineers, and architects identify and mitigate potential security vulnerabilities during the software design phase.

Instead of relying on messy spreadsheets or complex diagramming tools, Threat Composer provides a structured, dashboard-style interface where teams can document system architecture, identify threats, and assign mitigations. In my deployment, I took the application, containerized it, and hosted it securely behind an Application Load Balancer with strict HTTPS enforcement, integrating it with a fully automated CI/CD pipeline.

2. Why did you choose this specific app?
I chose Threat Composer for three main reasons:

Focus on DevSecOps: As a DevOps engineer, I wanted to deploy an application that reflects a security-first mindset. Deploying a threat modeling tool perfectly complements the secure pipeline I built, which includes Trivy vulnerability scanning and OIDC authentication.

Real-World Enterprise Relevance: I wanted to move beyond basic 'Hello World' or standard to-do list apps. Threat Composer is a legitimate tool used by enterprise security teams, which proves I can take real-world, production-grade software and operationalize it.

Containerization Challenge: It allowed me to demonstrate my ability to package a modern web application into a Docker container, optimize the Dockerfile, and push it through an Amazon ECR and ECS lifecycle.

3. Why did you host it on ECS? (Why not a VM, Vercel, or Netlify?)
I specifically chose Amazon ECS (Elastic Container Service) because my goal was to demonstrate deep cloud infrastructure and container orchestration skills, not just frontend hosting.

While those platforms are fantastic for quick static site deployments, they abstract away the entire network and infrastructure layer. By using ECS, I proved that I can architect the underlying VPC, configure public/private subnets, manage routing, secure an Application Load Balancer, and write the Terraform IaC to provision it all. It shows I understand how the cloud actually works under the hood.

Deploying straight to a Linux VM requires manual OS patching, manual scaling, and higher operational overhead. By containerizing the app and using ECS, the deployment is immutable, self-healing (ECS will automatically replace a crashed task), and much easier to scale horizontally without worrying about the underlying operating system.

4. How many users are you expecting, and how does it scale?
Because Threat Composer is a specialized engineering and security tool, I architected this for an internal enterprise use case—expecting a user base of roughly 50 to 200 developers and security architects.

Traffic Patterns & Scale:

The load wouldn't be viral (like a consumer social media app). Instead, it would be 'spikey' during standard business hours, particularly during sprint planning or architecture review meetings.

Because I deployed it on ECS behind an ALB, the architecture is inherently scalable. If a large team is doing a massive security audit and CPU/Memory utilization spikes, ECS can easily be configured with Auto Scaling policies to spin up additional container tasks dynamically.

Furthermore, by putting Cloudflare in front of the AWS infrastructure, all the static assets (HTML, CSS, JS) are cached at the edge. This means the actual ECS containers only need to handle core application logic, heavily reducing the compute load and allowing the app to handle hundreds of concurrent users easily.

#Instructions to reproduce the setup. A short demo - optional.
