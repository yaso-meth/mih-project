# Contributing to MIH Project

Thank you for your interest in contributing to the MIH Project! To help us maintain a clean, stable, and secure codebase, please review and follow these contribution guidelines.

---

## 1. Important Repository Notice (GitHub Users)

> ⚠️ **CRITICAL NOTE:** If you are viewing or found this repository on GitHub, please be aware that this is a **read-only mirror** used strictly for backup purposes. 
> 
> **No Pull Requests (PRs) or Issues will be accepted or reviewed on GitHub.**

To contribute, you must use our active development repository hosted on **MIH Git**:
🔗 [Active MIH Git Repo](https://git.mzansi-innovation-hub.co.za/yaso_meth/mih-project)

Please conduct all development, issue tracking, and collaboration on the MIH Git platform.

---

## 2. Branching Strategy & Pull/Merge Request Rules

To ensure production stability, we enforce strict branching rules. Please ensure your contributions align with the following structure:

* **Do NOT target the `main` branch:** Pull or Merge Requests made directly against the `main` branch will be automatically rejected or closed.
* **Target the Latest Version Branch:** All bug fixes, features, and documentation updates must be made against the active version branch (e.g., branch naming convention follows `v.1.4.0` or later). 

---

## 3. Recommended Workflow (Fork & Pull)

We use a **Fork-and-Pull** model to manage contributions safely and keep the main repository organized. Please follow these steps to submit your changes:

1. **Fork the Repository:** Log into **MIH Git** and click the **Fork** button on the main [mih-project](https://git.mzansi-innovation-hub.co.za/yaso_meth/mih-project) repository to create a copy under your personal account.
2. **Clone Your Fork:** Clone your personal fork locally to your machine:
   ```bash
   git clone https://git.mzansi-innovation-hub.co.za/YOUR_USERNAME/mih-project.git
   cd mih-project
   ```
3. **Checkout the Active Version Branch:** Fetch the latest branches and switch to the current active version branch (e.g., `v.1.4.0`):
   ```bash
   git fetch origin
   git checkout v.1.4.0
   ```
4. **Create a Feature or Fix Branch:** Create a dedicated branch for your changes stemming directly from that version branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```
   or
   ```bash
   git checkout -b fix/your-fix-name
   ```
5. **Commit and Push:** Make your changes, commit them with clear descriptive messages, and push the feature branch to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```
   or
   ```bash
   git push origin fix/your-fix-name
   ```
6. **Open a Pull/Merge Request:** Go to the main repository on MIH Git. You will see a prompt to open a new Pull/Merge Request. Ensure that:
   * The **Source (Head)** is your fork's feature branch (`YOUR_USERNAME/mih-project:feature/your-feature-name`).
   * The **Target (Base)** is the main repository's active version branch (`yaso_meth/mih-project:v.1.4.0`).

---

Thank you for your time and effort in helping build and improve the MIH Project!
