## Overview 📝

- this project automates deployment of the threat modelling composer onto **AWS**, using tools such as **Docker**, **Terraform**, **CICD pipeline** for end to end automation, and the services within **AWS**. This project began with deploying manually using the **AWS management console** using the **ECS** service to run our containers, then deploying it using **Terrafrom** for automation of infrastructure, to finally having used **CICD** to automate the whole process of the deployment from building the **docker image** to deploying the infrastructure


## Architectural diagram


![architectural diagram](/images/architecture.gif)

## Key Components

- **Docker**: We use Docker to containerise our app for faster deployments and consistency across environments

- **AWS** :
- ``ECS`` : we use fargte to run our containers without having to manage them
- ``VPC`` : we define our network where we will host our containers and other services
- ``ALB`` : we use an application load balancer to sit in front of our containers and route traffic to them
- ``Security Groups`` : we define how our resources can be accessed and what traffic is allowed in and out
- ``ECR`` : we use this to store our docker images
- ``ACM`` : used for secure HTTPS connections and enforce HTTPS redirection

- **Terraform** : Infrastrucutre as code(IaC) allows us to create our resources much quicker. Modules have been used for reusability and greater flexibility

- **Github actions**
- ``build and push``: pipeline used to build our docker image, tag it and push to our ECR repository
- ``terraform plan`` : pipeline used to initialise our terraform and compare current state and desired state to show what will be added, changed and delete
- ``terraform apply`` : pipeline used to execute the terraform plan and only runs if the plan pipeline is successful
- ``terraform destroy`` : pipeline used to destroy our infrastructure 

## Local app setup 💻

```bash
yarn install
yarn build
yarn global add serve
serve -s build

#yarn start
http://localhost:3000/workspaces/default/dashboard

## or
yarn global add serve
serve -s build
```

## Useful links 🔗

- [Terraform AWS Registry](https://registry.terraform.io/providers/hashicorp/aws/latest/docs)
- [Terraform AWS ECS](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster)
- [Terraform Docs](https://www.terraform.io/docs/index.html)
- [ECS Docs](https://docs.aws.amazon.com/ecs/latest/userguide/what-is-ecs.html)
