# Production grade end-to-end ECS project
## Deployment of a threat composer web application via AWS using containerisation (Docker), IaC (Terraform), and CI/CD (Github Actions).

![](https://img.shields.io/badge/LINUX-yellow?style=for-the-badge&logo=linux&logoColor=white) ![](https://img.shields.io/badge/AWS-orange?style=for-the-badge) ![](https://img.shields.io/badge/ECS&Fargate-orange?style=for-the-badge) ![Docker](https://img.shields.io/badge/-Docker-blue?style=for-the-badge&logo=docker&logoColor=white)  ![Terraform](https://img.shields.io/badge/-Terraform-purple?style=for-the-badge&logo=terraform&logoColor=black) ![GitHub Actions](https://img.shields.io/badge/-GitHub_Actions-blue?style=for-the-badge&logo=github-actions&logoColor=white)



## Contents

- [Project Overview](project-overview)
- [What is a threat composer app?](what-is-a-threat-composer-app?)
- [Achievements](achievements)


### Project Overview
This project aimed to demonstrate the deployment of a threat composer application from being created by a software developer and working on a local computer, all the way to being shipped live via AWS cloud and accessed by millions of users over the internet. Along the way best practices were employed to ensure security, reliability, availability and cost were optimised as much as possible according to need and obectives. Other key features include:

- minimising the use of hardcoded values within code by using variables where possible (aids in reducing the access to main code during ammendments, and allows for code to be resuable)
- keeping all code in accordance with DRY principles by refactoring code as much as possible (code is easier to read and follow)
- using modules in terraform (increases resuability, allows faster deployment among others)
- using VPC enpoints to connect to resources internally within AWS thus having no need for a NAT gateway leading to bennefiitss such as reduced attack surface and improved security, reduced monthly billing (NAT ~ $25pm)
- multiple workflows for Developers and DEvOps engineers PR to mimic real production environment.
- Extra environment control gate to approve of modified app before ecs image pull (protect system from breaking etc)

### What is a threat composer app?
Threat Composer is a threat modeling ecosystem that helps identify security issues and develop strategies to address them in the system context. The process of threat modeling helps identify security issues and develop a strategy to address them. A threat model directly supports the ability to define, agree upon, and communicate what is necessary in order to deliver a secure product or service.

### Why Fargate? 
The threat composer is a simple static app which requires the user to fetch data and use within their own system so no need for granular customized server control for a simple app. Fargate managing the server allows for more focus on infrastructure, reliability and security.

### Repository Structure
<p align="left">
  <img width="600" src="./Images/Repository structure.png">
</p>

### Architectural Diagram
<p align="left">
  <img width="1000" src="./Images/architecture diagram.png">
</p> 

### Live app demonstration on personalised Domain
<p align="left">
  <img width="1000" src="./Images/app running.png">
</p>

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




### Achievements
- Docker image size reduced from 840 - 33mb via lighter base image ~ 95% reduction
- Infrastructure deployement time decreased from over 2 hours clicking in console to under 5mins via terraform and Github Actions workflows
- 


#Instructions to reproduce the setup. A short demo - optional.
