# Production grade end-to-end ECS project
## Deployment of a threat composer web application via AWS using containerisation (Docker), IaC (Terraform), and CI/CD (Github Actions).

### Project Overview
This project aimed to demonstrate the deployment of a threat composer application from being created by a software developer and working on a local computer, all the way to being shipped live via AWS cloud and accessed by millions of users over the internet. Along the way best practices were employed to ensure security, reliability, availability and cost were optimised as much as possible according to need and obectives. Other key features include:

minimising the use of hardcoded values within code by using variables where possible (aids in reducing the access to main code during ammendments, and allows for code to be resuable)
keeping all code in accordance with DRY principles by refactoring code as much as possible (code is easier to read and follow)
using modules in terraform (increases resuability, allows faster deployment among others)
no nat gateway - endpoints used more secure save nat costs ~$25 pm
PR to mimic real production environment. Extra environment control gate to approve of modified app before ecs image pull (protect system from breaking etc)
project features - aim balance security, relaibility, availability, cost


Architecture diagram (Lucidchart / draw.io / Mermaid) - make sure it's finalised and as accurate as possible to your final infrastructure. 
Screenshots of successful deployment and app running live on AWS via the domain. 
 

### What is a threat composer app?
Threat Composer is a threat modeling ecosystem that helps identify security issues and develop strategies to address them in the system context. The process of threat modeling helps identify security issues and develop a strategy to address them. A threat model directly supports the ability to define, agree upon, and communicate what is necessary in order to deliver a secure product or service.

### Why Fargate? 
Simple static app no need for granular customized server control. Fargate manages the server allows more focus on infrastruture, reliabilty and security.

### Repository Structure
<p align="left">
  <img width="600" src="./Images/Repository structure.png">
</p>


#Instructions to reproduce the setup. A short demo - optional.
