# GroceryMate

## 🏆 GroceryMate E-Commerce Platform

[![Python](https://img.shields.io/badge/Languages-Python%2C%20JavaScript%2C%20Terraform-blue)](https://www.python.org/)
[![OS](https://img.shields.io/badge/OS-Linux%2C%20Windows%2C%20macOS-green)](https://www.kernel.org/)
[![Database](https://img.shields.io/badge/Database-PostgreSQL-336791)](https://www.postgresql.org/)
[![GitHub Release](https://img.shields.io/github/v/release/AlejandroRomanIbanez/AWS_grocery)](https://github.com/AlejandroRomanIbanez/AWS_grocery/releases/tag/v2.0.0)
[![Free](https://img.shields.io/badge/Free_for_Non_Commercial_Use-brightgreen)](#-license)

---

## 📌 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Usage](#-usage)
- [Screenshots & Demo](#-screenshots--demo)
- [Prerequisites](#-prerequisites)
- [Local Installation](#-installation)
    - [Clone Repository](#-clone-repository)
    - [Configure PostgreSQL](#-configure-postgresql)
    - [Populate Database](#-populate-database)
    - [Set Up Python Environment](#-set-up-python-environment)
    - [Set Environment Variables](#-set-environment-variables)
    - [Start the Application](#-start-the-application)
- [Containerization](#-containerization)
- [Deployment to AWS](#-aws-deployment)
  - [From GitHub to AWS](#-from-github-to-aws)
    - [OIDC Setup](#-openid-connect-setup)
    - [GitHub Authorization](#-github-deployment-role-permissions)
  - [Bootstrap](#-bootstrapping-first-deployment)
    - [Step-by-step](#-step-by-step---rds-seeding)
    - [RDS Configuration](#rds-configuration)
  - [Run AWS Deployment](#-run-aws-deployment)
- [Architecture](#-architecture-diagram)

- [License](#-license)

## 🚀 Overview

GroceryMate is a demo application developed as part of the Masterschool program 
by **Alejandro Roman Ibanez**, and adapted for containerized deployment on 
AWS (Fargate) by **Johannes Lewen, Ph.D.**. It is a modern, full-featured 
e-commerce platform designed for seamless online grocery shopping. It provides 
an intuitive user interface and a secure backend, allowing users to browse 
products, manage their shopping basket, and complete purchases efficiently.

## 🛒 Features

- **🛡️ User Authentication**: Secure registration, login, and session
  management.
- **🔒 Protected Routes**: Access control for authenticated users.
- **🔎 Product Search & Filtering**: Browse products, apply filters, and sort by
  category or price.
- **⭐ Favorites Management**: Save preferred products.
- **🛍️ Shopping Basket**: Add, view, modify, and remove items.
- **💳 Checkout Process**:
    - Secure billing and shipping information handling.
    - Multiple payment options.
    - Automatic total price calculation.

## 📖 Usage

- Access the application at either [http://localhost:5001](http://localhost:5001) or [http:/<FARGATE_IP>:5001](http://<FARGATE_IP:5001)
- Register/Login to your account
- Browse and search for products
- Manage favorites and shopping basket
- Proceed through the checkout process


## 📸 Screenshots & Demo

![imagen](https://github.com/user-attachments/assets/ea039195-67a2-4bf2-9613-2ee1e666231a)
![imagen](https://github.com/user-attachments/assets/a87e5c50-5a9e-45b8-ad16-2dbff41acd00)
![imagen](https://github.com/user-attachments/assets/2772b85e-81f7-446a-9296-4fdc2b652cb7)

https://github.com/user-attachments/assets/d1c5c8e4-5b16-486a-b709-4cf6e6cce6bc

## 📋 Prerequisites

Ensure the following dependencies are available before running the application:

- **🐍 Python (~=3.11)**
- **🐘 PostgreSQL** – Database for storing product and user information.
- **🛠️ Git** – Version control system.
- **☁️ AWS Account** - cloud infrastructure, providing RDS, ECS, S3 and Systems Manager

## ⚙️ Installation (local)

### 🔹 Clone Repository

```sh
git clone --branch main https://github.com/jolewen/AWS_grocery.git && cd AWS_grocery
```

#### Configure PostgreSQL
Before creating the database user, you can choose a custom username and password
to enhance security. Replace `<your_secure_password>` with a strong password of
your choice in the following commands.

Create database and user:

```sh
psql -U postgres -c "CREATE DATABASE grocerymate_db;"
psql -U postgres -c "CREATE USER grocery_user WITH ENCRYPTED PASSWORD '<your_secure_password>';"  # Replace <your_secure_password> with a strong password of your choice
psql -U postgres -c "ALTER USER grocery_user WITH SUPERUSER;"
```

#### Populate Database

```sh
psql -U grocery_user -d grocerymate_db -f backend/db_backups/sqlite_dump_clean.sql
```

Verify insertion:

```sh
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM users;"
psql -U grocery_user -d grocerymate_db -c "SELECT * FROM products;"
```

### 🔹 Set Up Python Environment

Install dependencies in an activated virtual Enviroment:

```sh
cd backend
pip install -r requirements.txt
```

OR (if pip doesn't exist)

```sh
pip3 install -r requirements.txt
```

### 🔹 Set Environment Variables

Create a `.env` file:

```sh
touch .env  # macOS/Linux
ni .env -Force  # Windows
```

Generate a secure JWT key:

```sh
python3 -c "import secrets; print(secrets.token_hex(32))"
```

Update `.env`:

```sh
vim .env
```

Fill in the following information (make sure to replace the placeholders):

```ini
JWT_SECRET_KEY = <your_generated_key>
POSTGRES_USER = grocery_user
POSTGRES_PASSWORD = <your_password>
POSTGRES_DB = grocerymate_db
POSTGRES_HOST = localhost
POSTGRES_PORT = 5432
```

### 🔹 Start the Application

```sh
python3 run.py
```

## 📦 Containerization
The *grocerymate webstore* application has been packaged into a Docker image.
This allows deployment without concern for dependencies or virtualization.
The image is available in the GitHub Container Registry under *ghcr.io/jolewen/grocery_webstore*.
In case you need to make adjustments feel free to adapt the [Dockerfile](./backend/Dockerfile) to your needs, and create an image in your own repository.


## ☁️ AWS Deployment
This repo's version of grocerymate has been adapted to be deployed to AWS.
To this end, a GitHub action will containerize the code as defined by the [Dockerfile](./backend/Dockerfile).
The resulting image is stored in the GitHub container registry (ghcr.io).
To deploy the application correctly, a [bootstap action](./.github/workflows/aws-bootstrap.yml) needs to be run if starting fresh.
Followed by seeding of the database, tear down and actual deployment. 
Please follow the steps below.

### 📋 Prerequisites
All necessary AWS infrastructure components are defined via [terraform](https://registry.terraform.io/providers/hashicorp/aws/latest/docs). 
Terraform is set up to use S3 as backend to store its state. 
* Create the S3 bucket and [enter its name here](./terraform/main.tf) under "backend".
* Deploying the grocerymate webstore needs manual interaction in a bootstrapping process to populate the RDS.

### 🗄️☁️ From GitHub to AWS
Use GitHub variables to define parameters that will be injected into the application.
Please use the following recommended values:
* POSTGRES_DB=grocerymate_db
* POSTGRES_PORT=5432
* POSTGRES_USER=grocery_user
* POSTGRES_PWD=<your-password>

Deploying via GitHub actions needs read/write access to several AWS services, 
among which are S3, ECS, IAM, RDS, SSM (Parameter Store). 

#### 🔄 OpenID Connect Setup
In order for GitHub (actions) to be allowed to interact with your AWS Account,
the recommended way is to configure an "OpenID Connect (OIDC) identity provider (IdP) inside an AWS account, 
[and] use IAM roles and short-term credentials, which removes the need for IAM user access keys" ([source: GitHub](https://docs.github.com/en/actions/concepts/security/about-security-hardening-with-openid-connect))

Click this link and follow the instructions: [OpenID Connect: AWS-GitHub](https://aws.amazon.com/blogs/security/use-iam-roles-to-connect-github-actions-to-actions-in-aws/)

#### 🧑‍🔧 GitHub Deployment Role Permissions
Assuming you have set up GitHub to request a short-lived access token directly from the cloud provider (see above)
you will have to assign permissions to your GitHub deployment role. As already mentioned, several and widespread permissions have to be granted.
For the purpose of this documentation, it is assumed that your GitHub is the representation of yourself when deploying infrastructure to AWS.
Thus - even though it does not follow least-privilege - consider granting AdministratorAccess (*arn:aws:iam::aws:policy/AdministratorAccess*).

### 👢 Bootstrapping first deployment
If you are deploying the app for the first time, you will not have a snapshot to restore the RDS databse from. 
For this case, a [bootstrapping action has been provided](./.github/workflows/aws-bootstrap.yml).
It will create temporary resources such as an EC2 and RDS PostgreSQL15 instance, as well as the corresponding Security Groups.
Additionally, it will push the Postgres' *username*, *(encrypted) password*, *host*, *port* and *db name* into AWS's Systems Manager - Parameter Store.
These will be filled from your provided GitHub variables.

#### 🏃 **Step by step - RDS seeding**:
1. Save your credentials (+ port & db name) to GitHub variables and ensure that the action uses them.
2. Run the [Boostrap Action](./.github/workflows/aws-bootstrap.yml). It will:
   1. Boot up RDS with PostgreSQL version ~=15.13 on AWS. 
   2. Run an EC2 instance with *git* and *psql* being pre-installed via the user data.
   3. Store PG data (username, password, db name, host, port) an AWS SSM. 
3. Log into the instance and use the commands above to
   1. clone this repo. ```git clone --branch main https://github.com/jolewen/AWS_grocery.git && cd AWS_grocery```
   2. set up the db as you would locally, but specify the RDS as host: ```psql -h <your-db-name>.eu-central-1.rds.amazonaws.com -U postgres -d grocerymate_db -f AWS_grocery/backend/db_backup/sqlite_dump_clean.sql```
4. From EC2, log into the db and verify that a table *public.products* exists and contains data. 
5. Take an RDS snapshot.
6. Enter the snapshot name into [terraform](./terraform/rds.tf) (recomendation is to call it the same as the db)
7. Tear down on AWS (EC2 & RDS, SGs, etc.) — DO NOT REMOVE THE SNAPSHOT.

#### RDS Configuration
Terraform configures RDS and its related resources with the following
* Private subnet deployment—no public access.
* Accessible only by your app's SecurityGroup.
* Single-Zone AZ deployment, due to recreation from snapshot.


### 🧱 Run AWS Deployment
**Environment**\
Before running the [GitHub action - "AWS Deployment Workflow"](./.github/workflows/aws-deployment.yml):
Ensure that you have set all variables as GitHub variables / secrets and enabled the pipeline to access them.
Variables needed are:
* POSTGRES_DB=grocerymate_db
* POSTGRES_PORT=5432
* POSTGRES_USER=grocery_user
* POSTGRES_PWD=<your-password>

These should not be changed from the bootstrapping if applied. 

**VPC**\
Also, make sure to replace the VPC & subnet ids as well as the aws-region with the appropriate ones from your AWS account.

Finally, you should be good to go! 🚀


## 🌉 Architecture Diagram
![Architecture Diagram.png](docs/Architecture%20Diagram.png)


## 📜 License

This project is licensed under the MIT License.
