## Overview 📝

- this project automates deployment of the threat modelling composer onto **AWS**, using tools such as **Docker**, **Terraform**, **CICD pipeline** for end to end automation, and the services within **AWS**. This project began with deploying manually using the **AWS management console** using the **ECS** service to run our containers, then deploying it using **Terraform** for automation of infrastructure, to finally having used **CICD** to automate the whole process of the deployment from building the **docker image** to deploying the infrastructure


## Architectural diagram


![architectural diagram](/images/architecture.gif)

## Key Components

- **Docker**: We use Docker to containerise our application for faster deployments and consistency across environments

- **AWS** :
- ``ECS`` : we use fargate to run our containers without having to manage them
- ``VPC`` : we define our network where we will host our containers and other services
- ``ALB`` : we use an application load balancer to sit in front of our containers and route traffic to them
- ``Security Groups`` : we define how our resources can be accessed and what traffic is allowed in and out
- ``ECR`` : we use this to store our docker images
- ``ACM`` : used for secure HTTPS connections and enforce HTTPS redirection

- **Terraform** : Infrastructure as code(IaC) allows us to create our resources much quicker. Modules have been used for reusability and greater flexibility

- **Github actions**
- ``build and push``: pipeline used to build our docker image, tag it and push to our ECR repository
- ``terraform plan`` : pipeline used to initialise our terraform and compare current state and desired state to show what will be added, changed and delete
- ``terraform apply`` : pipeline used to execute the terraform plan and only runs if the plan pipeline is successful
- ``terraform destroy`` : pipeline used to destroy our infrastructure 

## Repository setup

```
ECS-CHALLENGE/
│
├── .github/                     
│   └── workflows/               # GitHub Actions CI/CD pipeline YAMLs
│       ├── build-push.yml       # Builds Docker image, runs Trivy scan, and pushes to ECR
│       ├── tf-apply.yml         # Applies Terraform infrastructure changes
│       ├── tf-destroy.yml       # Manually triggered workflow to destroy Terraform infrastructure
│       └── tf-plan.yml          # Runs Terraform plan, TFLint, and Checkov tests
├── app/                              
│   ├── Dockerfile                  
│   ├── js/                      
│   │   ├── loader.js
│   │   └── script.js
│   └── index.html               
├── images/                       
├── Terraform/                   
│   ├── Modules/                 
│   │   ├── ALB/                
│   │   ├── ECS/      
│   │   ├── Security-Group/           
│   │   ├── VPC/            
│   │                
│   ├── backend.tf              
│   ├── locals.tf               
│   ├── main.tf                 
│   ├── outputs.tf               
│   └── providers.tf                             
├── .gitignore                   
├── README.md                
```

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

## Deployment to ECS

1. **Docker** : first we begin with testing our app locally to make sure it works then we move to containerising the app for faster deployments and consistency across environments. We use multi-staging to try and achieve the lightest image possible, in order to speed up deployment times even further. Once everything is working and we're happy with the image size we go to the AWS console and follow the instructions in order to build and tag our image and push it to the ECR repository
2. **Terraform(VPC)** : Now that we have our app containerised we begin with the infrastructure. First we define our VPC which is the section of the cloud our resources are going to run in. Within this we create 4 subnets(2 public and 2 private) and distribute them across 2 availability zones. We create an internet gateway to allow communication with our VPC and the internet. We set up a NAT gateway to allow internet access for our private subnets. We set up the 2 route tables and assign the correct subnets with them
3. **Terraform(Security groups)** : We create an ALB security group and an ECS security group to make sure the correct traffic reaches our resources. In our ALB security group we allow traffic in on HTTP(port 80) and HTTPS(port 443) to allow users over the internet to access our app. In our ECS security group we allow traffic on the port the container is running on(3000) and only allow traffic from the ALB using the ALB security group
4. **Terraform(ALB)** : We create our ALB now because when creating it within ECS it places it in the same subnets(private) which doesn't work in this case as we need it to be accessed by the internet. For our ALB we set our listeners on port 80 and port 443. When configuring the HTTP listener we put redirection to HTTPS so all traffic is automatically encrypted. For this we have to generate an ACM certificate for the domain we are going to host our app on. For our Target group we have it listen on port 3000 and target our ECS tasks. Listeners are what the ALB listens on(which ports they accept traffic from) and the target groups are where it forwards the traffic
5. **Terraform(ECS)** : We first create our cluster where our services and tasks will be run. We have to create an IAM role for ECS so it has the necessary permissions to run the containers successfully(E.g. pull the image from the ECR repository), we define the permissions in the task execution policy. Now we define our task definition which is the blueprint on how our container will be run, we make sure the correct image is used, the CPU and storage, and the port mappings. Once we have all of this we can create our service where we specify the desired number of tasks that we want to run as well as load balancing which is optional
6. **Terraform(Test)** : Once we have all our modules and variables defined we call them separately in the ``main.tf`` in the root directory. We test everything works by doing a terraform init, plan and apply


## CICD(GitHub actions)

1. **Docker build and push** : This pipeline is used to build our Docker image and push it to ECR. We first set-up our AWS environment and then build our Docker image and tag it. We use ``Trivy`` a scanning tool to scan our image for any vulnerabilities, if successful it will move to next stage and push our image to the ECR repository
2. **TF plan** : This pipeline is used so that we can view the changes terraform is going to make to our infrastructure. We use ``tflint`` and ``checkov`` to scan our terraform code for any possible errors.
3. **TF apply** : This pipeline only runs if the TF plan is successful
4. **TF destroy** : This pipeline is used to tear down the infrastructure when we are finished or don't need to host the app


## Live Demonstration

![Demo](/images/Demo.gif)


## HTTPS redirection

![Https](/images/https.gif)

