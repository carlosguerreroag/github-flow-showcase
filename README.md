# 🚀 GitHub Flow Showcase: Docker + CI/CD Pipeline

![Main Branch Workflow Status](https://github.com/carlosguerreroag/github-flow-showcase/actions/workflows/main.yaml/badge.svg)
![Docker Badge](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=fff&style=for-the-badge)
![Python Badge](https://img.shields.io/badge/Python-3776AB?logo=python&logoColor=fff&style=for-the-badge)

This repository serves as a **technical demonstration** of a modern development ecosystem, following **GitHub Flow** principles, containerization with **Docker**, and continuous integration and delivery via **GitHub Actions**.

---

## 👉 Main components

* **App:** Python
* **DB:** PostgreSQL
* **Containerization:** Docker
* **CI/CD:** GitHub Actions
* **Registry:** AWS ECR
<br>

## 🔄 The Workflow (GitHub Flow)

This project adheres to a clean and agile branching strategy:

1.  **Branching:** No changes are pushed directly to `main`. Short-lived descriptive branches are used instead (`feat/`, `fix/`, `refactor/`) and then merged back to main.
2.  **Pull Requests:** Opening a PR automatically triggers the Continuous Integration (CI) pipeline.
3.  **Code Review & CI:** Code must pass all automated linting and unit tests before being eligible for approval.
4.  **Merge & Deploy:** Once merged into `main`, the Dockerized app is automatically built, tagged, and pushed to the registry.

### 👉 As for the CI|CD:

The `.github/workflows/main.yaml` file on the **main** branch orchestrates the entire application lifecycle:

**1. Continuous Integration (CI) Phase**
* **Linting:** Code quality and style standard verification.
* **Testing:** Execution of automated unit tests.
* **Security Scanning:** Dependency vulnerability analysis.

**2. Continuous Delivery (CD) Phase**
* **Docker Build:** Image creation using layer caching to optimize build speed.
* **Docker Push:** Image publication tagged with both the unique commit `SHA` and the `latest` tag for traceability.
<br>


## 💡 Best practices implemented in this project:

* **Multi-stage Dockerfiles:** Drastically reducing the final image size and attack surface.
* **Action Secrets:** Secure handling of sensitive credentials and API tokens.
* **Conventional Commits:** Ensuring a readable, standardized, and professional commit history.

---
By Carlos Guerrero - ![LinkedIn](https://linkedin.com/in/carlosguerreroaguilera)
