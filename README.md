# SkillSwap – Backend API

SkillSwap is a **Rails API + React frontend** project that allows users to **exchange skills** by creating offers and requests and matching them together.

This repository contains the **backend API**, built with **Ruby on Rails**, **PostgreSQL**, and **Devise-based authentication (JWT)**.

---

## ✨ Core Features

* User authentication using **Devise + JWT**
* Secure signup, login, and logout
* Create skill **offers** and **requests**
* Match offers ↔ requests
* Accept / reject matches
* Soft delete skills
* Clean RESTful API design

---

## 🧠 Domain Concept

The platform is based on three core concepts:

* **Users** create skills
* **Skills** represent offers or requests
* **Matches** connect one offer with one request

> Users own skills. Skills form matches. Matches track status.

---

## 🧱 Tech Stack

* **Ruby on Rails** (API mode)
* **PostgreSQL**
* **Devise** for authentication
* **JWT (devise-jwt)** for stateless API auth
* **React** (frontend – separate repo)

---

## 🗄️ Database Schema

### Users

Stores authentication and identity information.

* id
* email (unique)
* encrypted_password
* jti (JWT revocation)
* created_at / updated_at

---

### Skills

Represents a skill offer or request created by a user.

* id
* title
* description
* skill_type (`offer` or `request`)
* user_id (owner)
* deleted_at (soft delete)
* created_at / updated_at

---

### Matches

Links one offer skill with one request skill.

* id
* offer_skill_id
* request_skill_id
* status (`pending`, `accepted`, `rejected`, `cancelled`)
* created_at / updated_at

---

## 🔗 Model Relationships

* A **User** has many **Skills**
* A **Skill** belongs to one **User**
* A **Match** belongs to:

  * one offer skill
  * one request skill

Users participate in matches **through their skills**, not directly.

---

## 🔐 Authentication (Devise + JWT)

Authentication is handled using **Devise** with **JWT tokens** via `devise-jwt`.

### Auth Flow

1. User signs up or logs in
2. Server issues a JWT
3. Frontend stores the token (memory or secure storage)
4. Token is sent in the `Authorization` header
5. Devise authenticates `current_user`

Tokens are stateless and automatically revoked on logout.

---

## 🔒 Authorization Rules

* Users can only edit or delete **their own skills**
* Users cannot match their own skills
* Matches must be **offer ↔ request** only
* Only the **offer owner** can accept or reject a match
* Soft-deleted skills cannot be matched

---

## 🔌 API Overview

### Authentication

* `POST /users` – sign up
* `POST /users/sign_in` – login
* `DELETE /users/sign_out` – logout

### Skills

* `GET /skills` – list all skills
* `POST /skills` – create skill (auth required)
* `GET /skills/:id` – view skill
* `PUT /skills/:id` – update skill (owner only)
* `DELETE /skills/:id` – soft delete skill (owner only)

### Matches

* `POST /matches` – request a match
* `GET /matches` – view user’s matches
* `PUT /matches/:id/accept` – accept match
* `PUT /matches/:id/reject` – reject match

---

## 🚦 Match Lifecycle

1. Request created → `pending`
2. Offer owner responds:

   * Accept → `accepted`
   * Reject → `rejected`
3. Either side may cancel → `cancelled`

---

## 🧪 Development Notes

* API is designed for a separate React frontend
* All responses are JSON
* Authentication handled centrally by Devise
* Business rules enforced at the model and controller level

---

## 🌱 Future Enhancements

* User profiles
* Messaging between matched users
* Skill categories
* Notifications
* Admin moderation tools

---

## 🎯 Project Goal

This project is designed to:

* Teach **real-world Rails API architecture**
* Demonstrate clean data modeling
* Use **industry-standard authentication (Devise)**
* Build a portfolio-ready backend

---

## 🧠 Mental Model (Remember This)

> Users create skills.
> Skills connect via matches.
> Matches track the relationship.

---

## 📄 License

This project is for learning and portfolio purposes.
