<<<<<<< HEAD
# aws-ha-infrastructure-terraform
Proyecto de infraestructura de Alta-Disponibilidad, con ALB, ASG EC2, SSM y RDS
=======
# AWS Production Infrastructure with Terraform

Infraestructura cloud desplegada con Terraform utilizando arquitectura escalable.

## Arquitectura

- VPC multi-AZ
- Application Load Balancer
- Auto Scaling Group
- RDS MySQL
- SSM Session Manager
- CloudWatch monitoring

## Diagrama

![Architecture](diagrams/architecture.png)

## Tecnologías

- Terraform
- AWS
- EC2
- ALB
- RDS
- CloudWatch
- SSM

## Despliegue

terraform init
terraform plan
terraform apply

## Resultados

- ALB balancea tráfico entre instancias
- ASG escala automáticamente
- Acceso a instancias mediante SSM
- Monitorización con CloudWatch

## Coste estimado

Compatible con AWS Free Tier.

## Validation Tests
Pruebas end-to-end realizadas post-`terraform apply`.

**Documentación completa**: [Pruebas de Validación](docs/pruebas-validacion.pdf)

- ✅ ALB Round-Robin
- ✅ SSM Session Manager
- ✅ ASG Auto-Scaling
- ✅ RDS Connectivity

## Autor

Joel Gonzalez

![Terraform](https://img.shields.io/badge/IaC-Terraform-blue)
![AWS](https://img.shields.io/badge/Cloud-AWS-orange)
![License](https://img.shields.io/badge/license-MIT-green)
>>>>>>> de3897c (Initial commit - AWS production infrastructure with Terraform)
